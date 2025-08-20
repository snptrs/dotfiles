#!/bin/bash

# ANSI color codes used directly in printf statements:
# \033[92m = Bright green (directory)
# \033[91m = Bright red (git branch)  
# \033[91m = Bright red (git status indicator)
# \033[94m = Bright blue (model name)
# \033[95m = Bright magenta (output style)
# \033[2m  = Dim (separator)
# \033[0m  = Reset colors

# Read JSON input and extract data
input=$(cat)
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')

# Hostname removed - keeping only directory, git, model, and output style

# Get directory display (truncate to repo like Starship)
if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    repo_root=$(git -C "$current_dir" rev-parse --show-toplevel 2>/dev/null)
    if [[ "$current_dir" == "$repo_root" ]]; then
        dir_display=$(basename "$repo_root")
    else
        repo_name=$(basename "$repo_root")
        relative_path=$(realpath --relative-to="$repo_root" "$current_dir" 2>/dev/null || basename "$current_dir")
        dir_display="$repo_name/$relative_path"
    fi
else
    dir_display=$(basename "$current_dir")
fi

# Get git branch and status with colors
git_info=""
if git -C "$current_dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    branch=$(git -C "$current_dir" branch --show-current 2>/dev/null)
    if [[ -n "$branch" ]]; then
        git_info=$(printf " \033[91m%s\033[0m" "$branch")
        # Add * if there are uncommitted changes (in red)
        if ! git -C "$current_dir" diff-index --quiet HEAD -- 2>/dev/null; then
            git_info=$(printf "%s\033[91m*\033[0m" "$git_info")
        fi
    fi
fi

# Build colorized status line: directory + git + model
printf "\033[92m%s\033[0m%s \033[2m│\033[0m \033[94m%s\033[0m" "$dir_display" "$git_info" "$model_name"

# Add output style if not default (in magenta)
if [[ "$output_style" != "default" ]]; then
    printf " \033[95m(%s)\033[0m" "$output_style"
fi
