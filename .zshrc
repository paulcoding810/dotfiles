zmodload zsh/zprof

zstyle ':bracketed-paste-magic' active-widgets '.self-*'
zstyle ':omz:update' mode disabled
zstyle ':completion:*' accept-exact '*(N)'

WORDCHARS=${WORDCHARS//\//}
PROMPT_EOL_MARK=""

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify
setopt autocd interactivecomments magicequalsubst notify numericglobsort promptsubst

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
  "${HOME}/Library/Android/sdk/emulator"
  "/Applications/Beyond Compare.app/Contents/MacOS"
  "$APP_PATH/wabt-1.0.32/bin"
  "$(python3 -m site --user-base)/bin"
  "${HOME}/.bin"
  "${HOME}/.spicetify"
  "${HOME}/Library/flutter/bin"
  "${HOME}/Library/nvim-macos/bin"
  "${HOME}/Library/fresh-editor-aarch64-apple-darwin"
  "/usr/local/bin/quickemu"
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
  "${HOME}/.nvm/versions/node/v22.17.0/bin"
  "/usr/local/bin"
  "/usr/local/bin/vd-tool/bin"
)

for app in "${apps[@]}"; do
  export PATH=$PATH:"$app"
done

# Source scripts
for file in ~/.zsh/*.zsh; do [ -f "$file" ] && source "$file"; done

# Prof
false && (zprof | head)
