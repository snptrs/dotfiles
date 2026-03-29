#!/usr/bin/env bash
# Claude Code status line - inspired by Starship prompt config

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Directory: abbreviate home, find git root for truncation
dir="$cwd"
if [ -n "$cwd" ]; then
  dir="${cwd/#$HOME/~}"
  # Check if we're in a git repo and truncate to repo root
  git_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$git_root" ]; then
    dir=$(basename "$git_root")
  fi
fi

# Git branch
git_branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    git_branch="  $branch"
  fi
fi

# Context usage
ctx_info=""
if [ -n "$used" ]; then
  ctx_info=" ctx:$(printf '%.0f' "$used")%"
fi

# Rate limits
rate_info=""
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$five" ]; then
  rate_info=" 5h:$(printf '%.0f' "$five")%"
fi

# Build output with ANSI colors
# cyan=directory, bright-black=git branch, model, context, rate limit
CYAN='\033[36m'
BBLACK='\033[90m'
RED='\033[31m'
BLUE='\033[34m'
RESET='\033[0m'
BOLD='\033[1m'

printf "${CYAN}%s${RESET}" "$dir"
if [ -n "$git_branch" ]; then
  printf "${RED}%s${RESET}" "$git_branch"
fi
if [ -n "$model" ]; then
  printf "${BLUE} %s${RESET}" "$model"
fi
if [ -n "$ctx_info" ]; then
  printf "${BBLACK}%s${RESET}" "$ctx_info"
fi
if [ -n "$rate_info" ]; then
  printf "${BBLACK}%s${RESET}" "$rate_info"
fi
