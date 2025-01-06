function mkcd --description 'Create directory and change to it'
    mkdir "$argv[1] -p"
    if test -d "$argv[1]"
        cd $argv[1]
    end
end
