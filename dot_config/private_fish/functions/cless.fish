function cless -d "Configure less to colorize styled text using environment variables before executing a command that will use less"
    set -x LESS_TERMCAP_md (set_color --bold EBBCBA) # start bold
    set -x LESS_TERMCAP_me (set_color normal) # end bold
    set -x LESS_TERMCAP_us (set_color --underline 9CCFD8) # start underline
    set -x LESS_TERMCAP_ue (set_color normal) # end underline
    set -x LESS_TERMCAP_so (set_color --reverse F6C177) # start standout
    set -x LESS_TERMCAP_se (set_color normal) # end standout

    $argv
end
