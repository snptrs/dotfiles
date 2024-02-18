set -g fish_greeting

if status is-interactive
  # Commands to run in interactive sessions can go here
  test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
end

set -Ux EDITOR "nvim"
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
set -a fish_function_path ~/.config/fish/functions/sp
set -Ux BAT_THEME "base16"
set -gx fzf_diff_highlighter delta --diff-so-fancy --width=20 --paging=never

# set fish_cursor_default block
# set fish_cursor_insert block blink
# set fish_cursor_replace_one underscore blink
# set fish_cursor_replace underscore blink
# set fish_cursor_external line

# fish_vi_key_bindings --no-erase insert
bind \cs 'pet-select'

