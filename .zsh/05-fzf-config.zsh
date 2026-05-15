# FZF Configuration with max depth 1
export FZF_DEFAULT_COMMAND='fd --max-depth 1 --color=never --hidden'
export FZF_DEFAULT_COMMAND_FILE='fd --type f --max-depth 1 --color=never --hidden'
export FZF_DEFAULT_OPTS='--height=40% --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND_FILE"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --walker=file,dir,follow,hidden
  --walker-root=. 
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_ALT_C_COMMAND='fd --type d --max-depth 1 --color=never --hidden'
export FZF_ALT_C_OPTS="
  --walker=dir,follow,hidden 
  --walker-root=. 
  --preview 'tree -C {} | head -50'"