function tmpj

set session (fd -d 1 -t d --hidden . ~/Code/Projects ~/Code/Projects/ipecs-connect 2>/dev/null | fzf)
set session_name (basename "$session")

# if not tmux has-session -t "$session_name"
  cd session
  tmux new-session -A -s "$session_name" -c "$session"
# end

tmux switch-client -t "$session_name"

end
