---
name: execute-plan
description: Use when the user is ready to execute an approved implementation plan from `docs/plans/` — produced by the `write-plan` skill. Dispatches one subagent per task with spec-compliance review per task, plus a single end-of-plan code-quality review across the full change. Invoke when the user says something like "let's start", "execute the plan", "go", or "run it".
allowed-tools: Read, Edit, Bash(git rev-parse:*), Bash(git log:*), TodoWrite, Task
---

# Execute Plan

Execute a plan (from `docs/plans/`, produced by `write-plan`) by dispatching a fresh subagent per task with spec-compliance review after each, plus a single code-quality review across the full change once every task is done.

**Why subagents:** You delegate tasks to specialized agents with isolated context. By precisely crafting their instructions and context, you ensure they stay focused and succeed at their task. Subagents never inherit your session's context or history — you construct exactly what they need. This also preserves your own context for coordination work.

**Core principle:** Fresh subagent per task + spec-compliance review per task + a single code-quality review at the end = high quality without per-task review overhead.

## Setup

1. Find the plan file: use the path from the user's invocation, or locate the most recent file in `docs/plans/`.
2. Read the plan header to find the spec path (the `Spec:` line in the header).
3. Read the spec file.
4. Build a TodoWrite list from all task headings in the plan — lines matching `### Task N:`. A task is already complete if every step checkbox under it is `- [x]`; skip those. Each remaining todo entry should be the full task heading text.
5. Note the SHA before the first task: `FIRST_SHA = $(git rev-parse HEAD)`

**Resuming after interruption:** Tasks whose step checkboxes are all `- [x]` are done — skip them. Only iterate over tasks with at least one unchecked step. Don't redo completed work.

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

**Test-design difficulty bump:** test design is design. If the task's `Test:` type is `integration`, or its `Test difficulty:` is marked `high`, or the task involves non-trivial async / mocking / fixture setup, bump one tier (haiku → sonnet, sonnet → opus). Writing good tests against complex setup is judgment work the implementer can't fake.

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

**Branch on findings (max 3 spec-review iterations per task):**

- Any `[BLOCK]` → re-dispatch `@implementer` with the findings and instruction to apply the `receiving-review` skill (verify before implementing, ask before assuming). After re-implementation, update HEAD_SHA and re-run spec review.
- Any `[CONCERN]` → log and continue to next step.
- Only `[NIT]` or no findings → continue to next step.

**If spec-reviewer still finds BLOCKs after 3 iterations:** surface to user. Ask how to proceed. Do not loop indefinitely.

### 6. Mark complete in TodoWrite

Mark the task done. Continue to next unchecked task. The implementer already checks off the step checkboxes (`- [ ]` → `- [x]`) inside the task as part of its commit — that's the persistent resumption signal, so no further edits to the plan file are needed.

## After All Tasks

Dispatch `@code-reviewer` once over the entire implementation. **This is the only code-quality review in the flow** — per-task code review is not done. Scope the review to whole-implementation concerns: architectural coherence, decomposition across the change, cross-task consistency, file-growth across the whole effort. Do not duplicate per-task spec-compliance checks (`spec-reviewer` already ran on each task).

- `BASE_SHA` = `FIRST_SHA` (the SHA before the first task)
- `HEAD_SHA` = current HEAD
- Provide paths to the plan and spec

Apply the same severity branching. Surface any BLOCKs to the user before declaring done.

## Model Selection

The `model` parameter passed at dispatch overrides the implementer's `haiku` frontmatter default. Reviewers and the architect have fixed models appropriate to their roles — only the implementer needs per-task selection.

When a task returns `BLOCKED` and you re-dispatch with a more capable model, don't re-assess — just move up one tier.

## Red Flags

**Never:**

- Skip the per-task spec-compliance review or the end-of-plan code-quality review
- Proceed with unfixed `[BLOCK]` findings
- Dispatch multiple implementation subagents in parallel (conflicts)
- Make subagents read the plan file directly — provide the task text to them
- Ignore subagent questions — answer before letting them proceed
- Accept "close enough" on spec compliance
- Skip the spec-reviewer re-review loop when it found issues (re-review is required)
- Let implementer self-review replace actual review (spec-reviewer per task + code-reviewer end-of-plan are both still needed)
- Move to next task while spec-reviewer has open BLOCKs

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
