function pet-select
  set -l query (commandline)
  commandline -f repaint
  pet search --color --query "$query" $argv | read cmd
  and commandline $cmd
end
