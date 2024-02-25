function pj

set session (fd --color=always -d 1 -t d --hidden . ~/Code/Projects ~/Work/Code/Projects ~/Code/Projects/ipecs-connect 2>/dev/null | fzf --ansi)
set session_name (basename "$session")
wezterm cli spawn --cwd $session --workspace $session_name --new-window

# if not tmux has-session -t "$session_name"
  # tmux new-session -A -s "$session_name" -c "$session"
# end

# tmux switch-client -t "$session_name"

end
