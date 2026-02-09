# Dotfiles

## Disclaimer

This is designed to bootstrap a clean install of macOS quickly.
It will overwrite all the things in your homedir with symlinks!

## Installation

IMPORTANT: `cp Brewfile ../.Brewfile` if you want to customize the packages that are installed.

``` bash
# Clone Repo to .dotfiles
git clone https://github.com/wakemaster39/dotfiles ~/.dotfiles

# Install Dotfiles
cd ~/.dotfiles && ./install
```

If you want to adjust your macOS settings to be more sane:
```
cd ~/.dotfiles && ./.macos
```

Are you a Fan of Freedom? You may need to run in addition:
```
cd ~/.dotfiles && ./freedom.sh
```

## After Installation

Ensure you create a `~/.gitconfig.local` file with your username/email.
You do not want to have this located within the `.dotfiles` repo!

``` ini
[user]
	name = GIT_NAME
	email = GIT_EMAIL
```

## Customization

If you want to tweak/customize you can create a `~/.DOTFILE.local` file, this will get loaded at the end of the main file.

For example, if you want to add some aliases to your setup, create a `~/.zsh_alias.local` file with all the aliases that you want.


## Credits

Thanks to [rvalente](https://github.com/rvalente/dotfiles/blob/master/README.md) for a base to start from
