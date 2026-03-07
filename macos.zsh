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


# iTerm2: Enable "Report modifiers using CSI u" on all profiles and add
# an explicit Shift+Enter keybinding that sends ESC [13;2u.
# The libtickit protocol covers most modified keys but iTerm2 special-cases
# Enter and still sends a plain CR for Shift+Enter, so the explicit keybinding
# is required for tmux extended-keys and Claude Code's shift+enter newline.
ITERM_PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
if [ -f "$ITERM_PLIST" ]; then
    # Count only top-level profile dicts (4-space indent), not nested ones
    PROFILE_COUNT=$(/usr/libexec/PlistBuddy -c "Print :\"New Bookmarks\"" "$ITERM_PLIST" 2>/dev/null | grep "^    Dict {" | wc -l | tr -d ' ')
    if pgrep -xq iTerm2; then
        echo "WARNING: iTerm2 is running — plist changes will be overwritten on quit. Quit iTerm2, re-run, then relaunch."
    fi
    for (( i=0; i<PROFILE_COUNT; i++ )); do
        PROF=":\"New Bookmarks\":$i"
        PROFILE_NAME=$(/usr/libexec/PlistBuddy -c "Print ${PROF}:Name" "$ITERM_PLIST" 2>/dev/null)

        # CSI u on all profiles
        /usr/libexec/PlistBuddy -c "Set ${PROF}:\"Use libtickit protocol\" true" "$ITERM_PLIST" 2>/dev/null \
            || /usr/libexec/PlistBuddy -c "Add ${PROF}:\"Use libtickit protocol\" bool true" "$ITERM_PLIST"

        # Shift+Enter keybinding only on Default profile
        if [[ "$PROFILE_NAME" != "Default" ]]; then
            continue
        fi

        # Shift+Enter → Send Escape Sequence "[13;2u"
        # Key: 0xd=Enter, 0x20000=Shift, 0x24=keycode for Return
        # NOTE: Use ${KEY} not $KEY — zsh interprets $KEY:Action as ${KEY:A}ction (modifier)
        KEY="$PROF:\"Keyboard Map\":0xd-0x20000-0x24"
        /usr/libexec/PlistBuddy -c "Print ${KEY}" "$ITERM_PLIST" >/dev/null 2>&1 \
            || /usr/libexec/PlistBuddy -c "Add ${KEY} dict" "$ITERM_PLIST"
        /usr/libexec/PlistBuddy -c "Set ${KEY}:Action 10" "$ITERM_PLIST" 2>/dev/null \
            || /usr/libexec/PlistBuddy -c "Add ${KEY}:Action integer 10" "$ITERM_PLIST"
        /usr/libexec/PlistBuddy -c "Set ${KEY}:Text [13;2u" "$ITERM_PLIST" 2>/dev/null \
            || /usr/libexec/PlistBuddy -c "Add ${KEY}:Text string [13;2u" "$ITERM_PLIST"
        /usr/libexec/PlistBuddy -c "Set ${KEY}:\"Apply Mode\" 0" "$ITERM_PLIST" 2>/dev/null \
            || /usr/libexec/PlistBuddy -c "Add ${KEY}:\"Apply Mode\" integer 0" "$ITERM_PLIST"
        /usr/libexec/PlistBuddy -c "Set ${KEY}:Escaping 2" "$ITERM_PLIST" 2>/dev/null \
            || /usr/libexec/PlistBuddy -c "Add ${KEY}:Escaping integer 2" "$ITERM_PLIST"
        /usr/libexec/PlistBuddy -c "Set ${KEY}:Version 2" "$ITERM_PLIST" 2>/dev/null \
            || /usr/libexec/PlistBuddy -c "Add ${KEY}:Version integer 2" "$ITERM_PLIST"
    done
    echo "Enabled CSI u (libtickit) + Shift+Enter keybinding on $PROFILE_COUNT iTerm2 profile(s)"
fi

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

CRON_NPM="0 12 * * 1 $HOME/.local/bin/npm-globals-check"
EXISTING_CRON=$(crontab -l 2>/dev/null || true)
if ! echo "$EXISTING_CRON" | grep -q "npm-globals-check"; then
    echo "$EXISTING_CRON" | { cat; echo "$CRON_NPM"; } | crontab -
    echo "Added weekly npm-globals-check cron job"
fi
