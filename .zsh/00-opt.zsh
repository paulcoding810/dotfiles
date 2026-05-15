zmodload zsh/zprof

zstyle ':bracketed-paste-magic' active-widgets '.self-*'
zstyle ':completion:*' accept-exact '*(N)'

setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify
setopt autocd interactivecomments magicequalsubst notify numericglobsort promptsubst
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS
