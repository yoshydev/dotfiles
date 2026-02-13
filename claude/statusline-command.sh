#!/bin/bash
# StatusLine command script - nvim style single line

input=$(cat)

# Extract data from JSON input
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name // "Claude"')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Get basename of current directory
dir_name=$(basename "$cwd")

# Get git branch name if in a git repository
git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Build status line components
left_part="${dir_name}"
if [ -n "$git_branch" ]; then
  left_part="${left_part}  ${git_branch}"
fi

# Add vim mode if present
if [ -n "$vim_mode" ]; then
  right_part="-- ${vim_mode} -- ${model_name}"
else
  right_part="${model_name}"
fi

# Add output style if not default
if [ "$output_style" != "default" ]; then
  right_part="${right_part} [${output_style}]"
fi

# Add context remaining if available
if [ -n "$remaining" ]; then
  remaining_int=$(printf "%.0f" "$remaining")
  right_part="${right_part} ${remaining_int}%"
fi

# Keybinding hints
hints="Shift+Tab: plan mode | Esc: interrupt"

# Format with background color for visibility (nvim-style)
# \033[48;5;236m = dark gray background, \033[38;5;252m = light gray text
# \033[38;5;245m = dimmed text for hints
printf "\033[48;5;236m\033[38;5;252m %s  %s \033[38;5;245m %s \033[0m" "$left_part" "$right_part" "$hints"
