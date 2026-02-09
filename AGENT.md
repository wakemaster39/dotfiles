# Dotfiles Project Guidelines

## Architecture

This is a dotfiles repo managed with **GNU Stow** (`--no-folding`). Each stow folder maps directly to `$HOME`.

**Stow folders:** `amethyst, bin, claude, git, nvim, tmux, vscode, zsh`

### Key files
- `macos.zsh` — Bootstrap script: installs Homebrew, packages (Brewfile), sets shell, runs `install`, sets up cron jobs
- `install` — Runs `stow --no-folding` for each folder in `$STOW_FOLDERS`
- `.macos` — macOS `defaults write` preferences (run manually, not part of stow)
- `freedom.sh` — Additional macOS settings (run manually)
- `Brewfile` — Homebrew packages and casks

### Stow conventions
- `--no-folding` is required — prevents stow from symlinking entire directories, which would cause external tools to write into the repo
- Files inside stow folders mirror the home directory structure (e.g., `bin/.local/bin/git-clean` → `~/.local/bin/git-clean`)
- Non-stow files (`.macos`, `macos.zsh`, `Brewfile`, `README.md`, etc.) live at repo root

## Shell environment

- Primary shell: **zsh** (via oh-my-zsh)
- Load order: `.zshrc` → oh-my-zsh → `.zsh_profile` → `.zsh_alias` → `.zshrc.local`
- Local overrides: any dotfile can have a `.local` variant (e.g., `~/.zshrc.local`, `~/.gitconfig.local`)
- `bash_aliases` and `bash_profile` exist for legacy bash support but are not stowed

## Scripts in `bin/.local/bin/`

- Scripts here are on `$PATH` via `path+=$HOME/.local/bin` in `.zsh_profile`
- Use `#!/usr/bin/env bash` shebang
- Keep scripts portable — no external dependencies beyond what's in the Brewfile

## When making changes

- **Brewfile**: Keep packages alphabetically sorted within their section (casks, then brew formulas)
- **Shell scripts**: Use `set -euo pipefail` for safety
- **.macos**: Settings use `defaults write` — group by application/section, add comments explaining what each setting does
- **New stow folders**: Must be added to `STOW_FOLDERS` in `macos.zsh`
- This repo is shared across multiple computers — avoid hardcoded paths (use `$HOME` instead of `/Users/cameronhurst`)
