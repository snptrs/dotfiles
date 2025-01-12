function __rgignore.error
    echo "Error: $argv[1]" >&2
    return 1
end

function rgignore -d "Add a ripgrep ignore file (.rgignore) with specified patterns (or defaults)"
    set -l rgignore_file ".rgignore"
    set -l gitignore_file ".gitignore"
    set -l default_patterns "!.env"

    argparse 'p/patterns=+' f/force a/append l/list y/yes e/edit -- $argv
    or return 1

    if set -q _flag_edit
        if not test -e $rgignore_file
            return (__rgignore.error "$rgignore_file does not exist in current directory: "(command pwd))
        end
        nvim $rgignore_file
        return $status
    end

    if set -q _flag_list
        if test -e $rgignore_file
            echo "Current patterns in $rgignore_file:"
            cat $rgignore_file
        else
            echo "No $rgignore_file exists in "(command pwd)
        end
        return 0
    end

    if not test -e $gitignore_file; and not set -q _flag_yes
        read -l -P "No .gitignore found in current directory. Continue? [y/N] " confirm
        if not string match -q -i y -- $confirm
            echo Cancelled
            return 1
        end
    end

    set -l patterns
    if set -q _flag_patterns
        for pattern in $_flag_patterns
            if not string match -q -r '^[!]?[-\w.*/_]+$' -- $pattern
                return (__rgignore.error "Invalid pattern syntax: $pattern\nPatterns should only contain alphanumeric characters, !, *, ., /, - and _")
            end
        end
        set patterns $_flag_patterns
    else
        set patterns $default_patterns
    end

    if test -e $rgignore_file
        if set -q _flag_append
            if not printf "%s\n" $patterns >>$rgignore_file
                return (__rgignore.error "Failed to append to $rgignore_file")
            end
            echo "Appended patterns to $rgignore_file in "(command pwd)
            return 0
        else if not set -q _flag_force
            return (__rgignore.error "$rgignore_file already exists in current directory: "(command pwd)"\nUse -f/--force to overwrite or -a/--append to add patterns")
        end
    end

    if not printf "%s\n" $patterns >$rgignore_file
        return (__rgignore.error "Failed to create $rgignore_file")
    end
    echo "Created $rgignore_file successfully in "(command pwd)
end

complete -c rgignore -s p -l patterns -d 'Specify ignore patterns' -r
complete -c rgignore -s f -l force -d 'Force overwrite existing .rgignore'
complete -c rgignore -s a -l append -d 'Append patterns to existing .rgignore'
complete -c rgignore -s l -l list -d 'List current patterns in .rgignore'
complete -c rgignore -s y -l yes -d 'Skip .gitignore check confirmation'
complete -c rgignore -s e -l edit -d 'Open existing .rgignore in nvim'
