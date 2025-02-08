function mkcd --description 'Create directory and change to it'
    mkdir -p "$argv[1]"
    if test -d "$argv[1]"
        cd $argv[1]
    end
end
