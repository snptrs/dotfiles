# Global Memory

## Claude config changes go through chezmoi

Always make changes to Claude config (settings.json, skills, keybindings, global CLAUDE.md, etc.) by editing files in the chezmoi source repo at `~/.local/share/chezmoi`, then running `chezmoi apply` — never edit `~/.claude` directly.

The user manages their dotfiles with chezmoi. Direct edits to `~/.claude` will be overwritten on the next `chezmoi apply` and won't be tracked in version control.

If asked to update Claude settings or skills from outside the chezmoi repo, locate the relevant file under `~/.local/share/chezmoi` (e.g. `dot_claude/` maps to `~/.claude/`), edit it there, then run `chezmoi apply`.

## Git commit style

Use conventional commits: `type: subject` format (`feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`). Subject is plain prose. Avoid adding a body in most cases; only add a body when the why isn't obvious from the subject.

## Code comments

Code comments should be used to explain how non-obvious code works, the reasoning behind why it works how it does, any caveats or footguns that agents and reviewers should be aware of, and references to other parts of the codebase that the reader may need to know about. Comments should be as brief as possible while still conveying the important information. Only write long comments when something really isn't obvious from reading the code.

NEVER refer to how things used to work or what the code is replacing – comments should be about how the code works _now_. The PR description is the place to put context about why something changed – that's one-time information that a reviewer may want. The only exception to this is if something changed and we want to make sure that nobody accidentally changes it back to the previous approach.
