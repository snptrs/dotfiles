function zj --description "Fuzzy-pick a project dir (zoxide-ranked) and attach/create a Zellij session"
    # --- Dependencies ---
    for dep in zellij fzf
        if not type -q $dep
            echo "zj: $dep not found in PATH" >&2
            return 127
        end
    end

    # --- Project roots ---
    # Optional overrides:
    # - ZJ_PROJECTS_ROOT (default: ~/Code/Projects)
    # - ZJ_ELEVATE_ROOT (default: $ZJ_PROJECTS_ROOT/elevate)
    # - ZJ_SEARCH_ROOTS (fish list of roots to search one level deep)
    # - ZJ_SPECIFIC_PATHS (fish list of extra directories to include directly)
    set -l projects_root "$HOME/Code/Projects"
    set -q ZJ_PROJECTS_ROOT; and set projects_root $ZJ_PROJECTS_ROOT

    set -l elevate_root "$projects_root/elevate"
    set -q ZJ_ELEVATE_ROOT; and set elevate_root $ZJ_ELEVATE_ROOT

    set -l search_roots $projects_root
    if set -q ZJ_SEARCH_ROOTS
        set search_roots $ZJ_SEARCH_ROOTS
    else
        test -d "$elevate_root"; and set -a search_roots $elevate_root
    end

    set -l specific_paths
    set -q ZJ_SPECIFIC_PATHS; and set specific_paths $ZJ_SPECIFIC_PATHS

    # --- Zellij switching ---
    # When running inside Zellij, we cannot call `zellij attach ...` without nesting a new Zellij UI.
    # Zellij *does* support switching the current client to a different session via the plugin API.
    # We use a tiny helper plugin (zellij-switch) and trigger it via `zellij pipe`.
    set -l zellij_switch_plugin_path "$HOME/.config/zellij/plugins/zellij-switch.wasm"
    set -q ZJ_ZELLIJ_SWITCH_PLUGIN_PATH; and set zellij_switch_plugin_path $ZJ_ZELLIJ_SWITCH_PLUGIN_PATH

    set -l zellij_switch_plugin_url "https://github.com/mostafaqanbaryan/zellij-switch/releases/download/0.2.1/zellij-switch.wasm"
    set -q ZJ_ZELLIJ_SWITCH_PLUGIN_URL; and set zellij_switch_plugin_url $ZJ_ZELLIJ_SWITCH_PLUGIN_URL

    # Layout name passed to zellij-switch when creating sessions.
    set -l zellij_layout project
    set -q ZJ_ZELLIJ_LAYOUT; and set zellij_layout $ZJ_ZELLIJ_LAYOUT

    # Initial query (eg: `zj sidekick`)
    set -l initial_query (string join " " -- $argv)

    # Escape default projects root for deriving session names.
    set -l projects_root_re (string escape --style=regex -- $projects_root)
    set -l status_running_icon "✅"
    set -l status_exited_icon "🧟"
    set -l status_new_icon -

    # --- Candidate directory collection ---
    # Collect zoxide-ranked paths first (preserves frecency ordering), then discovered paths.
    set -l zoxide_candidates
    if type -q zoxide
        set -l allowed_patterns
        for root in $search_roots
            test -d "$root"; or continue
            set -l root_re (string escape --style=regex -- $root)
            set -a allowed_patterns "^$root_re/[^/]+\$"
        end
        if test (count $allowed_patterns) -gt 0
            set -l allowed_re (string join "|" -- $allowed_patterns)
            set zoxide_candidates (zoxide query -l 2>/dev/null | string match -r -- $allowed_re)
        end
    end

    set -l discovered_candidates
    for root in $search_roots
        test -d "$root"; or continue
        if type -q fd
            set -a discovered_candidates (fd -t d -d 1 . "$root" --absolute-path 2>/dev/null)
        else
            set -a discovered_candidates (find "$root" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
        end
    end

    # Merge into one ordered set: normalize, filter, and dedupe in one pass.
    set -l ranked_dirs
    for candidate_dir in $zoxide_candidates $discovered_candidates
        set -l normalized_dir (string replace -r -- '/+$' '' "$candidate_dir")
        test -d "$normalized_dir"; or continue
        test "$normalized_dir" != "$elevate_root"; or continue
        contains -- "$normalized_dir" $ranked_dirs; and continue
        set -a ranked_dirs $normalized_dir
    end

    for explicit_dir in $specific_paths
        set -l normalized_dir (string replace -r -- '/+$' '' "$explicit_dir")
        test -d "$normalized_dir"; or continue
        contains -- "$normalized_dir" $ranked_dirs; and continue
        set -a ranked_dirs $normalized_dir
    end

    if test (count $ranked_dirs) -eq 0
        echo "zj: no projects found in configured roots" >&2
        return 1
    end

    # --- Session inventory ---
    # Gather session state once so we can display which projects already have sessions.
    # Output format: "NAME [Created ...] (EXITED ...)" — split on " [" to extract the name
    # robustly (handles names with spaces). No --json flag is available as of Zellij 0.42.
    set -l running_sessions
    set -l exited_sessions
    for line in (zellij list-sessions --no-formatting 2>/dev/null)
        set -l s_name (string split -m1 ' [' -- $line)[1]
        test -n "$s_name"; or continue
        if string match -q '*EXITED*' -- "$line"
            set -a exited_sessions $s_name
        else
            set -a running_sessions $s_name
        end
    end

    # --- fzf rows ---
    set -l tab (printf '\t')
    set -l running_rows
    set -l exited_rows
    set -l new_rows
    for project_dir in $ranked_dirs
        # Session name from relative path when under $projects_root; otherwise use basename.
        set -l relative_dir (string replace -r -- "^$projects_root_re/" "" "$project_dir")
        if test "$relative_dir" = "$project_dir"
            set relative_dir (path basename -- "$project_dir")
        end
        set -l session_name (string replace -a -- "/" "__" "$relative_dir")
        set session_name (string replace -ar -- "[^A-Za-z0-9_-]+" "_" "$session_name")

        set -l session_state $status_new_icon
        if contains -- "$session_name" $running_sessions
            set session_state $status_running_icon
        else if contains -- "$session_name" $exited_sessions
            set session_state $status_exited_icon
        end

        # Build a fixed-width display line so columns align even if tab rendering is odd.
        set -l session_name_padded (string pad -r -w 28 -- "$session_name")
        set -l display_line (printf '%-4s %s  %s' "$session_state" "$session_name_padded" "$project_dir")

        # Keep raw session + dir as hidden columns for reliable parsing.
        set -l row "$session_name$tab$project_dir$tab$display_line"

        # Group running sessions first, then exited, then new, while keeping zoxide ordering within
        # each group.
        if test "$session_state" = "$status_running_icon"
            set -a running_rows $row
        else if test "$session_state" = "$status_exited_icon"
            set -a exited_rows $row
        else
            set -a new_rows $row
        end
    end

    set -l fzf_rows $running_rows $exited_rows $new_rows

    set -l selection (printf "%s\n" $fzf_rows | fzf \
        --prompt="zellij> " \
        --height=60% \
        --reverse \
        --query="$initial_query" \
        --delimiter="$tab" \
        --with-nth=3)
    test -n "$selection"; or return 0

    set -l selection_parts (string split -m2 -- $tab $selection)
    set -l session $selection_parts[1]
    set -l dir $selection_parts[2]

    # Inside Zellij: switch sessions in-place (no nesting) via `zellij pipe` + helper plugin.
    if set -q ZELLIJ
        if set -q ZELLIJ_SESSION_NAME; and test "$ZELLIJ_SESSION_NAME" = "$session"
            echo "zj: already in session '$session'"
            return 0
        end

        if not test -f "$zellij_switch_plugin_path"
            if not type -q curl
                echo "zj: missing $zellij_switch_plugin_path and curl is not available to download it" >&2
                return 127
            end
            mkdir -p (path dirname -- "$zellij_switch_plugin_path")
            curl -fsSL "$zellij_switch_plugin_url" -o "$zellij_switch_plugin_path"; or begin
                echo "zj: failed to download zellij-switch plugin from $zellij_switch_plugin_url" >&2
                return 1
            end
        end

        # The plugin payload is parsed with shell-words, so we must quote paths safely.
        # NOTE: If this is the first time this plugin runs, Zellij may prompt to allow permissions
        # (ChangeApplicationState/ReadApplicationState). Focus the prompt and press `y`.
        set -l session_escaped (string escape --style=script -- "$session")
        set -l dir_escaped (string escape --style=script -- "$dir")
        # Including --cwd and --layout lets the plugin create the session at the correct directory
        # when it doesn't yet exist (or resurrect an exited one).
        # NOTE: The zellij-switch plugin wraps the layout as LayoutInfo::File("<name>.kdl"),
        # so the layout must exist as a file in the layouts dir (built-in names won't work).
        set -l layout_escaped (string escape --style=script -- "$zellij_layout")
        set -l payload "--session $session_escaped --cwd $dir_escaped --layout $layout_escaped"

        zellij pipe --plugin "file:$zellij_switch_plugin_path" -- "$payload"
        return $status
    end

    # Outside Zellij: attach/create with the selected default layout.
    # Existing sessions keep their current layout/state; this affects newly created sessions.
    # Use pushd/popd so the parent shell's cwd is restored after zellij exits.
    pushd "$dir"; or return 1
    zellij attach -c "$session" options --default-layout "$zellij_layout"
    popd
end
