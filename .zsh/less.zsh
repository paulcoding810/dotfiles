# https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less/
LESSPIPE=$(which src-hilite-lesspipe.sh)
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '
