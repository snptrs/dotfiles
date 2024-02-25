function ls --wraps='gls --color F' --description 'alias ls=gls --color -F'
  gls --color -F $argv
        
end
