#!/usr/bin/env zsh
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="amethyst,bin,claude,git,nvim,tmux,vscode,zsh"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

BREWFILE="${DOTFILES}/Brewfile"

if test ! "$(which brew)"; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Turn off Homebrew Analytics; Before we do anything else!
brew analytics off

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle

# Check if we have a custom brewfile
if [ -f "${HOME}/.Brewfile" ]; then
  BREWFILE="$HOME/.Brewfile"
fi

# Install User Packages
echo "Install Packages from ${BREWFILE}..."
brew bundle --file="$BREWFILE"

# Set Newer Bash as Default Shell
CURRENTSHELL=$(dscl . -read /Users/"$USER" UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/opt/homebrew/bin/zsh" ]]; then
  sudo dscl . -change /Users/"$USER" UserShell "$SHELL" /opt/homebrew/bin/zsh > /dev/null 2>&1
fi

# install poetry
# curl -sSL https://install.python-poetry.org | python3 -

# install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm -f $HOME/.zshrc


STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES $DOTFILES/install

# Setup dotfiles notification cron jobs (idempotent — skips if already present)
CRON_LOCAL="0 12 * * * $HOME/.local/bin/dotfiles-check-local"
CRON_REMOTE="0 12 * * 1 $HOME/.local/bin/dotfiles-check-remote"
EXISTING_CRON=$(crontab -l 2>/dev/null || true)

if ! echo "$EXISTING_CRON" | grep -q "dotfiles-check-local"; then
    echo "$EXISTING_CRON" | { cat; echo "$CRON_LOCAL"; } | crontab -
    echo "Added daily dotfiles-check-local cron job"
fi

EXISTING_CRON=$(crontab -l 2>/dev/null || true)
if ! echo "$EXISTING_CRON" | grep -q "dotfiles-check-remote"; then
    echo "$EXISTING_CRON" | { cat; echo "$CRON_REMOTE"; } | crontab -
    echo "Added weekly dotfiles-check-remote cron job"
fi
