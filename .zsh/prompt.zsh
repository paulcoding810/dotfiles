# PROMPT='%0(?..%F{red})%S > %f%s '
# RPROMPT=' %0(?..%F{red})%S %B%~%b%1(j. (%j).) %f%s'

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

# Title for compatible terminals
[[ "$TERM" == xterm* || "$TERM" == rxvt* || "$TERM" == gnome* ]] && TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'

# Pre-command prompt behavior
precmd() {
  print -Pnr -- "$TERM_TITLE"
  [[ "$NEWLINE_BEFORE_PROMPT" == "yes" && -n "$_NEW_LINE_BEFORE_PROMPT" ]] && print ""
  _NEW_LINE_BEFORE_PROMPT=1
}
