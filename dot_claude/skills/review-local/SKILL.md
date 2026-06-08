---
name: review-local
description: Use when the user wants their local code changes reviewed — working-tree changes, a specific commit, a branch diff, or a single file. Triggers on phrasings like "review my changes", "take a look at what I did", "check this diff", "review this commit", "review src/foo.ts". Always invoke for local-scope review even if the user doesn't say "review" explicitly. Do NOT trigger for pull-request review (use the built-in `/review` skill) or security review (use `/security-review`).
allowed-tools: Task
---

# Review Local Changes

Dispatch the `@code-review` agent to review whatever local scope the user named — uncommitted changes, a commit, a branch diff, or a specific file. The agent determines scope itself; this skill makes no scope decisions.

## How to dispatch

Use the `Task` tool with `subagent_type: code-review`. Pass the user's request verbatim as the prompt, including any scope they specified. Don't summarize, interpret, or rewrite it.

If the user gave no scope, pass the request as-is — `@code-review` defaults to reviewing current working-tree changes.

## What not to do

Don't review inline. The skill exists to dispatch every time; the agent has the persona, model, and tool restrictions you want applied.
