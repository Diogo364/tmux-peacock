#!/usr/bin/env bash

TMUX_PEACOCK_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
SCRIPT="$TMUX_PEACOCK_DIR/peacock.sh"   # rename to match your script

# Command 1: list colorschemes (prefix + C-l)
tmux bind-key C-l display-popup -E "'$SCRIPT' list | less"

# Command 2: two custom arguments, collected via prompts (prefix + C-p)
tmux bind-key C-p command-prompt -p "Colorscheme:,Pane name:" \
    "run-shell \"'$SCRIPT' set '%1' '%2'\""
