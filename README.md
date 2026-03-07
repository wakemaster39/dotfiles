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

## Python Setup

pyenv manages all Python versions. **Do not rely on Homebrew Python or macOS system Python for tools.**

Homebrew's `brew 'python'` is kept for formulae that depend on it, but should never be used directly — `brew upgrade` regularly breaks venvs built against it by bumping the minor version and removing the old framework path.

### Steps

```bash
# Install a stable Python via pyenv (check https://www.python.org/downloads/ for latest stable)
pyenv install 3.12.8

# Pin it as the global default — this is what python3 resolves to everywhere
pyenv global 3.12.8

# Install poetry using the pyenv-managed Python (NOT homebrew, NOT /usr/bin/python3)
curl -sSL https://install.python-poetry.org | ~/.pyenv/versions/3.12.8/bin/python3 -
```

### Why this matters

- **Homebrew Python breaks on upgrade.** `brew upgrade` can bump e.g. 3.14.2 → 3.14.3, deleting the old framework dylib. Any venv (including poetry's own) linked against the old version immediately dies with `Library not loaded`.
- **macOS system Python (`/usr/bin/python3`) can't create venvs** on recent macOS due to framework build restrictions.
- **pyenv versions are self-contained.** `~/.pyenv/versions/3.12.8/` never changes unless you explicitly `pyenv uninstall` it. Brew upgrades can't touch it.
- **Never add poetry's internal venv to PATH.** The poetry installer puts the `poetry` CLI in `~/.local/bin` (which is on PATH). Adding `~/Library/Application Support/pypoetry/venv/bin` to PATH exposes a `python3` binary that breaks when its parent Python is upgraded.

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
