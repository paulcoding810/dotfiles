# sources
# https://gist.github.com/Gram21/35dc66c4673bb63fa8c1
echo `date -I`
echo

zmodload zsh/zprof

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
#setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
	[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n$prompt_symbol%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        simple)
            PROMPT=$'%B%F{%(#.red.blue)}%(#.root .)%~%b%F{reset}%B%F{%(#.red.blue)} $%b%F '
	    RPROMPT=$'%F{%(?.green.red)}%B%?%b%F{reset}'
            ;;
    esac
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=simple
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
        . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=underline
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

## find executable
function appath ()
{ 
    # https://apple.stackexchange.com/a/334635
    # Variables
    local app_name="";
    local app_path_and_name="";
    local path_to_lsregister="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/";

    # If run without arguments, issue a usage summary and exit
    if [[ "$1" == "" ]]; then
        echo "$FUNCNAME: returns name of bundle applications’s executable file";
        echo "usage: $FUNCNAME [application name]"; 
        return 0;
    fi;

    # If argument doesn't end with '.app', append it
    if [[ "$1" =~ \.app$ ]]; then
        app_name="$1"
    else
        app_name="$1.app";
    fi;

    # Look for the path of the application bundle
    # Search /Applications first
    app_path_and_name="$(find /Applications -type d -name "$app_name" -maxdepth 5 | fgrep -m 1 "$app_name")";
    # If not found, search the LaunchServices database (this is the time-consuming step)
    test "$app_path_and_name" || app_path_and_name="$($path_to_lsregister/lsregister -dump | fgrep -v '/Volumes|/System' | egrep --max-count 1 "path: */.*/$app_name " | sed 's:.* \(/.*app\) .*:\1:')"
    # Check if Info.plist exists and is readable
    if [[ -r "$app_path_and_name/Contents/Info.plist" ]]; then
        # Extract the CFBundleExecutable key that contains the name of the executable and print it to standard output
        echo "$app_path_and_name/MacOS/Contents/$(defaults read "$app_path_and_name/Contents/Info.plist" CFBundleExecutable)";
        return 0;
    else
        echo "Application '$1' not found";
        return 1
    fi
}

## find where paths exported
find_path_in_files() {
  local path_to_find=$1
  local files=("$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.zshrc" "$HOME/.profile" "/etc/profile" "/etc/bashrc" "/etc/bash.bashrc")

  for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
      if grep -q $path_to_find "$file"; then
        echo "The path '$path_to_find' is exported in the file: $file"
      fi
    fi
  done
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

APP_PATH="/Volumes/DATA/macOS/Apps"
# some more ls aliases
alias ll='ls -laF'
alias la='ls -A'
alias l='ls -CF'
alias lf='la | fzf -m'
alias adbp='adb shell settings put global http_proxy `ip`:8080'
alias adbpp='adb shell settings put global http_proxy :0'
alias adbe='/Users/paul/Library/Android/sdk/tools/emulator -avd Pixel_3_XL_API_33  -netdelay none -netspeed full  > /dev/null 2>&1 &'
alias cdf='cd `lf`'
alias catf='cat `lf`'
alias q='exit'
alias cat="ccat"
# alias code='open -a Visual\ Studio\ Code.app'
alias finder='open -a Finder.app'
alias gclone='git clone --depth=1'
alias gclone-ios='git clone --depth=1 https://github.com/paul-nguyen-goldenowl/TemplateIOS'
alias zshrc='vim ~/.zshrc && source ~/.zshrc && echo sourced!'
alias web-ext='npx web-ext'
alias xbuild="printf \"xcodebuild clean build -scheme GoMoney -destination 'platform=iOS Simulator,name=iPhone 14 Pro,OS=16.0' | xcpretty \\n\\nxcodebuild -workspace Expenso.xcworkspace -scheme Expenso -destination 'platform=iOS Simulator,name=iPhone 14 Pro,OS=16.0' | xcpretty\""
alias limaa="cd $APP_PATH/lima/ && lima"
alias limarc="mate ~/.lima/default/lima.yaml"
alias vimrc="vim ~/.vimrc"
alias v="vim"
alias vi="vim"
alias ifconfigg="ifconfig | grep inet"
alias ip="ipconfig getifaddr en0"
alias 91="vim  /Users/paul/Documents/91.md"
alias multi="$APP_PATH/Multi/multi.sh"
alias config='/usr/bin/git --git-dir=/Users/paul/.cfg/ --work-tree=/Users/paul'
alias backupp='/Volumes/DATA/macOS/Backup/backup_mac.sh'
alias lv='find `pwd` -depth 1 | fzf -m'
# enable auto-suggestions based on the history
if [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

## zsh-z
if [ -f /usr/local/share/zsh-z/zsh-z.plugin.zsh ]; then
    . /usr/local/share/zsh-z/zsh-z.plugin.zsh
fi

## not working ...
# enable zsh-completions suggestions
# if [ -d /usr/local/share/zsh-completions ]; then
# 	fpath=(/usr/local/share/zsh-completions $fpath)
# fi

# enable zsh-autocomplete
# if [ -f /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
# 	. /usr/local/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi


# variable

# https://stackoverflow.com/questions/18143183/add-sdk-tools-to-path-in-android-studio-app
# Add the Android SDK tools to $PATH and set $ANDROID_HOME (standard)
ANDROID_HOME="${HOME}/Library/Android/sdk"
if [ -d "${ANDROID_HOME}" ]; then
  PATH="${PATH}:${ANDROID_HOME}/tools"
  PATH="${PATH}:${ANDROID_HOME}/platform-tools"
  ANDROID_BUILD_TOOLS_DIR="${ANDROID_HOME}/build-tools"
  PATH="${PATH}:${ANDROID_BUILD_TOOLS_DIR}/$(ls -1 ${ANDROID_BUILD_TOOLS_DIR} | sort -rn | head -1)"
fi

export PATH=$PATH:"/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH=$PATH:"/Applications/TextMate.app/Contents/MacOS/"
export PATH=$PATH:"${HOME}/Downloads/Apps/john-1.8.0.9-jumbo-macosx_avx2/run"
export PATH=$PATH:"/Applications/Firefox Developer Edition.app/Contents/MacOS"
export PATH=$PATH:"/Applications/Beyond Compare.app/Contents/MacOS"
export PATH=$PATH:"$APP_PATH/wabt-1.0.32/bin"
export PATH="$PATH:$(python3 -m site --user-base)/bin"
export PATH=$PATH:"${HOME}/.bin"
export PATH=$PATH:"${HOME}/.spicetify"
export EDITOR="vim"
export CLICOLOR=YES
export NODE_PATH=/usr/local/lib/node_modules
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.zsh/adb.zsh ] && source ~/.zsh/adb.zsh

export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

_install_nvm() {
  unset -f nvm npm node
  echo install nvm...
  # Set up "nvm" could use "--no-use" to defer setup, but we are here to use it
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This sets up nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # nvm bash_completion
  "$@"
  echo 213
}

function nvm() {
    _install_nvm nvm "$@"
}

function npm() {
    _install_nvm npm "$@"
}

function node() {
    _install_nvm node "$@"
}

# zprof
