set -g fish_greeting

if status is-interactive
  # Commands to run in interactive sessions can go here
  test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
end

set -gx EDITOR "nvim"
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set -a fish_function_path ~/.config/fish/functions/sp
set -gx BAT_THEME "TwoDark"
set -gx fzf_diff_highlighter delta --diff-so-fancy --width=20 --paging=never
