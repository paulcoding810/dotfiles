# Custom function to locate application path
appath() {
  local app_name="$1"
  local app_path=""
  local path_to_lsregister="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/"

  [[ -z "$1" ]] && {
    echo "Usage: $FUNCNAME [app name]"
    return
  }
  [[ "$1" =~ \.app$ ]] || app_name="$1.app"

  app_path="$(find /Applications -type d -name "$app_name" -maxdepth 5 | fgrep -m 1 "$app_name")"
  app_path="${app_path:-$($path_to_lsregister/lsregister -dump | grep -m 1 "$app_name" | sed 's:.* \(/.*app\) .*:\1:')}"
  [[ -r "$app_path/Contents/Info.plist" ]] && echo "$app_path/Contents/MacOS/$(defaults read "$app_path/Contents/Info.plist" CFBundleExecutable)"
}

mkcd() {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

cd() {
  builtin cd "$@" && ls
}

appid() {
  script="osascript -e 'id of app \"$1\"'"
  sh -c $script
}

# get local ip
ip() {
  ifconfig | grep 'inet 192.168' | awk '{print $2}'
}

# get public ip
ipp() {
  curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com || curl -s https://ifconfig.me
}

# get latest created file/dir
newest() {
  ls -t | head -n 1
}

# Custom functions for path finding in files
find_path_in_files() {
  local path_to_find=$1
  local files=(~/.bash_profile ~/.bash_login ~/.zshrc ~/.profile /etc/profile /etc/bashrc /etc/bash.bashrc)

  for file in "${files[@]}"; do
    [[ -f "$file" && "$(grep -q "$path_to_find" "$file")" ]] && echo "Path '$path_to_find' found in $file"
  done
}

# git archive source code
gitzip() {
  git archive --format=zip --output="$HOME/Downloads/$(basename $(git rev-parse --show-toplevel)).zip" HEAD
}
