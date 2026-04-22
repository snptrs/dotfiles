---
name: init-agents
description: Set up AGENTS.md and redirect CLAUDE.md to it, making project documentation tool-neutral so it works with any AI coding agent (Claude, Cursor, Copilot, Gemini CLI, etc.). Use when asked to "init agents", "create AGENTS.md", "set up for multiple AI agents", or whenever the user wants their Claude Code project docs to be usable by other AI tools too.
disable-model-invocation: true
---

This creates a tool-neutral `AGENTS.md` that any AI coding agent can use, while `CLAUDE.md` simply imports it via `@AGENTS.md`.

## Steps

### 1. Get the base documentation

- If `CLAUDE.md` exists and has real content (not just `@AGENTS.md`): use it as-is, skip to step 2
- Otherwise: run the `init` skill to generate `CLAUDE.md` first

### 2. Create AGENTS.md

Start from the `CLAUDE.md` content and apply these changes:

**Replace the opening header and intro** with:

```
# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.
```

**Neutralize tool-specific language** in the body text — but leave code blocks, URLs, and config values alone:

- `Claude Code` → `AI coding agents`
- `Claude` (when referring to the AI assistant) → `the AI coding agent`

### 3. Write the redirect

Overwrite `CLAUDE.md` with exactly one line:

```
@AGENTS.md
```

### 4. Confirm

Tell the user that `AGENTS.md` is ready and `CLAUDE.md` now imports it.
