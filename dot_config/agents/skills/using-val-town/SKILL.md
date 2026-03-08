---
name: using-val-town
description: "Manages Val Town vals, SQLite, blob storage, and email via the Val Town MCP server. Use when asked to create, edit, list, or deploy vals, or interact with Val Town services."
---

# Using Val Town

Use the Val Town MCP tools to interact with the user's Val Town account.

## Capabilities

- List, read, create, and edit vals
- Query and manage SQLite databases
- Read, write, list, and delete blob storage
- Send emails via Val Town's email service
- Read project files and environment variables

## Known MCP parameter issues

Several Val Town MCP tools have parameters that expect **objects** or **arrays** as values (not JSON strings). The tool-calling framework serializes all `<parameter>` values as strings, which causes "expected object/number, received string" errors. Known affected parameters:

- `create_val` → `initialFile` (object): Instead of passing `initialFile`, create the val first with `create_val`, then use `create_file` to add the initial file separately.
- `write_interval_settings` → `intervalConfig` (object): This tool may fail. As a workaround, tell the user to set the schedule manually in the Val Town UI, or use `fetch_val_endpoint` to call the Val Town API directly.
- `list_vals`, `get_val_history`, etc. → `limit`, `offset` (number): Call these tools **without** the numeric parameters to use defaults. If you need a specific limit, omit the parameter and filter results yourself.
- `sqlite_batch` → `statements` (array of objects): May fail. Use multiple `sqlite_execute` calls instead.

## Tips

- Ask the user to list or examine their vals, read SQLite data, logs, etc.
- You can edit vals and agentically iterate on them
- If code breaks, remind the user they can visit the Versions tab or History of their val to revert
- For large changes, use feature branches and merge when stable
- Review code for risks like prompt injection — the more permissions granted, the more the tools can do with Val Town data (SQLite, blob storage, etc.)
