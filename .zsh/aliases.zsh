# Aliases and Path Management
alias ll='ls -lahF'
alias la='ls -A'
alias l='ls -CF'
alias lf='la | fzf -0 -m --preview "realpath {}" --preview-window=up:30%:wrap | tr "\n" "\0" | xargs -0 realpath | tee >(pbcopy)'
alias adbe='${HOME}/Library/Android/sdk/emulator/emulator -avd Pixel_5_API_28  -netdelay none -netspeed full  > /dev/null 2>&1 &'
alias cat="bat -pp"
alias sim="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias gclone='git clone --depth=1'
alias zshrc='vim ~/.zshrc && source ~/.zshrc && echo sourced!'
alias adbrc='vim ~/.zsh/adb.zsh && shfmt -w ~/.zsh/adb.zsh && source ~/.zsh/adb.zsh && echo sourced!'
alias vimrc="vim ~/.vimrc"
alias v="vim"
alias vi="vim"
alias ifconfigg="ifconfig | grep inet"
alias config='/usr/bin/git --git-dir=${HOME}/.cfg/ --work-tree=${HOME}'
alias backupp='/Volumes/DATA/macOS/Backup/backup_mac.sh'
alias lv='find `pwd` -depth 1 | fzf -m'
alias s='subl'
alias curll="curl -kv -w '\n* Response time: %{time_total}s\n' "
alias tyzen="${HOME}/tizen-studio/tools/ide/bin/tizen"
alias sdb="${HOME}/tizen-studio/tools/sdb"
alias gitleakss="gitleaks detect --source . -v"
alias dumpapk="aapt dump badging"
alias history="history 0"
alias o="opencode"
alias p="pnpm"
alias f="functions | grep"
alias dl="cd ~/Downloads"
alias keychain="open '/System/Library/CoreServices/Applications/Keychain Access.app'"
alias xapp="sudo xattr -rd com.apple.quarantine"
