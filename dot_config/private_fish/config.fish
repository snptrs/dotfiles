set -g fish_greeting

if status is-interactive
  # Commands to run in interactive sessions can go here
  # test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
  set -gx EDITOR "nvim"
  set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"
  set -a fish_function_path ~/.config/fish/functions/sp
  set -Ux BAT_THEME "base16"
  set -gx fzf_diff_highlighter delta --diff-so-fancy --width=20 --paging=never

  bind \ec 'pet-select'
  bind \cs 'history-pager'
  set -gx LS_COLORS (vivid generate rose-pine)

  abbr -a cht cht.sh
  abbr -a chts cht.sh --shell
  abbr -a snb snibbets
  abbr -a lg lazygit
  abbr -a cm chezmoi
  abbr -a tm tmux
  abbr -a pss "pet search --color"
  abbr -a dotdot --regex '^\.\.+$' --function multicd

  # _nvm_use_on_pwd_change
  zoxide init fish | source
end
