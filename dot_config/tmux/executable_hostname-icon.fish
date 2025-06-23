#!/usr/bin/env fish

switch (hostname -s)
    case Seans-Mac
        echo "󰇄 "
    case Seans-MacBook-Air
        echo " "
    case '*'
        hostname -s
end
