export FZF_DEFAULT_COMMAND='fd -d 1 --color=never --hidden'
export FZF_DEFAULT_COMMAND_FILE='fd --type f -d 1 --color=never --hidden'
export FZF_DEFAULT_OPTS='--height=40% --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND_FILE"
export FZF_CTRL_T_OPTS="--preview 'bat --style=plain --color=always --line-range :50 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"