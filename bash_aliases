# ~/.bash_aliases

alias ..="cd .."
alias ...="cd ../../"
alias ....="cd ../../../"

# vim
alias vi=nvim
alias vim=nvim

# Sysadmin Aliases
alias ls='ls -GF'
alias la='ls -GlahF'
alias lsd='ls -GlahF | grep --color=never '^d''
alias h=history
alias ps='/bin/ps auxww'
alias psg='/bin/ps auxww | grep'
alias tf='tail -f'

# Exa aliases
alias exa="exa --git -l"

# alias newer programs
alias cat='bat'
alias ping='prettyping --nolegend'
alias preview="fzf --preview 'bat --color \"always\" {}'"
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort'"
alias top="sudo htop" # alias top and fix high sierra bug:
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

# Google Chrome
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# macOS has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# macOS has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"



# Git Aliases
alias gs='git status -sb'
alias ga='git add -A'
alias gcv='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gp="git pull origin \$(git rev-parse --abbrev-ref HEAD)"

# macOS Specific Aliases
alias brewu="brew update && brew upgrade && brew doctor && brew cleanup"
alias flushdns='sudo killall -HUP mDNSResponder; sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache'

# Load User Aliases
[ -r ~/.bash_aliases.local ] && source ~/.bash_aliases.local
