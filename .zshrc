export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

plugins=(
  git
  z
  flutter
  xcode
  zsh-autosuggestions
  zsh-syntax-highlighting
  fast-syntax-highlighting
  fzf-tab
)

source $ZSH/oh-my-zsh.sh

zmodload zsh/zprof

# Set options
setopt autocd correct interactivecomments magicequalsubst notify numericglobsort promptsubst

WORDCHARS=${WORDCHARS//\//}
PROMPT_EOL_MARK=""
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# Keybindings
bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' undo

# Completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify

export GEM_HOME=$HOME/.gem
export EDITOR="vim"
export CLICOLOR=YES
export HOMEBREW_NO_AUTO_UPDATE=1

# Export Paths
apps=(
  "$GEM_HOME/bin"
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "/Applications/TextMate.app/Contents/MacOS/"
  "${HOME}/Downloads/Apps/john-1.8.0.9-jumbo-macosx_avx2/run"
  "/Applications/Firefox Developer Edition.app/Contents/MacOS"
  "/Applications/Android Studio.app/Contents/MacOS"
  "/Applications/Beyond Compare.app/Contents/MacOS"
  "$APP_PATH/wabt-1.0.32/bin"
  "$(python3 -m site --user-base)/bin"
  "${HOME}/.bin"
  "${HOME}/.spicetify"
  "${HOME}/Library/flutter/bin"
  "${HOME}/Library/nvim-macos/bin"
  "/usr/local/bin/quickemu"
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  "/Users/paul/.nvm/versions/node/v20.18.0/bin"
  "/usr/local/bin"
)

for app in "${apps[@]}"; do
  export PATH=$PATH:"$app"
done

# Source scripts
for file in ~/.zsh/*.zsh; do [ -f "$file" ] && source "$file"; done
[ -f ~/.venv/bin/activate ] && source ~/.venv/bin/activate

# bun completions
[ -s "/Users/paul/.bun/_bun" ] && source "/Users/paul/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Created by `pipx` on 2024-07-21 09:08:34
export PATH="$PATH:/Users/paul/.local/bin"

# rust
. "$HOME/.cargo/env"
