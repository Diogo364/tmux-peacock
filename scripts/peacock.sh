#!/usr/bin/env bash

TMUX_PEACOCK_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
TMUX_PEACOCK_COLORSCHEME_DIR="$TMUX_PEACOCK_DIR/resources"

list_colorschemes() {
    echo "$(ls $TMUX_PEACOCK_COLORSCHEME_DIR)"
}

set_colors_for_pane() {
    local full_path="$@"

    . $full_path

    if [[ -z $PANEL_BG ]] || [[ -z $PANEL_FG ]]; then
        echo "$PANEL_FG"
        printf "Error in loading colorscheme from $(basename $full_path)" >&2
        exit 1

    fi

    tmux_commands+=(select-pane -P "bg=$PANEL_BG,fg=$PANEL_FG" ";")
}

pick_colorscheme(){
    local option=$1
    local full_path="$TMUX_PEACOCK_COLORSCHEME_DIR/$option"

    if [[ ! -f "$full_path" ]]; then
        printf "Error: %s is not a valid option. Choose from [\n%s\n]\n" "$option" "$(list_colorschemes)" >&2
        exit 1
    fi

    set_colors_for_pane "$full_path"
}

rename_pane() {
    local pane_name="$1"

    if [[ -z "$pane_name" ]]; then
        printf "Error: pane_name not defined" >&2
        exit 1
    fi

    tmux_commands+=(select-pane -T "$pane_name" ";" )
    tmux_commands+=(set -g pane-border-status top ";" )
    tmux_commands+=(set -g pane-border-format "#{pane_index}: #{pane_title}" ";" )
}

main() {

    local subcommand="$1"
    shift

    local tmux_commands=()

    case "$subcommand" in
        list)
            list_colorschemes
            ;;
        set)
            local option="$1"
            local pane_name="$2"

            pick_colorscheme "$option"
            rename_pane "$pane_name"
            tmux "${tmux_commands[@]}"
            ;;
        *)
            printf "Usage: %s {list|set <colorscheme> <pane_name>}\n" "$(basename "$0")" >&2
            exit 1
            ;;
    esac

}

main $@
