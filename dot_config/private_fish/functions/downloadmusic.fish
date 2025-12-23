function downloadmusic
    if test (count $argv) -eq 0
        echo "Usage: downloadmusic <URL>"
        return 1
    end

    set -l url $argv[1]
    gamdl --no-synced-lyrics -c /Users/seanpeters/.gamdl/cookies.txt "$url"
end
