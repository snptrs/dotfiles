# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## What this repo is

A [chezmoi](https://www.chezmoi.io/) dotfiles repository managing macOS configuration. chezmoi manages the mapping between this source directory and the actual home directory.

## chezmoi conventions

- Files prefixed `dot_` map to dotfiles (e.g. `dot_gitconfig.tmpl` → `~/.gitconfig`)
- Files prefixed `private_` have restricted permissions on apply
- `.tmpl` suffix means the file is a Go template processed by chezmoi with data from `.chezmoi.toml.tmpl`
- `run_once_before_*` scripts run once on `chezmoi apply` (tracked by hash)
- Template data variables: `{{ .personal_email }}`, `{{ .work_email }}`, `{{ .is_work_mac }}`
- Secrets are pulled from 1Password via `onepasswordRead "op://..."` in the config template

## Key commands

```sh
chezmoi apply          # Apply changes from this source to home directory
chezmoi edit <file>    # Edit a managed file (uses cme abbr in fish)
chezmoi status         # Show what would change
chezmoi diff           # Show diff (uses delta)
```

## Architecture

### Managed configs

- **Shell**: fish (`dot_config/private_fish/`) — config, functions, abbreviations. Uses hydro prompt, zoxide, fzf, pet, sesh.
- **Editor**: Neovim (`dot_config/nvim/`) — Lua config using `vim.pack` (native Neovim 0.11+ package manager, no lazy.nvim). Plugins in `lua/plugins/`, core settings in `lua/config/`.
- **Terminal**: Ghostty (primary), with Zellij as multiplexer (`dot_config/zellij/`)
- **Git**: `dot_gitconfig.tmpl` — uses delta for diffs, conditional includes for work vs personal identity

### Neovim plugin architecture

Uses `vim.pack.add` (Neovim 0.11+ native). Plugin config files in `lua/plugins/` are loaded via `lua/plugins/init.lua`. Key plugins:

- **mini.nvim** — core utilities (files, pick, extra, bufremove)
- **blink.cmp** — completion (pinned to v1.10.1)
- **Mason** + mason-tool-installer — LSP/formatter management
- **conform.nvim** — format on save (most filetypes); PHP excluded from `format_on_save` due to pint needing `format_after_save`
- **snacks.nvim** — lazygit integration, zen mode, terminal, buffer management
- **MiniPick** — fuzzy finder (replaces telescope); `<leader>ff` files, `<leader>fs` grep, `<space><space>` buffers

### Work vs personal branching

`.chezmoiignore` excludes `Work/` and certain Library paths on work machines. `dot_gitconfig.tmpl` includes `Work/.gitconfig` conditionally via `includeIf` when `is_work_mac = false`.

### Package management

`run_once_before_install-packages-darwin.sh.tmpl` — Homebrew bundle (taps, brews, casks, mas apps). Personal-only apps (DEVONthink, Anki, etc.) gated behind `{{ if eq .is_work_mac false }}`. Fisher is bootstrapped if not present.
