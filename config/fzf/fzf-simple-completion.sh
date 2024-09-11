#!/usr/bin/env bash

# https://raw.githubusercontent.com/duong-db/fzf-simple-completion/HEAD/fzf-simple-completion.sh
# commit: 78765e5c79cde6300bf03a439d47715d2f5a16ed

# FZF SIMPLE COMPLETION - Pipe bash tab-completion suggestions into fzf fuzzy finder
# More details at https://github.com/duong-db/fzf-simple-completion

bind '"\e[0n": redraw-current-line'

_fzf_empty_line_completion() {
    local cmd=$(__fzf_cd__)
    if [[ $cmd = 'builtin cd'* ]]; then
        COMPREPLY=" $cmd"  # cd inside function will not update prompt
    else
        eval "$cmd"
    fi
    printf '\e[5n'
}

_fzf_command_completion() {
    COMPREPLY=$(
        # Use compgen for commands completion
        compgen -c -- "${COMP_WORDS[COMP_CWORD]}" 2>/dev/null | LC_ALL=C sort -u |
        fzf --bind=tab:down,btab:up --cycle --reverse --height=12 --select-1 --exit-0
    )
    printf '\e[5n'
}

_fzf_get_argument_list() {
    local _command command=${COMP_LINE%% *}
    _command=$(complete -p "$command" 2>/dev/null | awk '{print $(NF-1)}')

    if [[ -z $_command ]]; then
        # Load completion using _completion_loader from bash_completion script
        _completion_loader "$command"
        _command=$(complete -p "$command" 2>/dev/null | awk '{print $(NF-1)}')
    fi
    "$_command" 2>/dev/null

    # Add color
    for i in "${!COMPREPLY[@]}"; do
        if [[ -e "${COMPREPLY[i]}" ]]; then
            COMPREPLY[i]=$(ls -F -d --color=always "${COMPREPLY[i]}" 2>/dev/null)
        fi
    done
    printf '%s\n' "${COMPREPLY[@]}" | LC_ALL=C sort -u | LC_ALL=C sort -t '.' -k2
}

_fzf_argument_completion() {
    # Hack on directories completion
    # - Only display the last sub directory for fzf searching
    #     Example. a/b/c -> a//b//c/ -> c/
    # - Handle the case where directory contains spaces
    #     Example. New Folder/ -> New\ Folder/
    COMPREPLY=$(
        _fzf_get_argument_list | sed 's/\//\/\//g; s/\/$//' |
            fzf --bind=tab:down,btab:up --cycle --reverse --height=12 --select-1 --exit-0 --ansi -d '//' --with-nth='-1..' |
            sed -e 's/\/\//\//g' -e 's/ /\\ /g; s/\\ $/ /'
    )
    printf '\e[5n'
}

# Remove default completions
complete -r

complete -E -F _fzf_empty_line_completion
if [[ ${BASH_VERSINFO[0]} -ge 5 ]]; then
    complete -I -F _fzf_command_completion
fi
if [[ -n $BASH_COMPLETION_LOADED ]]; then
    complete -o default -o nospace -D -F _fzf_argument_completion
fi

# Turn off case sensitivity for better user experience
bind 'set completion-ignore-case on'
