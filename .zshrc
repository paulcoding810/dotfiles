# Source Gist for additional configurations
echo "$(date -I)"
echo

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

WORDCHARS=${WORDCHARS//\/}
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

# Color prompt settings
color_prompt=yes
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

configure_prompt() {
    prompt_symbol="㉿"
    [ "$EUID" -eq 0 ] && prompt_symbol="💀"
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT='%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)}(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            RPROMPT='%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT='%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=""
            ;;
        simple)
            PROMPT='%B%F{%(#.red.blue)}%(#.root .)%~%b%F{reset}%B%F{%(#.red.blue)} $%b%F '
            RPROMPT='%F{%(?.green.red)}%B%?%b%F{reset}'
            ;;
    esac
}

PROMPT_ALTERNATIVE="simple"
NEWLINE_BEFORE_PROMPT="yes"
configure_prompt

# Toggle prompt layout with ^P
toggle_oneline_prompt() {
    [ "$PROMPT_ALTERNATIVE" = "oneline" ] && PROMPT_ALTERNATIVE="twoline" || PROMPT_ALTERNATIVE="oneline"
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey "^P" toggle_oneline_prompt

# Custom function to locate application path
appath() {
    local app_name="$1"
    local app_path=""
    local path_to_lsregister="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/"

    [[ -z "$1" ]] && { echo "Usage: $FUNCNAME [app name]"; return; }
    [[ "$1" =~ \.app$ ]] || app_name="$1.app"

    app_path="$(find /Applications -type d -name "$app_name" -maxdepth 5 | fgrep -m 1 "$app_name")"
    app_path="${app_path:-$($path_to_lsregister/lsregister -dump | grep -m 1 "$app_name" | sed 's:.* \(/.*app\) .*:\1:')}"
    [[ -r "$app_path/Contents/Info.plist" ]] && echo "$app_path/Contents/MacOS/$(defaults read "$app_path/Contents/Info.plist" CFBundleExecutable)"
}

# Aliases and Path Management
alias ll='ls -laF'alias ll='ls -laF'
alias la='ls -A'alias la='ls -A'
alias l='ls -CF'
alias l='ls -CF'
alias adbp='adb shell settings put global http_proxy `ip`:8080'
alias lf='la | fzf -0 -m --preview "realpath {}" --preview-window=up:30%:wrap | tr "\n" "\0" | xargs -0 realpath | tee >(pbcopy)'
alias adbpp='adb shell settings put global http_proxy :0'
alias adbe='/Users/paul/Library/Android/sdk/emulator/emulator -avd Pixel_5_API_28  -netdelay none -netspeed full  > /dev/null 2>&1 &'
alias cat="ccat"
alias sim="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias gclone='git clone --depth=1'
alias zshrc='vim ~/.zshrc && source ~/.zshrc && echo sourced!'
alias adbrc='vim ~/.zsh/adb.zsh && shfmt -w ~/.zsh/adb.zsh && source ~/.zsh/adb.zsh && echo sourced!'
alias vimrc="vim ~/.vimrc"
alias v="vim"
alias vi="vim"
alias ifconfigg="ifconfig | grep inet"
alias multi="$APP_PATH/Multi/multi.sh"
alias config='/usr/bin/git --git-dir=/Users/paul/.cfg/ --work-tree=/Users/paul'
alias backupp='/Volumes/DATA/macOS/Backup/backup_mac.sh'
alias lv='find `pwd` -depth 1 | fzf -m'
alias s='subl'
alias curll="curl -kv -w '\n* Response time: %{time_total}s\n' "
alias tyzen="/Users/paul/tizen-studio/tools/ide/bin/tizen"
alias sdb="/Users/paul/tizen-studio/tools/sdb"
alias gitleakss="gitleaks detect --source . -v"
alias dumpapk="aapt dump badging"
alias history="history 0"


# Adding paths
export PATH="${PATH}:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools"
export PATH="$PATH:/usr/local/bin:/usr/local/sbin"

# Add the Android SDK tools to $PATH and set $ANDROID_HOME (standard)
ANDROID_HOME="${HOME}/Library/Android/sdk"
if [ -d "${ANDROID_HOME}" ]; then
  PATH="${PATH}:${ANDROID_HOME}/platform-tools"
  PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin"
  ANDROID_BUILD_TOOLS_DIR="${ANDROID_HOME}/build-tools"

  NDK_DIR="${ANDROID_HOME}/ndk"
  if [ -d "${NDK_DIR}" ]; then
  	PATH="${PATH}:${NDK_DIR}/$(ls -1 ${NDK_DIR} | sort -rn | head -1)/toolchains/llvm/prebuilt/darwin-x86_64/bin"
  fi
  
  PATH="${PATH}:${ANDROID_BUILD_TOOLS_DIR}/$(ls -1 ${ANDROID_BUILD_TOOLS_DIR} | sort -rn | head -1)"
  PATH="${PATH}:${ANDROID_HOME}/tools"
fi

# Setting the LG_WEBOS_TV_SDK_HOME variable to the parent directory of CLI
export LG_WEBOS_TV_SDK_HOME="/Users/paul/Library/webos"

if [ -d "$LG_WEBOS_TV_SDK_HOME/CLI/bin" ]; then
  # Setting the WEBOS_CLI_TV variable to the bin directory of CLI
  export WEBOS_CLI_TV="$LG_WEBOS_TV_SDK_HOME/CLI/bin"
  # Adding the bin directory of CLI to the PATH variable
  export PATH="$PATH:$WEBOS_CLI_TV"
fi

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH
export PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH=$PATH:"/Applications/TextMate.app/Contents/MacOS/"
export PATH=$PATH:"${HOME}/Downloads/Apps/john-1.8.0.9-jumbo-macosx_avx2/run"
export PATH=$PATH:"/Applications/Firefox Developer Edition.app/Contents/MacOS"
export PATH=$PATH:"/Applications/Android Studio.app/Contents/MacOS"
export PATH=$PATH:"/Applications/Beyond Compare.app/Contents/MacOS"
export PATH=$PATH:"$APP_PATH/wabt-1.0.32/bin"
export PATH="$PATH:$(python3 -m site --user-base)/bin"
export PATH=$PATH:"${HOME}/.bin"
export PATH=$PATH:"${HOME}/.spicetify"
export PATH=$PATH:"${HOME}/Library/flutter/bin"
export PATH=$PATH:"${HOME}/Library/nvim-macos/bin"
export PATH=$PATH:"/usr/local/bin/quickemu"
export PATH=$PATH:"/Applications/Sublime Text.app/Contents/SharedSupport/bin"
export PATH=$PATH:"/Users/paul/.nvm/versions/node/v20.18.0/bin"
export PATH="/usr/local/bin:${PATH}"

export EDITOR="vim"
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s"
export CLICOLOR=YES
export NODE_PATH=/usr/local/lib/node_modules
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export HOMEBREW_NO_AUTO_UPDATE=1

# https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less/
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '


mkcd() {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

appid() {
	script="osascript -e 'id of app \"$1\"'"
	sh -c $script
}

## fzf
export FZF_DEFAULT_COMMAND='fd -d 1 --color=never --hidden'
export FZF_DEFAULT_COMMAND_FILE='fd --type f -d 1 --color=never --hidden'
export FZF_DEFAULT_OPTS='--height=40% --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND_FILE"
export FZF_CTRL_T_OPTS="--preview 'bat --style=plain --color=always --line-range :50 {}'"

export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/adb.zsh ] && source ~/.zsh/adb.zsh
[ -f ~/.zsh/hugo.zsh ] && source ~/.zsh/hugo.zsh
[ -f ~/.zsh/ios.zsh ] && source ~/.zsh/ios.zsh
[ -f ~/.venv/bin/activate ] && source ~/.venv/bin/activate

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

_install_nvm() {
  unset -f nvm npm node yarn npx
  echo install nvm...
  # Set up "nvm" could use "--no-use" to defer setup, but we are here to use it
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This sets up nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # nvm bash_completion
  "$@"
}

function nvm() {
    _install_nvm nvm "$@"
}

function npm() {
    _install_nvm npm "$@"
}


function yarn() {
    _install_nvm yarn "$@"
}

function npx() {
    _install_nvm npx "$@"
}

function node() {
    _install_nvm node "$@"
}

# ip
function ip() {
	ifconfig | grep 'inet 192.168' | awk '{print $2}'
}

function newest() {
	ls -t | head -n 1
}

# zprof

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="/Users/paul/.nvm/versions/node/v20.5.1/bin/node:$PATH"

# bun completions
[ -s "/Users/paul/.bun/_bun" ] && source "/Users/paul/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=$PATH:/Users/paul/.spicetify

# Created by `pipx` on 2024-07-21 09:08:34
export PATH="$PATH:/Users/paul/.local/bin"

# rust
. "$HOME/.cargo/env"

# Custom functions for path finding in files
find_path_in_files() {
    local path_to_find=$1
    local files=(~/.bash_profile ~/.bash_login ~/.zshrc ~/.profile /etc/profile /etc/bashrc /etc/bash.bashrc)

    for file in "${files[@]}"; do
        [[ -f "$file" && "$(grep -q "$path_to_find" "$file")" ]] && echo "Path '$path_to_find' found in $file"
    done
}

# Title for compatible terminals
[[ "$TERM" == xterm* || "$TERM" == rxvt* || "$TERM" == gnome* ]] && TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'

# Pre-command prompt behavior
precmd() {
    print -Pnr -- "$TERM_TITLE"
    [[ "$NEWLINE_BEFORE_PROMPT" == "yes" && -n "$_NEW_LINE_BEFORE_PROMPT" ]] && print ""
    _NEW_LINE_BEFORE_PROMPT=1
}
