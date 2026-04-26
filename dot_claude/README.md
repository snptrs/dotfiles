# ~/.claude

A lightweight brainstorm → spec → plan → execute pipeline. All config lives in `~/.claude/`, no per-project setup required. Managed via chezmoi — edit files in `~/.local/share/chezmoi/dot_claude/`, then run `chezmoi apply`.

## Workflow skills

Invoke these directly (e.g. `/brainstorm`, or say "let's brainstorm this"):

| Skill           | When to use                                                             |
| --------------- | ----------------------------------------------------------------------- |
| `/brainstorm`   | Refining a rough idea into a written spec                               |
| `/write-plan`   | Turning an approved spec into a task-by-task implementation plan        |
| `/execute-plan` | Running a plan task-by-task using subagent dispatch (explicit only)     |
| `/sketch`       | Generating browser-viewable HTML design variants to compare _(Phase 2)_ |

## Discipline skills

Not invoked directly — referenced from agent prompts and read on demand:

| Skill                | What it encodes                                                                 |
| -------------------- | ------------------------------------------------------------------------------- |
| `tdd`                | RED-GREEN-REFACTOR cycle; Iron Law; verification checklist                      |
| `verify-before-done` | Evidence before claims; gate function; no completion claims without a fresh run |
| `receiving-review`   | READ → UNDERSTAND → VERIFY → EVALUATE → RESPOND → IMPLEMENT                     |

## Agents

Dispatched by skills, not invoked directly:

| Agent           | Model  | Role                                                                                        |
| --------------- | ------ | ------------------------------------------------------------------------------------------- |
| `architect`     | Opus   | Deep design thinking; 2–3 distinct approaches; YAGNI                                        |
| `implementer`   | Haiku  | Executes a single task; TDD-strict; four-category self-review                               |
| `spec-reviewer` | Sonnet | Verifies code matches spec; "Do Not Trust the Report" posture                               |
| `code-reviewer` | Sonnet | End-of-plan whole-diff quality review (architecture, decomposition, cross-task consistency) |
| `plan-reviewer` | Sonnet | Pre-execution plan QA; completeness, spec alignment, buildability                           |

## Other skills

| Skill                  | When to use                                             |
| ---------------------- | ------------------------------------------------------- |
| `/pr-summary`          | Draft a PR title and description for the current branch |
| `/check-project-setup` | Audit a project's standard config (docs, hooks)         |
| `/init-agents`         | Set up AGENTS.md / CLAUDE.md for a new project          |
| `/init-php-formatter`  | One-time Laravel Pint/phpcbf hook setup                 |

## Key files

- `principles.md` — non-negotiable defaults; project `docs/principles.md` overrides
- `docs/specs/` — spec outputs from `/brainstorm` (human-reviewable)
- `docs/plans/` — plan outputs from `/write-plan` (implementer-facing)
- `NOTICES.md` — MIT attribution for files adapted from [Superpowers](https://github.com/obra/superpowers)
