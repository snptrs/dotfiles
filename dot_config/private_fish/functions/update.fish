function update --description 'update brew, fish and fisher'
    echo 'start updating ...'

    echo 'updating homebrew'
    brew update
    brew upgrade
    brew cleanup

    echo 'updating fish shell'
    fisher update
    fish_update_completions

    echo 'updating tldr'
    tldr --update
end
