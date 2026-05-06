---
name: fix
description: Fix one or more numbered issues from the most recent @code-review output in this session. Invoke when the user says "fix issue N", "/fix N", "fix issues N and M", "fix 1 3 5", etc. Requires a prior @code-review run in this session.
allowed-tools: Read, Edit, Grep, Glob, Bash(git diff:*)
---

# Fix Review Issues

Apply fixes for the numbered issues from the most recent code review in this
conversation.

## Step 1: Identify issues to fix

Parse the user's request for issue numbers. Find each one in the code review
output above — note the file:line reference and the description.

## Step 2: Fix each issue

For each issue, in order:

1. Read the relevant file to understand context around the flagged line
2. Apply the fix
3. If the fix has non-obvious implications (e.g. a query change with multiple
   callers), check those too before editing

## Step 3: Report

One line per fix: `Fixed #N — brief description of what changed.`

If an issue can't be fixed without a decision from you (e.g. requires
architectural choice or information not in the codebase), say so and explain
what's needed rather than guessing.
