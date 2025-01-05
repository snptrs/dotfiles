function pj
    commandline -f repaint
    set session (fd --color=always -d 1 -t d --hidden . ~/Code/Projects ~/Work/Code/Projects ~/Code/Projects/ipecs-connect 2>/dev/null | fzf --ansi)
    and commandline $cmd
    set fzf_status $status
    set session_name (basename "$session")
    # wezterm cli spawn --cwd $session --workspace $session_name --new-window

    if test $fzf_status -eq 0
        clear
        cd $session
    end

    # if not tmux has-session -t "$session_name"
    # tmux new-session -A -s "$session_name" -c "$session"
    # end

    # tmux switch-client -t "$session_name"
end
