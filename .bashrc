[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if [ -f $(brew --prefix)/etc/bash_completion ]; then source $(brew --prefix)/etc/bash_completion; fi
. "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/paul/.lmstudio/bin"
