---
name: init-php-formatter
description: One-time setup skill to configure an automatic PHP formatter hook in a Docker-based Laravel project. Supports Laravel Pint and phpcbf. Only invoke when the user explicitly calls /init-php-formatter or asks to "set up the pint hook", "configure the PHP formatter hook", "add pint auto-formatting", or "set up the phpcs hook". Do NOT trigger on general questions about pint, phpcs, or PHP formatting.
---

# init-php-formatter

Wires up a `PostToolUse` hook that runs a PHP formatter automatically whenever Claude edits a PHP file in a Docker-based Laravel project. Detects whether the project uses Laravel Pint or phpcs/phpcbf and configures the hook accordingly.

## Step 1: Detect which formatter to use

Read `composer.json` and check `require-dev` for `laravel/pint` and `squizlabs/php_codesniffer`.

| Situation  | Action                                                                      |
| ---------- | --------------------------------------------------------------------------- |
| Pint only  | Use Pint (follow the **Pint path** below)                                   |
| phpcs only | Use phpcbf (follow the **phpcs path** below)                                |
| Both       | Check CI config (see below), then ask the user with a recommendation        |
| Neither    | Abort — tell the user no supported PHP formatter was found in `require-dev` |

### When both are present

Check `.gitlab-ci.yml` for which formatter the project's CI pipeline actually runs:

- If CI invokes `pint` (e.g. `vendor/bin/pint`) but not `phpcs`/`phpcbf` → recommend Pint
- If CI invokes `phpcs` or `phpcbf` but not `pint` → recommend phpcbf
- If CI invokes both, or neither is found → no recommendation; just ask

Then ask the user, naming the recommendation where you have one. For example:

> Both `laravel/pint` and `squizlabs/php_codesniffer` are in `require-dev`. Your CI pipeline runs **pint**, so that's probably the right choice — but you can use either. Which formatter do you want for the auto-format hook?

If you couldn't find a CI file or couldn't determine which formatter it uses, say so briefly and still ask:

> Both `laravel/pint` and `squizlabs/php_codesniffer` are in `require-dev` (no CI preference detected). Which formatter do you want for the auto-format hook?

## Step 2: Find the container name

Read `docker-compose.yml`. Look for `container_name` on the `app` service — that's the value to use. If no explicit `container_name` is set, run `docker compose ps` to find the actual running name.

---

## Pint path

### P1. Confirm pint is installed

Check `composer.json` for `laravel/pint` in `require-dev`. If it's missing, install it:

```bash
docker compose exec app composer require laravel/pint --dev
```

Note: Pint requires PHP ≥ 8.2 for the latest version. Composer will automatically select the newest compatible version for the project's PHP version.

### P2. Confirm a pint config exists

Check for `pint.json` at the project root. If it doesn't exist, ask the user which preset they want — `laravel` (default), `psr12`, `symfony`, or `per` — then create it:

```json
{
  "preset": "laravel"
}
```

### P3. Write the hook

Read `.claude/settings.local.json` (create it if it doesn't exist). Merge in the hook below, preserving all existing content.

Substitute:

- `CONTAINER_NAME` → the container name from step 2
- `PROJECT_ROOT` → the absolute path of the project root (the current working directory)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path // empty' | { read -r f; [[ \"$f\" == *.php ]] && docker exec CONTAINER_NAME vendor/bin/pint \"${f#PROJECT_ROOT/}\"; } 2>/dev/null || true",
            "statusMessage": "Running pint..."
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": ["Bash(docker exec CONTAINER_NAME *)"]
  }
}
```

Then continue to the **shared steps** below.

---

## phpcs path

### C1. Determine the standard to use

Work through this chain in order, stopping as soon as you find something:

1. **Look for a phpcs config file** — check for `phpcs.xml`, `.phpcs.xml`, `phpcs.xml.dist`, `.phpcs.xml.dist` at the project root. If found, phpcbf will pick it up automatically — no `--standard` flag needed. Proceed with no flag and skip to C2.

2. **Check `.gitlab-ci.yml`** — look for a `phpcs` invocation and extract the `--standard=X` value from it. Confirm with the user: "CI is running phpcs with `--standard=X` — use that for the hook?"

3. **Check `pint.json`** — read the `preset` field. Note that pint presets don't map 1:1 to phpcs standards, but `psr12` maps directly to `--standard=PSR12`. For other presets, tell the user what was found and ask them to confirm or specify the standard.

4. **Ask the user** — if nothing was found, ask which standard to use (common options: `PSR12`, `PSR2`).

### C2. Write the hook

Read `.claude/settings.local.json` (create it if it doesn't exist). Merge in the hook below, preserving all existing content.

Substitute:

- `CONTAINER_NAME` → the container name from step 2
- `PROJECT_ROOT` → the absolute path of the project root
- `STANDARD_FLAG` → either `--standard=PSR12` (or whichever standard was determined) if no config file was found, or empty string if a config file exists

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path // empty' | { read -r f; [[ \"$f\" == *.php ]] && docker exec CONTAINER_NAME vendor/bin/phpcbf STANDARD_FLAG \"${f#PROJECT_ROOT/}\"; } 2>/dev/null || true",
            "statusMessage": "Running phpcbf..."
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": ["Bash(docker exec CONTAINER_NAME *)"]
  }
}
```

