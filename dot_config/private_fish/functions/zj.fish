function zj --description "Fuzzy-pick a project dir (zoxide-ranked) and attach/create a Zellij session"
    if not type -q zellij
        echo "zj: zellij not found in PATH" >&2
        return 127
    end
    if not type -q fzf
        echo "zj: fzf not found in PATH" >&2
        return 127
    end

    set -l projects_root "$HOME/Code/Projects"
    set -l elevate_root "$projects_root/elevate"

    # When running inside Zellij, we cannot call `zellij attach ...` without nesting a new Zellij UI.
    # Zellij *does* support switching the current client to a different session via the plugin API.
    # We use a tiny helper plugin (zellij-switch) and trigger it via `zellij pipe`.
    set -l zellij_switch_plugin_path "$HOME/.config/zellij/plugins/zellij-switch.wasm"
    set -l zellij_switch_plugin_url "https://github.com/mostafaqanbaryan/zellij-switch/releases/download/0.2.1/zellij-switch.wasm"
    set -l zellij_switch_plugin_sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"  # v0.2.1

    # Initial query (eg: `zj sidekick`)
    set -l initial_query (string join " " -- $argv)

    # Escape roots for use in regexes.
    set -l projects_root_re (string escape --style=regex -- $projects_root)
    set -l elevate_root_re (string escape --style=regex -- $elevate_root)

    # 1) Collect raw dirs: zoxide-ranked first (for ordering), then fd/find discovered.
    set -l raw_zoxide
    if type -q zoxide
        set -l allowed_re "^$projects_root_re/[^/]+\$|^$elevate_root_re/[^/]+\$"
        set raw_zoxide (zoxide query -l 2>/dev/null | string match -r -- $allowed_re)
    end

    set -l search_roots $projects_root
    test -d "$elevate_root"; and set -a search_roots $elevate_root

    set -l raw_discovered
    for root in $search_roots
        if type -q fd
            set -a raw_discovered (fd -t d -d 1 . "$root" --absolute-path 2>/dev/null)
        else
            set -a raw_discovered (find "$root" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
        end
    end

    # 2) Merge into a single ranked list: normalize, filter, and deduplicate in one pass.
    set -l ranked
    for d in $raw_zoxide $raw_discovered
        set -l d_norm (string replace -r -- '/+$' '' "$d")
        test -d "$d_norm"; or continue
        test (path basename -- "$d_norm") != "elevate"; or continue
        contains -- "$d_norm" $ranked; and continue
        set -a ranked $d_norm
    end

    if test (count $ranked) -eq 0
        echo "zj: no projects found under $projects_root" >&2
        return 1
    end

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

    set -l tab (printf '\t')
    set -l fzf_lines_running
    set -l fzf_lines_exited
    set -l fzf_lines_new
    for d in $ranked
        # Session name from relative path, eg: elevate/foo -> elevate__foo
        set -l rel (string replace -r -- "^$projects_root_re/" "" "$d")
        set -l sess (string replace -a -- "/" "__" "$rel")
        set sess (string replace -ar -- "[^A-Za-z0-9_-]+" "_" "$sess")

        set -l state -
        if contains -- "$sess" $running_sessions
            set state ✅
        else if contains -- "$sess" $exited_sessions
            set state 🧟
        end

        # Build a fixed-width display line so columns align even if tab rendering is odd.
        set -l sess_padded (string pad -r -w 28 -- "$sess")
        set -l display_line (printf '%-4s %s  %s' "$state" "$sess_padded" "$d")

        # Keep raw session + dir as hidden columns for reliable parsing.
        set -l item "$sess$tab$d$tab$display_line"

        # Group running sessions first, then exited, then new, while keeping zoxide ordering within
        # each group.
        if test "$state" = "✅"
            set -a fzf_lines_running $item
        else if test "$state" = "🧟"
            set -a fzf_lines_exited $item
        else
            set -a fzf_lines_new $item
        end
    end

    set -l fzf_lines $fzf_lines_running $fzf_lines_exited $fzf_lines_new

    set -l selection (printf "%s\n" $fzf_lines | fzf \
        --prompt="zellij> " \
        --height=60% \
        --reverse \
        --query="$initial_query" \
        --delimiter="$tab" \
        --with-nth=3)
    test -n "$selection"; or return 0

    set -l parts (string split -m2 -- $tab $selection)
    set -l session $parts[1]
    set -l dir $parts[2]

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
            if not type -q shasum
                echo "zj: shasum is required to verify plugin integrity" >&2
                return 127
            end

            mkdir -p (path dirname -- "$zellij_switch_plugin_path")
            
            set -l temp_plugin (mktemp)
            curl -fsSL "$zellij_switch_plugin_url" -o "$temp_plugin"; or begin
                echo "zj: failed to download zellij-switch plugin from $zellij_switch_plugin_url" >&2
                rm -f "$temp_plugin"
                return 1
            end
            
            # Verify SHA256 checksum before using the plugin
            set -l actual_hash (shasum -a 256 "$temp_plugin" | string split ' ')[1]
            if test "$actual_hash" != "$zellij_switch_plugin_sha256"
                echo "zj: plugin checksum mismatch! Expected: $zellij_switch_plugin_sha256" >&2
                echo "zj: Got: $actual_hash" >&2
                rm -f "$temp_plugin"
                return 1
            end
            
            # Atomic move to final location
            mv "$temp_plugin" "$zellij_switch_plugin_path"
        end

        # The plugin payload is parsed with shell-words, so we must quote paths safely.
        # NOTE: If this is the first time this plugin runs, Zellij may prompt to allow permissions
        # (ChangeApplicationState/ReadApplicationState). Focus the prompt and press `y`.
        set -l session_escaped (string escape --style=script -- "$session")
        set -l dir_escaped (string escape --style=script -- "$dir")
        # Including --cwd and --layout lets the plugin create the session at the correct directory
        # when it doesn't yet exist (or resurrect an exited one).
        set -l payload "--session $session_escaped --cwd $dir_escaped --layout default"

        zellij pipe --plugin "file:$zellij_switch_plugin_path" -- "$payload"
        return $status
    end

    # Outside Zellij: attach/create normally (Zellij will resurrect prior state if available).
    cd "$dir"; or return 1
    zellij attach -c "$session"
end
