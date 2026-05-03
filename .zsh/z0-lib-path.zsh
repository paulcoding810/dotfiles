# pipx
[ -f ~/.venv/bin/activate ] && source ~/.venv/bin/activate

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Created by `pipx` on 2024-07-21 09:08:34
export PATH="$PATH:${HOME}/.local/bin"

# rust
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/opt/homebrew/bin/ghidra_11.4.2_PUBLIC:$PATH"

# maestro
export PATH="$PATH":"$HOME/.maestro/bin"