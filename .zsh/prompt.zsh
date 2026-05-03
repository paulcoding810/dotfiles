local parse_git_branch() {
  git branch 2>/dev/null | grep '\*' | sed 's/* //'
}
PROMPT='%B%F{%(#.red.blue)}%(#.root .)%~%b%F{reset}%B%F{%(#.red.blue)} $%b%F '
RPROMPT='%F{%(?.green.red)}%B%?%b%F{reset}'
# RPROMPT='$(parse_git_branch) %F{%(?.green.red)}%B%?%b%F{reset}'
