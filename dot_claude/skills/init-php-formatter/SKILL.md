---
name: init-php-formatter
description: One-time setup skill to configure Laravel Pint as an automatic PHP formatter hook in a Docker-based Laravel project. Only invoke when the user explicitly calls /init-php-formatter or asks to "set up the pint hook", "configure the PHP formatter hook", or "add pint auto-formatting". Do NOT trigger on general questions about pint or PHP formatting.
---

# init-php-formatter

Wires up a `PostToolUse` hook that runs Laravel Pint automatically whenever Claude edits a PHP file in a Docker-based Laravel project.

## Steps

### 1. Find the container name

Read `docker-compose.yml`. Look for `container_name` on the `app` service — that's the value to use. If no explicit `container_name` is set, run `docker compose ps` to find the actual running name.

### 2. Confirm pint is installed

Check `composer.json` for `laravel/pint` in `require-dev`. If it's missing, install it:

```bash
docker compose exec app composer require laravel/pint --dev
```

Note: Pint requires PHP ≥ 8.2 for the latest version. Composer will automatically select the newest compatible version for the project's PHP version.

### 3. Confirm a pint config exists

Check for `pint.json` at the project root. If it doesn't exist, ask the user which preset they want — `laravel` (default), `psr12`, `symfony`, or `per` — then create it:

```json
{
  "preset": "laravel"
}
```

### 4. Write the hook

Read `.claude/settings.local.json` (create it if it doesn't exist). Merge in the hook below, preserving all existing content.

For the command, substitute:

- `CONTAINER_NAME` → the container name from step 1
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

**Why `read -r` and not `xargs`:** `xargs` splits on whitespace, breaking paths with spaces. `read -r` reads the whole line safely.

**Why `// empty` in jq:** If `file_path` is null (e.g. on a non-file tool call), jq produces no output, `read` gets EOF, `f` is empty, and the `*.php` guard prevents pint from running with no argument.

**Why `docker exec` and not `docker compose exec`:** `docker exec` uses the container name directly and doesn't allocate a TTY by default. `docker compose exec` allocates a TTY by default (requires `-T` to suppress), which can cause problems in non-interactive hook contexts.

**Path stripping:** The hook strips the project root prefix from the absolute file path so pint receives a relative path — which it needs, because pint runs inside the container where the project is mounted at a different absolute path. The container's working directory must be the project root (typically `/app` in Laravel Docker setups) for the relative path to resolve correctly.

### 5. Ensure `.claude/settings.local.json` is gitignored

Check `.gitignore` for an entry covering `.claude/settings.local.json`. If it's missing, append it:

```bash
echo '.claude/settings.local.json' >> .gitignore
```

This file contains personal configuration (container names, local paths) that shouldn't be shared with the team.

### 6. Pipe-test the hook

Pick a real PHP file from the project (e.g. `app/Models/User.php`) and run the full hook command end-to-end to confirm it works:

```bash
echo '{"tool_name":"Edit","tool_input":{"file_path":"/absolute/path/to/file.php"}}' | \
  jq -r '.tool_input.file_path // empty' | \
  { read -r f; [[ "$f" == *.php ]] && docker exec CONTAINER_NAME vendor/bin/pint "${f#PROJECT_ROOT/}"; }
```

Pint should output something like:

```
  PASS   app/Models/User.php
```

If you get `vendor/bin/pint: no such file or directory`, the container's working directory isn't the project root — check with `docker exec CONTAINER_NAME pwd` and adjust if needed.

### 7. Validate the JSON

```bash
jq -e '.hooks.PostToolUse[] | select(.matcher == "Write|Edit") | .hooks[] | select(.type == "command") | .command' .claude/settings.local.json
```

Exit 0 and the command printed = correct. A malformed settings file silently disables all settings.

### 8. Tell the user

Confirm the hook is set up and note: because the settings watcher only watches directories present at session start, they may need to open `/hooks` once or restart Claude Code for the hook to fire in this session.
