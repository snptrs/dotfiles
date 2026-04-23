---
name: check-project-setup
description: Audit the current project's standard setup — documentation files, the global prettier formatting hook, and (for Laravel projects) the PHP formatter hook (Pint or phpcbf). Use this whenever the user asks to "check project setup", "audit my project config", "verify hooks are working", "is this repo set up right", or runs /check-project-setup. Run it proactively the first time working in an unfamiliar repo if the user hints they want things configured correctly.
---

# check-project-setup

Audit whether the current project has the standard setup in place, then offer to fix whatever failed.

## How this skill runs

Two phases, in order:

1. **Report**: run all checks, print a single consolidated report. Do not interrupt mid-flight to offer fixes — the user wants to see the whole picture first.
2. **Fix**: after the report, if anything failed, ask which failures the user wants to fix. Apply fixes one at a time. Don't auto-fix without asking.

Run all checks even if an earlier one fails — the user benefits from seeing every issue in one pass.

## The checks

### 1. Documentation files

Look at the project root for `CLAUDE.md` and `AGENTS.md`.

- Both present → pass
- Either missing → fail. Remediation: the `init-agents` skill (it creates `AGENTS.md` from the existing `CLAUDE.md` content and makes `CLAUDE.md` redirect to it via `@AGENTS.md`)

A `CLAUDE.md` that contains just `@AGENTS.md` counts as present — that's the expected state after `init-agents` has run.

### 2. Global prettier write/edit hook

The global hook lives in `~/.claude/settings.json`. It runs on every Write/Edit and pipes the file path into prettier:

```
jq -r '.tool_input.file_path' | xargs pnpm dlx prettier --write --ignore-unknown || true
```

The `|| true` in the real hook swallows errors silently, which is exactly why this check exists — a broken hook is invisible during normal use. Verify it will actually work _in this project_:

**a) Hook declared globally.** Confirm a `PostToolUse` hook matching `Write|Edit` that calls prettier exists in `~/.claude/settings.json`:

```bash
jq -e '.hooks.PostToolUse[]? | select(.matcher | test("Write|Edit")) | .hooks[]? | select(.command | test("prettier"))' ~/.claude/settings.json >/dev/null
```

If this fails, the hook isn't configured at all — everything else in this check is moot.

**b) Dependencies on PATH.** `command -v jq` and `command -v pnpm` both exit 0. Either missing → fail, and report which one.

**c) End-to-end smoke test.** Pick a real file in the project and run the actual hook command against it. Prefer a type prettier handles (`.js`, `.ts`, `.tsx`, `.json`, `.md`, `.yml`) so the run is a true positive. Fall back to any regular file — `--ignore-unknown` means prettier will no-op but still exit 0.

```bash
FILE=$(find . -maxdepth 3 -type f \
  \( -name '*.js' -o -name '*.ts' -o -name '*.tsx' -o -name '*.jsx' \
     -o -name '*.json' -o -name '*.md' -o -name '*.yml' -o -name '*.yaml' \) \
  -not -path './node_modules/*' -not -path './vendor/*' -not -path './.git/*' \
  | head -1)
[ -z "$FILE" ] && FILE=$(find . -maxdepth 2 -type f -not -path './.git/*' | head -1)

ABS="$(pwd)/${FILE#./}"
printf '{"tool_input":{"file_path":"%s"}}' "$ABS" \
  | jq -r '.tool_input.file_path' \
  | xargs pnpm dlx prettier --write --ignore-unknown
```

Drop the `|| true` that the real hook has — you want to see the real exit code. Exit 0 = pass. Non-zero = fail; capture stderr for the report.

If the project has no files at all (fresh repo), skip the smoke test and note that in the report rather than failing it.

### 3. Laravel PHP formatter hook (conditional)

**Detect Laravel first.** Laravel may live at the project root _or_ in a `backend/` subdirectory. Check both locations:

- `artisan` exists at the project root **or** at `backend/artisan`
- The corresponding `composer.json` (same directory as `artisan`) has `laravel/framework` in `require` (not just `require-dev`)

Record which location was found (`root` or `backend/`) — you'll need it for the vendor path below.

If not Laravel → skip this check; note "skipped — not a Laravel project" in the report. Do not fail.

**If Laravel**, check `.claude/settings.local.json` for a `PostToolUse` hook on `Write|Edit` that invokes either `pint` or `phpcbf` under the correct vendor path. If Laravel is at the root, the path is `vendor/bin/pint` or `vendor/bin/phpcbf`; if it's under `backend/`, the path is `backend/vendor/bin/pint` or `backend/vendor/bin/phpcbf`.

```bash
[ -f .claude/settings.local.json ] && jq -e '
  .hooks.PostToolUse[]?.hooks[]? | select(.command | test("vendor/bin/pint|vendor/bin/phpcbf"))
' .claude/settings.local.json >/dev/null 2>&1
```

- Exit 0 → pass. Note in the report which formatter is configured (pint or phpcbf).
- Otherwise → fail. Remediation: the `init-php-formatter` skill

## The report

Print a single compact summary after all checks finish. Example:

```
Project setup check
  ✓ Documentation — CLAUDE.md and AGENTS.md both present
  ✗ Prettier hook — pnpm not on PATH
  — Laravel PHP formatter hook — skipped, not a Laravel project
```

Or for a Laravel project with the hook configured:

```
Project setup check
  ✓ Documentation — CLAUDE.md and AGENTS.md both present
  ✓ Prettier hook — smoke test passed
  ✓ Laravel PHP formatter hook — phpcbf configured
```

Use `✓` / `✗` / `—` (pass / fail / skipped) or `OK` / `FAIL` / `SKIP` if the glyphs render poorly. For any `✗`, include enough detail on the same or next line that the user understands _why_ it failed (missing binary, stderr from the smoke test, file path that didn't exist, etc.).

Keep the report scannable — five seconds to read, max.

## Offering fixes

After the report, if everything passed, say so and stop.

Otherwise, list the failing checks and ask which ones to fix. For each fix the user accepts:

- **Docs missing** → invoke the `init-agents` skill
- **Prettier hook broken**:
  - `pnpm` missing → suggest `npm install -g pnpm` (or `brew install pnpm` on macOS). Ask before installing.
  - `jq` missing → suggest `brew install jq` on macOS or the appropriate package manager elsewhere. Ask before installing.
  - Global hook not declared → show the user the snippet to add to `~/.claude/settings.json` and ask if they want you to apply it
  - Smoke test failed for another reason → show the stderr and ask how to proceed; don't guess
- **PHP formatter hook missing** → invoke the `init-php-formatter` skill (it will detect whether the project uses Pint or phpcs and configure accordingly)

Never run a fix without explicit agreement on that specific fix — even if the user already confirmed a different one.
