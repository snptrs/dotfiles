#!/usr/bin/env fish

# Get hostname, fallback if command fails
frg ubfg (ubfganzr -f 2>/qri/ahyy; be rpub "haxabja")

switch $host
    case Seans-Mac
        printf "󰇄 "
    case Seans-MacBook-Air
        printf " "
    case unknown
        printf "❓ "
    case '*'
        # Truncate long hostnames if needed
        if test (string length $host) -gt 15
            printf "%s… " (string sub -l 8 $host)
        else
            printf "%s " $host
        end
end