**Note on phpcbf exit codes:** phpcbf exits with code `1` when it successfully makes changes (not an error). The `|| true` at the end ensures this doesn't fail the hook.

Then continue to the **shared steps** below.

---

## Shared steps

### S1. Ensure `.claude/settings.local.json` is gitignored

Check `.gitignore` for an entry covering `.claude/settings.local.json`. If it's missing, append it:

```bash
echo '.claude/settings.local.json' >> .gitignore
```

This file contains personal configuration (container names, local paths) that shouldn't be shared with the team.

### S2. Pipe-test the hook

Pick a real PHP file from the project (e.g. `app/Models/User.php`) and run the full hook command end-to-end to confirm it works.

**For pint:**

```bash
echo '{"tool_name":"Edit","tool_input":{"file_path":"/absolute/path/to/file.php"}}' | \
  jq -r '.tool_input.file_path // empty' | \
  { read -r f; [[ "$f" == *.php ]] && docker exec CONTAINER_NAME vendor/bin/pint "${f#PROJECT_ROOT/}"; }
```

Expected output: `  PASS   app/Models/User.php`

**For phpcbf:**

```bash
echo '{"tool_name":"Edit","tool_input":{"file_path":"/absolute/path/to/file.php"}}' | \
  jq -r '.tool_input.file_path // empty' | \
  { read -r f; [[ "$f" == *.php ]] && docker exec CONTAINER_NAME vendor/bin/phpcbf STANDARD_FLAG "${f#PROJECT_ROOT/}"; }
```

Expected output: a phpcbf report showing no fixable errors, or a list of changes made.

If you get `vendor/bin/pint: no such file or directory` or similar, the container's working directory isn't the project root — check with `docker exec CONTAINER_NAME pwd` and adjust if needed.

### S3. Validate the JSON

```bash
jq -e '.hooks.PostToolUse[] | select(.matcher == "Write|Edit") | .hooks[] | select(.type == "command") | .command' .claude/settings.local.json
```

Exit 0 and the command printed = correct. A malformed settings file silently disables all settings.

### S4. Tell the user

Confirm the hook is set up, which formatter was configured, and what standard is being used. Note: because the settings watcher only watches directories present at session start, they may need to open `/hooks` once or restart Claude Code for the hook to fire in this session.

---

## Notes on hook design

**Why `read -r` and not `xargs`:** `xargs` splits on whitespace, breaking paths with spaces. `read -r` reads the whole line safely.

**Why `// empty` in jq:** If `file_path` is null (e.g. on a non-file tool call), jq produces no output, `read` gets EOF, `f` is empty, and the `*.php` guard prevents the formatter from running with no argument.

**Why `docker exec` and not `docker compose exec`:** `docker exec` uses the container name directly and doesn't allocate a TTY by default. `docker compose exec` allocates a TTY by default (requires `-T` to suppress), which can cause problems in non-interactive hook contexts.

**Path stripping:** The hook strips the project root prefix from the absolute file path so the formatter receives a relative path — which it needs, because it runs inside the container where the project is mounted at a different absolute path. The container's working directory must be the project root (typically `/app` in Laravel Docker setups) for the relative path to resolve correctly.
