---
name: execute-plan
description: Use when executing implementation plans with independent tasks in the current session. Explicit invocation only.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash(git rev-parse:*), Bash(git log:*), TodoWrite, Task
---

# Execute Plan

Execute a plan by dispatching a fresh subagent per task, with two-stage review after each: spec compliance first, then code quality.

**Why subagents:** You delegate tasks to specialized agents with isolated context. By precisely crafting their instructions and context, you ensure they stay focused and succeed at their task. Subagents never inherit your session's context or history — you construct exactly what they need. This also preserves your own context for coordination work.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration.

## Setup

1. Find the plan file: use the path from the user's invocation, or locate the most recent file in `docs/plans/`.
2. Read the plan header to find the spec path (the `Spec:` line in the header).
3. Read the spec file.
4. Build a TodoWrite list from all task headings in the plan — lines matching `### Task N:` that do **not** already have ✅. Each todo entry should be the full task heading text.
5. Note the SHA before the first task: `FIRST_SHA = $(git rev-parse HEAD)`

**Resuming after interruption:** If the plan already has tasks with ✅ appended to their heading, skip those. Only iterate over tasks without ✅. Don't redo completed work.

## Per-Task Loop

For each unchecked task, in order:

### 1. Capture baseline

```bash
BASE_SHA=$(git rev-parse HEAD)
```

### 2. Dispatch @implementer

Assess the task's complexity to choose a model:

- **`haiku`** — touches 1-2 files, fully-specified steps, no integration concerns
- **`sonnet`** — touches multiple files, requires pattern-matching across the codebase, or has integration concerns
- **`opus`** — requires design judgment or broad codebase understanding

Pass the chosen model as the `model` parameter when dispatching (overrides the agent's `haiku` default).

Provide the implementer with:

- The full task text from the plan (copy verbatim — do not reference the file, provide the text directly)
- Path to the spec file
- Path to the principles file (`docs/principles.md` if present, otherwise `~/.claude/principles.md`)
- Working directory

Wait for status: `DONE` | `DONE_WITH_CONCERNS` | `NEEDS_CONTEXT` | `BLOCKED`

### 3. Handle implementer status

**DONE:** Proceed to spec review.

**DONE_WITH_CONCERNS:** Read the concerns before proceeding. If concerns are about correctness or scope, address them before review. If they're observations (e.g., "this file is getting large"), note and proceed to review.

**NEEDS_CONTEXT:** The plan or spec is missing information the implementer needs. Provide the missing context and re-dispatch.

**BLOCKED:** Assess the blocker:

1. Context problem → provide more context, re-dispatch with same model
2. Reasoning problem → re-dispatch with a more capable model
3. Task too large → break into smaller pieces, re-dispatch
4. Plan is wrong → escalate to user, stop execution

Never ignore an escalation or force the same model to retry without changes.

### 4. Capture head SHA

```bash
HEAD_SHA=$(git rev-parse HEAD)
```

### 5. Dispatch @spec-reviewer

Provide:

- `BASE_SHA` and `HEAD_SHA`
- Path to the spec file
- The implementer's full report

**Branch on findings (max 3 review iterations per task):**

- Any `[BLOCK]` → re-dispatch `@implementer` with the findings and instruction to apply the `receiving-review` skill (verify before implementing, ask before assuming). After re-implementation, update HEAD_SHA and re-run spec review.
- Any `[CONCERN]` → log and continue to code review.
- Only `[NIT]` or no findings → continue to code review.

**Do NOT start code quality review until spec compliance is ✅.**

### 6. Dispatch @code-reviewer

Provide:

- `BASE_SHA` and `HEAD_SHA`
- Path to the plan file
- Path to the spec file
- Summary of what the implementer built

**Branch on findings (same 3-iteration budget shared with spec review):**

- Any `[BLOCK]` → re-dispatch `@implementer` with findings and `receiving-review` instruction; after re-implementation, re-run code review.
- Any `[CONCERN]` → log and continue.
- Only `[NIT]` or no findings → continue.

**If still blocked after 3 iterations total:** Surface to user. Ask how to proceed. Do not loop indefinitely.

### 7. Mark the task complete in the plan file

Use the Edit tool to append ` ✅` to the `### Task N:` heading for the completed task. Do not modify the step checkboxes (`- [ ]` / `- [x]`) — those belong to the implementer.

### 8. Mark complete in TodoWrite

Mark the task done. Continue to next unchecked task.

## After All Tasks

Dispatch `@code-reviewer` once over the entire implementation:

- `BASE_SHA` = `FIRST_SHA` (the SHA before the first task)
- `HEAD_SHA` = current HEAD
- Provide paths to the plan and spec

Apply the same severity branching. Surface any BLOCKs to the user before declaring done.

## Model Selection

The `model` parameter passed at dispatch overrides the implementer's `haiku` frontmatter default. Reviewers and the architect have fixed models appropriate to their roles — only the implementer needs per-task selection.

When a task returns `BLOCKED` and you re-dispatch with a more capable model, don't re-assess — just move up one tier.

## Red Flags

**Never:**

- Skip spec compliance review OR code quality review
- Start code quality review before spec compliance is ✅
- Proceed with unfixed `[BLOCK]` findings
- Dispatch multiple implementation subagents in parallel (conflicts)
- Make subagents read the plan file directly — provide the task text to them
- Ignore subagent questions — answer before letting them proceed
- Accept "close enough" on spec compliance
- Skip review loops when reviewer found issues (re-review is required)
- Let implementer self-review replace actual review (both are needed)
- Move to next task while either review has open issues

**If subagent asks questions:**

- Answer clearly and completely
- Provide additional context if needed
- Don't rush into implementation

**If reviewer finds issues:**

- Implementer fixes them
- Reviewer reviews again
- Repeat until approved (within the 3-iteration budget)

## Context Isolation

Subagents receive only the context they need — never this session's full history. When dispatching:

- Provide the task text verbatim (not a file reference)
- Provide the spec path (let them read it)
- Provide the principles path
- Provide any implementer report the reviewer needs

Do not narrate your session state or reasoning to subagents. Construct exactly what they need.
