# ~/.bash_profile; executed by bash(1) for login shells.


# Ensure we're using Vim!
export EDITOR=vim
export VISUAL=vim
export PAGER='less -m'

export LC_ALL=en_CA.UTF-8
export LANG=en_CA.UTF-8
export TERM=xterm-256color

# Enable Colors
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Enable Homebrew Completion
[ -r /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

# Load Local Bash Profile
[ -r ~/.bash_profile.local ] && source ~/.bash_profile.local

# Run our Interactive Shell bashrc
[ -r ~/.bashrc ] && source ~/.bashrc

# bash git prompt
GIT_PROMPT_ONLY_IN_REPO=0
if [ -f "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh" ]; then
  __GIT_PROMPT_DIR=$(brew --prefix)/opt/bash-git-prompt/share
  source "$(brew --prefix)/opt/bash-git-prompt/share/gitprompt.sh"
fi

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# gpg
export GPG_TTY=$(tty)

# hub
eval "$(hub alias -s)"

# gopass
source /dev/stdin <<<"$(gopass completion bash)"
