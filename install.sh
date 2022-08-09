#!/usr/bin/env bash

## Shell Opts ----------------------------------------------------------------
# Exit on any non-zero exit code
set -o errexit

# Exit on any unset variable
set -o nounset

# Pipeline's return status is the value of the last (rightmost) command
# to exit with a non-zero status, or zero if all commands exit successfully.
set -o pipefail

# Enable tracing
set -o xtrace

## Variables -----------------------------------------------------------------
DOTFILES="$(cd "$(dirname "$0")" && pwd -P)"
BREWFILE="${DOTFILES}/Brewfile"

## Main ----------------------------------------------------------------------

# Check for Homebrew and install if we don't have it
if test ! "$(which brew)"; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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

# List of Dotfiles
declare -a FILES_TO_SYMLINK=(
  'fzf.zsh'
  'gitconfig'
  'gitignore'
  'gitmessage'
  'inputrc'
  'zshrc'
  'zsh_profile'
  'zsh_alias'
)

# Symlink Dotfiles
for file in "${FILES_TO_SYMLINK[@]}"; do
  sourceFile="$DOTFILES/$file"
  targetFile="$HOME/.$file"

  if [ -f "$targetFile" ]; then
     if [ ! -L "$targetFile" ]; then
       mv "$targetFile" "$targetFile.old"
     else
       unlink "$targetFile"
     fi
  fi

  if [ ! -e "$targetFile" ]; then
    ln -sf "$sourceFile" "$targetFile"
  fi
done

# unset FILES_TO_SYMLINK

# # Symlink Dotfile vim Dir
# if [ -d "${HOME}/.vim" ]; then
#   # Directory Exists, Check if Symlink
#   if [ ! -L "${HOME}/.vim" ]; then
#     # It is not a symlink, get rid of it!
#     mv "${HOME}/.vim" "${HOME}/.vim.old"
#     ln -sf "${DOTFILES}/vim" "${HOME}/.vim"
#   fi
# else
#   ln -sf "${DOTFILES}/vim" "${HOME}/.vim"
# fi


# tmux-config
# "${DOTFILES}/tmux-config/install.sh"
