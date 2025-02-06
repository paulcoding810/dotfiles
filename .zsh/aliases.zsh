# Aliases and Path Management
alias ll='ls -lahF'
alias la='ls -A'
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
alias o="ollama"
alias g="gollama"
