# Global Memory

## Claude config changes go through chezmoi

Always make changes to Claude config (settings.json, skills, keybindings, global CLAUDE.md, etc.) by editing files in the chezmoi source repo at `~/.local/share/chezmoi`, then running `chezmoi apply` — never edit `~/.claude` directly.

The user manages their dotfiles with chezmoi. Direct edits to `~/.claude` will be overwritten on the next `chezmoi apply` and won't be tracked in version control.

If asked to update Claude settings or skills from outside the chezmoi repo, locate the relevant file under `~/.local/share/chezmoi` (e.g. `dot_claude/` maps to `~/.claude/`), edit it there, then run `chezmoi apply`.

## Git commit style

Use conventional commits: `type: subject` format (`feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`). Subject is plain prose. Avoid adding a body in most caes; only add a body when the why isn't obvious from the subject.
