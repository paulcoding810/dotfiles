
# Dotfiles

Manage your dotfiles with a bare Git repo.
Guide: [https://www.atlassian.com/git/tutorials/dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)

---

## Setup

```sh
git clone --bare git@github.com:paulcoding810/dotfiles.git $HOME/.cfg

mkdir -p .config-backup/{.zsh,.config}
config checkout 2>&1 | grep -E "\s+\." | awk '{print $1}' | xargs -I{} mv {} .config-backup/{}

config checkout
config config --local status.showUntrackedFiles no
```
