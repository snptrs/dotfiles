function pet-select
    commandline -f repaint
    set -l query (commandline)
    pet clip --query $query </dev/tty >/dev/tty
end
