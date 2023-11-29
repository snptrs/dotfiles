abbr -a cht cht.sh
abbr -a chts cht.sh --shell
abbr -a abbrconf nvim ~/.config/fish/conf.d/abbr.fish
abbr -a snb snibbets
abbr -a lg lazygit
abbr -a cm chezmoi

function multicd; echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../); end
abbr --add dotdot --regex '^\.\.+$' --function multicd
