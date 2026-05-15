# Source scripts
for file in ~/.zsh/*.zsh; do [ -f "$file" ] && source "$file"; done

# Prof
false && (zprof | head)
