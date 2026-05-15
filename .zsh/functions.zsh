## fs

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
  builtin cd "$@" && ls -t | head -20
}

## network
ip() {
  ifconfig en0 | grep "inet " | awk '{print $2}'
}

ipp() {
  curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com || curl -s https://ifconfig.me
}

## specs

ff() {
  alias | grep $1
  declare -f | grep $1
}

paths() {
  echo $PATH | tr ':' '\n' | grep $HOME | sort
}
