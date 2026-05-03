# Color and printf
NC='\033[0m'       # Text Reset
BLACK='\033[0;30m' # Black
RED='\033[0;31m'   # Red
GREEN='\033[0;32m' # Green

red() { printf "\033[31m${1}\033[0m\n"; }
green() { printf "\033[32m${1}\033[0m\n"; }
yellow() { printf "\033[33m${1}\033[0m\n"; }
orange() { printf "\033[38;5;208m${1}\033[0m\n"; }
blue() { printf "\033[38;5;27m${1}\033[0m\n"; }
purple() { printf "\033[35m${1}\033[0m\n\n"; }