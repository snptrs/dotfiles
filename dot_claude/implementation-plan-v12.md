# Implementation plan v11: lightweight Claude Code setup

A phased, implementation-ready plan to replace Superpowers with a native-first scaffold of skills, agents, and (one) hook living in `~/.claude/` (standalone configuration), version-controlled via the user's existing dotfiles repo. Builds incrementally so each phase is usable on its own. Adapts content from Superpowers (MIT licensed) where it fits, and integrates with the user's existing `check-project-setup` skill.

**This document is the implementation spec.** It contains the concrete content for bespoke files and detailed porting instructions for files derived from Superpowers. An implementing agent should read top-to-bottom, follow the build order at the end, and use the "Implementation reference" appendix for porting details.

**Changelog from v11:** sketch skill refactored to a frame-plus-fragments pattern — one shared chrome file, body-only variant fragments — borrowing the framing idea from Superpowers' visual-companion without the 340-line WebSocket server it bundles. Optional Phases 4 (hook-based TDD reinforcement) and 5 (delta specs) removed; if either becomes needed it can be planned separately.

---

## Architecture decisions (finalised)

**Distribution: standalone configuration at `~/.claude/`, managed via dotfiles.** Per the official Claude Code docs (https://code.claude.com/docs/en/plugins), plugins are designed for sharing/distribution and impose namespacing on skills. For a single-user toolkit, standalone configuration is what the docs explicitly recommend.

**No per-project setup required.** New projects work immediately. The TDD discipline is enforced by the `tdd` skill (which the implementer reads), the implementer's self-review checklist, the spec-reviewer's distrust posture, and the code-reviewer's quality checks — not by hooks.

**Plan-mode-vs-brainstorm split:** Brainstorm skill is _what to build_, native plan mode (Shift+Tab) is _quick how-to-build for ad-hoc exploration_, the brainstorm→spec→plan→execute pipeline is _structured how-to-build for real work_. Different lanes, no overlap.

**Skill invocation: manual-first, model-invocation as soft fallback.** Skills have clean, descriptive `description` fields — Claude can pick them up on natural phrases like "let's brainstorm this," but we're not engineering for aggressive auto-trigger. No meta-skill, no SessionStart injection, no "1% Rule." `execute-plan` is explicitly opt-in via `disable-model-invocation: true`. `sketch` is model-invocable because deciding when visual variants help is reasonably a model judgement.

**Skill descriptions follow the Superpowers writing-skills rule:** descriptions state triggering conditions only, never summarise the workflow. Example anti-pattern (avoid): "dispatches implementer subagent and runs two-stage review." Example good pattern: "Use when executing implementation plans with independent tasks." Reason: when descriptions summarise workflow, the agent follows the description rather than reading the skill body.

**Spec is human-first; plan is machine-first.** The spec is the review gate — read in detail and edited before approving plan generation. The plan is for the implementer subagent — verbose task breakdowns with exact file paths and code-level guidance, optimised for mechanical execution. The user spot-checks the plan but doesn't read it linearly. This is what makes Haiku viable as implementer.

**Setup integrates with `check-project-setup`.** The user's existing `check-project-setup` audits per-project config; corresponding `init-*` skills do one-time setup. This kit doesn't extend either in core phases.

**State during execute-plan:** TodoWrite is the live source of truth during execution; plan checkboxes are durable state ticked at the end of each task. If a session crashes mid-execute, the next session reads the plan, builds a TodoWrite from unchecked items, and resumes.

**Context isolation (from Superpowers release notes, March 2026):** subagents receive only the precisely crafted context they need to do their job — never the controller's session history. Each port of a skill that dispatches subagents must preserve this principle.

**Worktrees:** Skipped. Revisit if parallel features become routine.

---

## Layout

### Global (in dotfiles repo, symlinked into `~/.claude/`)

```
~/.claude/
├── settings.json                       # registers SessionEnd hook only
├── principles.md                       # default constitution
├── skills/
│   ├── brainstorm/SKILL.md             # workflow: refine spec
│   ├── write-plan/SKILL.md             # workflow: spec → plan
│   ├── execute-plan/SKILL.md           # workflow: plan → impl
│   ├── tdd/SKILL.md                    # discipline: RED-GREEN-REFACTOR
│   ├── verify-before-done/SKILL.md     # discipline: evidence before claims
│   ├── receiving-review/SKILL.md       # discipline: handling reviewer feedback
│   ├── sketch/SKILL.md                 # workflow: HTML mockups
│   ├── init-agents/SKILL.md            # setup: existing (untouched)
│   ├── init-php-formatter/SKILL.md     # setup: existing (untouched)
│   └── check-project-setup/SKILL.md    # audit: existing (untouched in core phases)
├── agents/
│   ├── architect.md
│   ├── implementer.md
│   ├── spec-reviewer.md
│   ├── code-reviewer.md
│   └── plan-reviewer.md
└── hooks/
    └── session-end-cleanup.sh          # SessionEnd: kills sketch server
```

Skills `tdd`, `verify-before-done`, and `receiving-review` are **discipline skills** — they encode operational patterns referenced from agent prompts, not workflows triggered by user phrasing. They're model-invocable but expected to be loaded by reference (an agent's body says "follow the tdd skill's RED-GREEN-REFACTOR cycle").

### Per-project

```
<project-root>/
├── docs/
│   ├── specs/                          # outputs from brainstorm — human-reviewable
│   ├── plans/                          # outputs from write-plan — implementer-facing
│   └── principles.md                   # optional override/extension
└── sketches/                           # outputs from sketch (gitignored)
```

If a project has no `docs/principles.md`, agents fall back to `~/.claude/principles.md`. **No `.claude/` directory required per project.**

---

## Adapting from Superpowers

Superpowers is MIT licensed (© Jesse Vincent / Prime Radiant). Files substantially derived from Superpowers must:

1. Bear an inline comment header: `# Adapted from obra/superpowers (MIT)`
2. Be listed in the dotfiles repo's `NOTICES.md` (content provided in Implementation reference below)

### High-level mapping

| Superpowers source                                                   | Our destination                                              | Notes                                                                         |
| -------------------------------------------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| `agents/code-reviewer.md`                                            | `agents/code-reviewer.md`                                    | Port directly; adjust severity tags; `model: sonnet` not `inherit`            |
| `skills/subagent-driven-development/implementer-prompt.md`           | `agents/implementer.md` body                                 | Convert to agent format; preserve self-review checklist                       |
| `skills/subagent-driven-development/spec-reviewer-prompt.md`         | `agents/spec-reviewer.md` body                               | Preserve "Do Not Trust the Report" posture; add Calibration                   |
| `skills/subagent-driven-development/code-quality-reviewer-prompt.md` | merged into `agents/code-reviewer.md` and the dispatch logic | The upstream uses code-reviewer agent + SDD-specific checks                   |
| `skills/writing-plans/plan-document-reviewer-prompt.md`              | `agents/plan-reviewer.md`                                    | Pre-execution plan QA gate                                                    |
| `skills/brainstorming/SKILL.md`                                      | `skills/brainstorm/SKILL.md`                                 | Strip framework-enforcement; update paths                                     |
| `skills/writing-plans/SKILL.md`                                      | `skills/write-plan/SKILL.md`                                 | Keep the verbose task template structure verbatim                             |
| `skills/subagent-driven-development/SKILL.md`                        | `skills/execute-plan/SKILL.md`                               | Strip worktree refs; preserve dispatch flow                                   |
| `skills/test-driven-development/SKILL.md`                            | `skills/tdd/SKILL.md`                                        | Port mostly verbatim — this is core discipline content                        |
| `skills/verification-before-completion/SKILL.md`                     | `skills/verify-before-done/SKILL.md`                         | Port mostly verbatim                                                          |
| `skills/receiving-code-review/SKILL.md`                              | `skills/receiving-review/SKILL.md`                           | Port the READ → UNDERSTAND → VERIFY → EVALUATE → RESPOND → IMPLEMENT protocol |

### What to skip entirely

- `skills/using-superpowers/SKILL.md` (meta-skill / "1% Rule")
- `hooks/session-start` (meta-skill injection)
- `skills/using-git-worktrees/SKILL.md`
- `skills/finishing-a-development-branch/` (worktree-specific cleanup; we use a final code review pass instead)
- `skills/requesting-code-review/SKILL.md` (the dispatch-the-reviewer pattern is folded directly into execute-plan)
- `skills/dispatching-parallel-agents/` (we don't run parallel)
- `skills/brainstorming/spec-document-reviewer-prompt.md` (inline self-review of spec — not needed for v1)
- `skills/brainstorming/visual-companion.md` (replaced by our `sketch` skill)
- The deprecated `commands/*.md`

### The "MUST" / "Do NOT" rule: framework vs. work

Superpowers uses imperative language heavily. Some of it is operational discipline that does the skill's actual job — keep it. Some of it is framework-enforcement language designed to compensate for unreliable skill triggering — strip it.

**The test:** does the language enforce the _work_ (TDD, spec review, quality gates) or enforce the _framework_ (which skill to invoke next, when to use the skill system, how to keep the workflow on rails)?

**Strip — framework-enforcement examples:**

- "You MUST use this before any creative work" _(invoke-the-skill pressure)_
- "Do NOT invoke any other skill" _(skill routing)_
- "The terminal state is invoking writing-plans" _(skill routing)_
- "Do NOT invoke frontend-design, mcp-builder, or any other implementation skill" _(skill routing)_
- "ALWAYS use the Skill tool first" _(meta-skill / 1% Rule)_
- "Even a 1% chance a skill might apply means..." _(meta-skill)_
- "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development" _(skill routing)_
- "If a skill exists, use it. Skills evolve. Read current version." _(meta-skill)_

**Keep — work-enforcement examples:**

- "You MUST write the failing test first" _(TDD discipline)_
- "Do NOT proceed until the user approves the design" _(quality gate — spec review is our review gate)_
- "Do NOT use placeholders or TODO markers" _(quality gate)_
- "ALWAYS commit per task" _(process discipline)_
- "You MUST verify the test fails for the right reason before implementing" _(TDD discipline)_
- "Apply YAGNI ruthlessly" _(design discipline)_
- "One question at a time" _(skill behaviour, even if phrased as imperative)_
- "Do Not Trust the Report... You MUST verify everything independently" _(reviewer discipline — central to spec review)_
- "Evidence before claims, always" _(verification discipline)_

When in doubt, lean toward keeping. A skill that prompts itself confidently into doing its job well is what we want; we just don't want skills that prompt the _agent_ to keep using the framework.

Line-by-line porting transformation rules are in the **Implementation reference** appendix at the end of this document.

---

## Phase 1 — Core scaffold

**Goal:** brainstorm → spec → plan → execute pipeline working end-to-end with subagent dispatch, with proper TDD/verification/review-handling discipline.

### `~/.claude/principles.md` (full content — bespoke)

Create with this starting content. The user will iterate over time.

```markdown
# Principles

Non-negotiable defaults for code work in this kit. A project's `docs/principles.md` overrides or extends this file when present.

## Process

- TDD always. Write a failing test before the implementation. Run it. Watch it fail. Then make it pass. The full RED-GREEN-REFACTOR cycle is in the `tdd` skill.
- Evidence before claims, always. No completion claims without fresh verification evidence. The full discipline is in the `verify-before-done` skill.
- Commit per task. Each completed task is a single coherent commit. Don't bundle, don't split.
- No placeholder code. No `TODO` markers, no stubbed functions, no "we'll come back to this." If a task isn't ready, mark it BLOCKED.
- Prefer subagents for heavy work. The main session stays clean by delegating implementation, review, and lookups.
- Subagents receive only the context they need. Don't dump session history into a dispatched prompt.

## Code

- Conventional commits. Use `type: subject` format (`feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`). Subject is plain prose — no marketing language, no hype, no emoji unless explicitly requested. Add a body only when the why isn't obvious from the subject.
- YAGNI — only build what the spec says. "While I'm here" features are out of scope.
- DRY within reason. Three-strikes rule: extract on the third occurrence, not the second.
- Tests describe behaviour, not implementation. A passing test should still pass after a reasonable refactor.

## Communication

- Implementer status reports use exactly: `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, `BLOCKED`.
- Reviewer findings use `BLOCK` / `CONCERN` / `NIT` severity tags.
- When uncertain, say so explicitly rather than guessing.
- When receiving review feedback, follow the `receiving-review` skill: verify before implementing, ask before assuming.
```

### Agent files

#### `~/.claude/agents/architect.md` (full content — bespoke)

```markdown
---
name: architect
description: Use when deep design thinking is needed — surfacing design alternatives, breaking down features, planning architecture.
model: opus
tools: Read, Grep, Glob, Bash(git *)
---

# Architect

You think carefully about design, architecture, and feature breakdown. You're invoked by skills that need deeper reasoning than the main agent should burn tokens on directly.

## Approach

- Read the project's principles file (`docs/principles.md` if present, otherwise `~/.claude/principles.md`) before doing meaningful design work. The principles are non-negotiable constraints.
- When surfacing design alternatives, present 2–3 distinct approaches, not minor variations. Each approach should make a different fundamental tradeoff.
- Apply YAGNI ruthlessly — only design what the spec actually requires.
- When breaking work into tasks, each task is one testable unit. The implementer subagent will work task-by-task with TDD.

## Output

You return well-structured prose. The skill that invoked you handles persistence (writing to `specs/` or `plans/`). Don't write files yourself unless the invoking skill explicitly delegates that.
```

#### `~/.claude/agents/implementer.md` (port + bespoke additions)

**Source:** `skills/subagent-driven-development/implementer-prompt.md` (Superpowers').

Required frontmatter:

```yaml
---
name: implementer
description: Use when implementing a single planned task. Follows TDD strictly. Returns DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED.
model: haiku
tools: Read, Edit, Write, Bash, Grep, Glob
---
```

The body must include these sections, ported from the upstream prompt with worktree references stripped:

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Pre-flight:** instruction to read `docs/principles.md` (or `~/.claude/principles.md`) and the `tdd` and `verify-before-done` skills before starting.

3. **Inputs the implementer expects:**
   - Task description (full text from plan)
   - Pointer to the spec file (for "why" context)
   - Working directory

4. **"Before You Begin" section** — port verbatim:

   > If you have questions about the requirements, approach, dependencies, or anything unclear: **ask them now.** Raise concerns before starting work.
   > While you work: if you encounter something unexpected or unclear, **ask questions**. It's always OK to pause and clarify.

5. **"Your Job" section** — port verbatim:

   > 1. Implement exactly what the task specifies
   > 2. Write tests (following TDD per the `tdd` skill)
   > 3. Verify implementation works (per the `verify-before-done` skill)
   > 4. Commit your work
   > 5. Self-review (see below)
   > 6. Report back

6. **"Code Organization" section** — port verbatim, drop worktree-specific guidance:

   > If a file is growing beyond the plan's intent, report `DONE_WITH_CONCERNS` (don't split files without plan guidance).
   > In existing codebases, follow established patterns — improve code you're touching but don't restructure outside your task.

7. **"When You're in Over Your Head" section** — port verbatim:

   > Report `BLOCKED` or `NEEDS_CONTEXT` rather than producing uncertain work.
   >
   > - `NEEDS_CONTEXT`: The plan or spec is missing information you need.
   > - `BLOCKED`: You can't make progress (environmental issue, missing dependency, contradiction in spec, etc.).

8. **"Before Reporting Back: Self-Review" section** — port verbatim from upstream, this is the most important content in the file:

   ```
   Ask yourself:

   **Completeness:**
   - Did I fully implement everything in the spec?
   - Did I miss any requirements?
   - Are there edge cases I didn't handle?

   **Quality:**
   - Is this my best work?
   - Are names clear and accurate (match what things do, not how they work)?
   - Is the code clean and maintainable?

   **Discipline:**
   - Did I avoid overbuilding (YAGNI)?
   - Did I only build what was requested?
   - Did I follow existing patterns in the codebase?

   **Testing:**
   - Do tests actually verify behavior (not just mock behavior)?
   - Did I follow TDD if required?
   - Are tests comprehensive?

   If you find issues during self-review, fix them now before reporting.
   ```

9. **"Report Format" section** — port verbatim:
   > When done, report:
   >
   > - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
   > - What you implemented (or attempted, if blocked)
   > - What you tested and test results
   > - Files changed
   > - Self-review findings (if any)
   > - Any concerns
   >
   > Use `DONE_WITH_CONCERNS` if you completed the work but have doubts about correctness.

#### `~/.claude/agents/spec-reviewer.md` (port + bespoke additions)

**Source:** `skills/subagent-driven-development/spec-reviewer-prompt.md` (Superpowers').

Required frontmatter:

```yaml
---
name: spec-reviewer
description: Use when reviewing whether a code change matches the relevant section of an approved spec. Returns findings tagged BLOCK | CONCERN | NIT.
model: sonnet
tools: Read, Bash(git diff:*), Bash(git log:*), Bash(git show:*), Grep, Glob
---
```

Body content (port verbatim where indicated):

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Inputs the spec-reviewer expects** (provided by the dispatcher at runtime):
   - `BASE_SHA` and `HEAD_SHA` (git refs bracketing the change to review)
   - Path to the relevant spec file
   - The implementer's report (what they claim they built)

3. **"Do Not Trust the Report" section** — port verbatim, this is the central posture of the spec reviewer:

   > The implementer finished suspiciously quickly. Their report may be incomplete, inaccurate, or optimistic. You MUST verify everything independently.
   >
   > **DO NOT:**
   >
   > - Take their word for what they implemented
   > - Trust their claims about completeness
   > - Accept their interpretation of requirements
   >
   > **DO:**
   >
   > - Read the actual code they wrote (run `git diff $BASE_SHA $HEAD_SHA`)
   > - Compare actual implementation to requirements line by line
   > - Check for missing pieces they claimed to implement
   > - Look for extra features they didn't mention

4. **"Your Job" section** — port verbatim:

   > Read the implementation code and verify:
   >
   > **Missing requirements:**
   >
   > - Did they implement everything that was requested?
   > - Are there requirements they skipped or missed?
   > - Did they claim something works but didn't actually implement it?
   >
   > **Extra/unneeded work:**
   >
   > - Did they build things that weren't requested?
   > - Did they over-engineer or add unnecessary features?
   > - Did they add "nice to haves" that weren't in spec?
   >
   > **Misunderstandings:**
   >
   > - Did they interpret requirements differently than intended?
   > - Did they solve the wrong problem?
   > - Did they implement the right feature but wrong way?

5. **Calibration section** — bespoke (matches upstream's recent change):

   > **Only flag issues that would cause real problems during implementation.** An implementer building the wrong thing or producing code that doesn't match the spec is an issue. Minor wording, stylistic preferences, and "nice to have" suggestions are not. Approve unless there are serious gaps — missing requirements, contradictory implementation, placeholder content, or behaviour that diverges materially from the spec.

6. **Output Format section** — bespoke:
   > Return findings as a structured list. For each finding:
   >
   > - Tag with `[BLOCK]`, `[CONCERN]`, or `[NIT]`
   > - Reference the file and line
   > - State the issue concisely
   > - For BLOCK only: state what change would resolve it
   >
   > Severity meanings:
   >
   > - `BLOCK`: implementation does not match the spec; must be fixed before continuing
   > - `CONCERN`: matches spec but with reservations worth noting; doesn't block
   > - `NIT`: minor preference; informational only
   >
   > If there are no findings, return: "✅ Spec compliant — implementation matches requirements."

#### `~/.claude/agents/code-reviewer.md` (port from actual upstream)

**Source:** `agents/code-reviewer.md` (Superpowers'). The actual upstream is 48 lines with `model: inherit` and a six-section structure.

Required frontmatter:

```yaml
---
name: code-reviewer
description: Use when a major project step has been completed and needs to be reviewed against the original plan and coding standards.
model: sonnet
tools: Read, Bash(git diff:*), Bash(git log:*), Bash(git show:*), Grep, Glob
---
```

Note: upstream uses `model: inherit`. We override to `sonnet` so the reviewer has a consistent capability level regardless of who dispatched it.

Body content — port the upstream structure (six sections), with these adaptations:

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Opening paragraph** — port verbatim:

   > You are a Senior Code Reviewer with expertise in software architecture, design patterns, and best practices. Your role is to review completed project steps against original plans and ensure code quality standards are met.

3. **Inputs the code-reviewer expects:**
   - `BASE_SHA` and `HEAD_SHA`
   - Path to the relevant plan and spec
   - Description of what the implementer claims they built

4. **The six review sections** — port verbatim from upstream:
   - Plan Alignment Analysis
   - Code Quality Assessment
   - Architecture and Design Review
   - Documentation and Standards
   - Issue Identification and Recommendations
   - Communication Protocol

5. **Severity tag mapping:** the upstream uses **Critical / Important / Suggestions**. Replace globally with our scheme:
   - `Critical (must fix)` → `[BLOCK]`
   - `Important (should fix)` → `[CONCERN]`
   - `Suggestions (nice to have)` → `[NIT]`

6. **Calibration section** — bespoke addition (mirrors spec-reviewer):

   > **Only flag issues that would cause real problems.** Minor wording, stylistic preferences, and formatting quibbles should not block. Approve unless there are real correctness, security, or maintainability issues.

7. **Additional checks for code-quality-reviewer role** — bespoke addition (from upstream `code-quality-reviewer-prompt.md`):

   > Beyond the six standard sections, also check:
   >
   > - Did this implementation create new files that are already large, or significantly grow existing files?
   > - Are there logical decomposition opportunities that should have been taken?
   > - Are there testing anti-patterns (mocking the system under test, tests that mirror implementation rather than verify behaviour)?

8. **Output Format section** — bespoke:
   > Return findings as a structured list. For each finding:
   >
   > - Tag with `[BLOCK]`, `[CONCERN]`, or `[NIT]`
   > - Reference the file and line
   > - State the issue concisely
   > - For BLOCK only: state what change would resolve it
   >
   > If there are no findings, return: "✅ No issues found."

#### `~/.claude/agents/plan-reviewer.md` (port from upstream)

**Source:** `skills/writing-plans/plan-document-reviewer-prompt.md` (Superpowers').

Required frontmatter:

```yaml
---
name: plan-reviewer
description: Use when verifying a written plan is complete, matches its spec, and has actionable task decomposition.
model: sonnet
tools: Read, Grep, Glob
---
```

Body content (port verbatim where indicated):

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Inputs the plan-reviewer expects** (from dispatcher):
   - Path to the plan file
   - Path to the spec for reference

3. **"What to Check" section** — port verbatim from upstream's table:
   | Category | What to Look For |
   |---|---|
   | Completeness | TODOs, placeholders, incomplete tasks, missing steps |
   | Spec Alignment | Plan covers spec requirements, no major scope creep |
   | Task Decomposition | Tasks have clear boundaries, steps are actionable |
   | Buildability | Could an engineer follow this plan without getting stuck? |

4. **Calibration section** — port verbatim:

   > **Only flag issues that would cause real problems during implementation.** An implementer building the wrong thing or getting stuck is an issue. Minor wording, stylistic preferences, and "nice to have" suggestions are not. Approve unless there are serious gaps — missing requirements from the spec, contradictory steps, placeholder content, or tasks so vague they can't be acted on.

5. **Output Format section:**

   ```
   ## Plan Review

   **Status:** Approved | Issues Found

   **Issues (if any):**
   - [Task X, Step Y]: [specific issue] — [why it matters for the implementer]
   ```

### Discipline skills

#### `~/.claude/skills/tdd/SKILL.md` (port verbatim where possible)

**Source:** `skills/test-driven-development/SKILL.md` (Superpowers'). Major file (~372 lines) — port substantially verbatim.

Required frontmatter:

```yaml
---
name: tdd
description: Use when implementing any feature or bugfix, before writing implementation code.
---
```

Body content — port the upstream skill's full content, with these adaptations:

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Strip framework-enforcement language only:**
   - References to `superpowers:` skill prefix in cross-references — replace with bare skill names (e.g., `verify-before-done`)
   - Any "REQUIRED BACKGROUND: superpowers:..." headers — keep the cross-reference, drop the `superpowers:` prefix

3. **Keep verbatim:**
   - The Iron Law: "If you didn't watch the test fail, you don't know if it tests the right thing"
   - The RED-GREEN-REFACTOR cycle and Graphviz diagram (or substitute Mermaid if Graphviz doesn't render in this environment)
   - The verification checklist
   - The rationalizations table ("I'll test after," "deleting is wasteful," "manual tested")
   - The "Production code → test exists and failed first. Otherwise → not TDD" rule
   - The bug-fix protocol ("Bug found? Write failing test reproducing it. Follow TDD cycle.")

4. **Path adjustment:** if the upstream references `@testing-anti-patterns.md` (in the same skill folder), copy that file across too: `~/.claude/skills/tdd/testing-anti-patterns.md`. If it can't be fetched, leave a placeholder note and the agent can populate it later from the upstream URL.

#### `~/.claude/skills/verify-before-done/SKILL.md` (port verbatim)

**Source:** `skills/verification-before-completion/SKILL.md` (Superpowers').

Required frontmatter:

```yaml
---
name: verify-before-done
description: Use before claiming work is complete, before reporting test passes, fixes, or success. Requires running the verification command and reading the output before any claim.
---
```

Body content — port the upstream skill verbatim, with these adaptations:

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Strip framework-enforcement language** (any meta-skill or `superpowers:` references).

3. **Keep verbatim:**
   - The core principle: "Evidence before claims, always"
   - "NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE"
   - "Violating the letter of this rule is violating the spirit of this rule"
   - The patterns: "Re-read plan → Create checklist → Verify each → Report gaps or completion" vs "Tests pass, phase complete"; "Agent reports success → Check VCS diff → Verify changes → Report actual state" vs "Trust agent report"
   - "Honesty is a core value. If you lie, you'll be replaced."
   - "No shortcuts for verification. Run the command. Read the output. THEN claim the result."

#### `~/.claude/skills/receiving-review/SKILL.md` (port from upstream)

**Source:** `skills/receiving-code-review/SKILL.md` (Superpowers'). Used by the implementer when reviewer findings come back.

Required frontmatter:

```yaml
---
name: receiving-review
description: Use when receiving code review feedback, before implementing reviewer suggestions, especially if feedback seems unclear or technically questionable.
---
```

Body content — port verbatim where indicated:

1. **Header:** `# Adapted from obra/superpowers (MIT)`

2. **Core principle** — port verbatim:

   > Verify before implementing. Ask before assuming. Technical correctness over social comfort.

3. **The protocol** — port verbatim:

   > WHEN receiving code review feedback:
   >
   > 1. **READ:** Complete feedback without reacting
   > 2. **UNDERSTAND:** Restate requirement in own words (or ask)
   > 3. **VERIFY:** Check against codebase reality
   > 4. **EVALUATE:** Technically sound for THIS codebase?
   > 5. **RESPOND:** Technical acknowledgment or reasoned pushback
   > 6. **IMPLEMENT:** One item at a time, test each

4. **"If any item is unclear" rule** — port verbatim:

   > IF any item is unclear: **STOP** — do not implement anything yet. ASK for clarification on unclear items. WHY: items may be related; partial understanding = wrong implementation.

5. **"Before implementing" checklist** — port verbatim:

   > 1. Check: Technically correct for THIS codebase?
   > 2. Check: Breaks existing functionality?
   > 3. Check: Reason for current implementation?
   > 4. Check: Works on all platforms/versions?
   > 5. Check: Does reviewer understand full context?
   >
   > IF suggestion seems wrong: push back with technical reasoning.
   > IF can't easily verify: say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

6. **Closing principle** — port verbatim:
   > External feedback = suggestions to evaluate, not orders to follow. Verify. Question. Then implement. No performative agreement.

### Workflow skills

#### `~/.claude/skills/brainstorm/SKILL.md` (ported)

See **Implementation reference > Ports > Skill files > brainstorm**.

#### `~/.claude/skills/write-plan/SKILL.md` (ported)

See **Implementation reference > Ports > Skill files > write-plan**.

#### `~/.claude/skills/execute-plan/SKILL.md` (ported)

See **Implementation reference > Ports > Skill files > execute-plan**.

### Validation

Move files into place via Chezmoi, start a fresh Claude Code session in a real project, run a small feature through the full pipeline. Check:

- Brainstorm fires on natural phrases or `/brainstorm`, produces a spec the user wants to review
- Spec is editable; the next phase respects edits
- Plan has TDD-baked tasks following the canonical task template (see write-plan port instructions); plan-reviewer runs after generation
- Plan has one TDD-baked task per testable unit, detailed enough that the implementer rarely returns `NEEDS_CONTEXT`
- Implementer self-review is happening (visible in implementer's status reports)
- Implementer is actually running tests (per the tdd skill) and verifying output (per verify-before-done)
- Spec-reviewer surfaces real BLOCKs, not just NITs (Calibration is working)
- Spec-reviewer catches if the implementer made false claims (the "Do Not Trust the Report" posture is doing its job)
- When BLOCKs come back, implementer applies `receiving-review` discipline (verifies before re-implementing)
- Plan-file checkboxes get ticked as tasks complete
- A simulated session-mid-crash followed by re-running `/execute-plan` correctly resumes from unchecked tasks

---

## Phase 2 — HTML preview for design variants

**Goal:** reproduce Superpowers' Visual Companion in ~50 lines.

### `~/.claude/settings.json` (merge with existing)

The user already has a global `~/.claude/settings.json` containing a prettier `PostToolUse` hook (per the existing `check-project-setup` skill). **Do not overwrite** — merge the new entry into the existing `hooks` object. Only adds a `SessionEnd` hook for sketch-server cleanup:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs pnpm dlx prettier --write --ignore-unknown || true"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$HOME\"/.claude/hooks/session-end-cleanup.sh"
          }
        ]
      }
    ]
  }
}
```

The `\"$HOME\"` escaped-quotes pattern matches the convention shown in the official hooks docs and handles paths with spaces. Preserve any existing top-level keys outside `hooks` if present.

### `~/.claude/skills/sketch/SKILL.md` (full content — bespoke)

```markdown
---
name: sketch
description: Use when the user asks to mock something up, see design variants, or compare visual options.
allowed-tools: Read, Write, Bash(mkdir:*), Bash(pnpm dlx serve:*), Bash(pnpm dlx serve), Bash(echo:*)
---

# sketch

Generate visual design variants the user can compare in a browser.

## Output structure

Each sketch session writes to `<project>/sketches/<YYYY-MM-DD>-<topic>/`:

\`\`\`
sketches/2026-04-25-checkout-form/
├── index.html # frame: chrome, nav, base styles, fragment loader
├── variant-1.html # body fragment for variant 1 (no DOCTYPE/head/body)
├── variant-2.html # body fragment for variant 2
└── variant-3.html # body fragment for variant 3
\`\`\`

The frame contains the chrome (DOCTYPE, head, base reset, nav buttons, fragment loader); variants contain only the body content of the design itself, plus an optional `<style>` block for variant-specific CSS. This keeps each variant focused on its actual design choice rather than HTML boilerplate, and keeps the chrome consistent across variants.

## Process

1. Confirm the design subject. Ask how many variants (default 3, max 5).
2. Plan the distinct design choices each variant explores. Choices should be different fundamental directions — different layouts, hierarchies, aesthetic approaches — not minor tweaks.
3. Write `index.html` using the template below. Update the button list to match the actual number of variants and substitute the variant labels (e.g. `1: minimalist single-column`).
4. For each variant, write `variant-N.html` containing only body content. May start with a `<style>` block for variant-specific styles. Must NOT include `<html>`, `<head>`, `<body>`, or DOCTYPE.
5. Start `pnpm dlx serve` in the sketch directory in the background. Capture the PID and write to `<project>/.claude/.runtime/sketch-server.pid` (creating the runtime directory if needed).
6. Tell the user the URL (default port 3000; capture the actual port from serve's output if it differs) and a one-line description of what each variant explores.

## Frame template

Save this verbatim as `index.html`, updating the button list and labels to match the actual variants:

\`\`\`html

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sketch</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; }
    body { margin: 0; font-family: system-ui, -apple-system, sans-serif; line-height: 1.5; color: #111; }
    .frame-nav {
      position: sticky; top: 0; z-index: 1000;
      background: #f5f5f5; border-bottom: 1px solid #ddd;
      padding: 0.5rem 1rem;
      display: flex; gap: 0.5rem; align-items: center;
    }
    .frame-nav .label { color: #666; font-size: 0.875rem; margin-right: 0.5rem; }
    .frame-nav button {
      background: white; border: 1px solid #ccc;
      padding: 0.4rem 0.8rem; border-radius: 4px;
      cursor: pointer; font: inherit;
    }
    .frame-nav button[aria-current="true"] { background: #111; color: white; border-color: #111; }
    main { padding: 0; }
  </style>
</head>
<body>
  <nav class="frame-nav">
    <span class="label">Variants:</span>
    <button data-variant="variant-1">1: <!-- description --></button>
    <button data-variant="variant-2">2: <!-- description --></button>
    <button data-variant="variant-3">3: <!-- description --></button>
  </nav>
  <main id="content"></main>
  <script>
    const buttons = document.querySelectorAll('.frame-nav button');
    const content = document.getElementById('content');

    async function load(variant) {
      const res = await fetch(variant + '.html');
      content.innerHTML = await res.text();
      // innerHTML doesn't execute <script> tags; re-create them so it does
      content.querySelectorAll('script').forEach(old => {
        const fresh = document.createElement('script');
        if (old.src) fresh.src = old.src; else fresh.textContent = old.textContent;
        old.replaceWith(fresh);
      });
      buttons.forEach(b => b.setAttribute('aria-current', b.dataset.variant === variant ? 'true' : 'false'));
      location.hash = variant;
    }
    buttons.forEach(b => b.addEventListener('click', () => load(b.dataset.variant)));
    load((location.hash || '#variant-1').slice(1));

  </script>
</body>
</html>
\`\`\`

## Cleanup

The `~/.claude/hooks/session-end-cleanup.sh` hook reads the PID file at session end and kills the server. No manual cleanup needed.

## Constraints

- Variant fragments are body-only — no DOCTYPE, `<html>`, `<head>`, `<body>` tags.
- Each fragment may include a `<style>` block at the top for variant-specific CSS. The frame's base styles cover reset and typography; fragments add what's specific to their design.
- No JavaScript in fragments unless a variant specifically demonstrates an interaction. The frame's loader correctly re-executes inline scripts after fragment swap.
- Realistic placeholder content based on the project context — not "Lorem ipsum."
- The `sketches/` directory should be in the project's `.gitignore`. If it isn't, suggest adding it but don't add it yourself.
```

### `~/.claude/hooks/session-end-cleanup.sh` (full content — bespoke)

```bash
#!/usr/bin/env bash
# SessionEnd hook: kills any background server started by the sketch skill.
# Reads the PID from <project>/.claude/.runtime/sketch-server.pid if present.
set -u

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
pid_file="${project_dir}/.claude/.runtime/sketch-server.pid"

[ -f "$pid_file" ] || exit 0

pid=$(cat "$pid_file" 2>/dev/null)
if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
  kill "$pid" 2>/dev/null || true
  sleep 0.5
  kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
fi

rm -f "$pid_file"
exit 0
```

`chmod +x` after creation.

---

## Phase 3 — Use the kit, evolve it

**Goal:** real usage on real projects. Tune prompts based on what you see.

Things to evolve:

- **`~/.claude/principles.md`** — add counter-principles when the agent does something annoying. Promote project-specific principles when they apply across projects.
- **Brainstorm prompt** — refine question style, defaults, when it should push back
- **Plan format** — if implementer often returns `NEEDS_CONTEXT`, plans need more detail; if too much ceremony, trim back. Empirical.
- **Implementer status semantics** — sharpen `DONE_WITH_CONCERNS` vs `NEEDS_CONTEXT` based on real cases
- **Reviewer Calibration** — tune how aggressive BLOCK vs CONCERN classification should be
- **TDD skill** — pull in Superpowers updates if upstream content changes meaningfully

Use the kit for 2–4 weeks. Continue iterating thereafter as real usage exposes rough edges.

---

## Implementation reference

This appendix contains the porting URLs, frontmatter, and transformation rules for the workflow skills derived from Superpowers, plus the `NOTICES.md` content. (Agent ports and discipline-skill ports have full content above in Phase 1.)

### Source URLs

All Superpowers files are at https://github.com/obra/superpowers (main branch). Raw content URLs:

| Source                                                               | Raw URL                                                                                                                    |
| -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `LICENSE`                                                            | https://raw.githubusercontent.com/obra/superpowers/main/LICENSE                                                            |
| `agents/code-reviewer.md`                                            | https://raw.githubusercontent.com/obra/superpowers/main/agents/code-reviewer.md                                            |
| `skills/subagent-driven-development/SKILL.md`                        | https://raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/SKILL.md                        |
| `skills/subagent-driven-development/implementer-prompt.md`           | https://raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/implementer-prompt.md           |
| `skills/subagent-driven-development/spec-reviewer-prompt.md`         | https://raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/spec-reviewer-prompt.md         |
| `skills/subagent-driven-development/code-quality-reviewer-prompt.md` | https://raw.githubusercontent.com/obra/superpowers/main/skills/subagent-driven-development/code-quality-reviewer-prompt.md |
| `skills/brainstorming/SKILL.md`                                      | https://raw.githubusercontent.com/obra/superpowers/main/skills/brainstorming/SKILL.md                                      |
| `skills/writing-plans/SKILL.md`                                      | https://raw.githubusercontent.com/obra/superpowers/main/skills/writing-plans/SKILL.md                                      |
| `skills/writing-plans/plan-document-reviewer-prompt.md`              | https://raw.githubusercontent.com/obra/superpowers/main/skills/writing-plans/plan-document-reviewer-prompt.md              |
| `skills/test-driven-development/SKILL.md`                            | https://raw.githubusercontent.com/obra/superpowers/main/skills/test-driven-development/SKILL.md                            |
| `skills/test-driven-development/testing-anti-patterns.md`            | https://raw.githubusercontent.com/obra/superpowers/main/skills/test-driven-development/testing-anti-patterns.md            |
| `skills/verification-before-completion/SKILL.md`                     | https://raw.githubusercontent.com/obra/superpowers/main/skills/verification-before-completion/SKILL.md                     |
| `skills/receiving-code-review/SKILL.md`                              | https://raw.githubusercontent.com/obra/superpowers/main/skills/receiving-code-review/SKILL.md                              |

If a URL 404s, the upstream file may have moved. Browse https://github.com/obra/superpowers/tree/main and find the equivalent file by name.

### Known upstream path inconsistency

The brainstorming skill currently saves design docs to `docs/plans/...-design.md`, but the writing-plans skill historically saves plans to `docs/superpowers/plans/...md`. This is an inconsistency in upstream itself. We override both: specs go to `docs/specs/` and plans to `docs/plans/`.

### NOTICES.md (place in dotfiles repo root or ~/.claude/)

Fetch the actual MIT license text from `https://raw.githubusercontent.com/obra/superpowers/main/LICENSE` and use it verbatim. Wrap in this structure:

```markdown
# Notices

## Superpowers (MIT)

Portions of this configuration are adapted from the [Superpowers](https://github.com/obra/superpowers) project by Jesse Vincent / Prime Radiant.

The following files are substantially derived from Superpowers and bear inline `# Adapted from obra/superpowers (MIT)` headers:

- `~/.claude/agents/code-reviewer.md`
- `~/.claude/agents/spec-reviewer.md`
- `~/.claude/agents/implementer.md`
- `~/.claude/agents/plan-reviewer.md`
- `~/.claude/skills/brainstorm/SKILL.md`
- `~/.claude/skills/write-plan/SKILL.md`
- `~/.claude/skills/execute-plan/SKILL.md`
- `~/.claude/skills/tdd/SKILL.md`
- `~/.claude/skills/verify-before-done/SKILL.md`
- `~/.claude/skills/receiving-review/SKILL.md`

### Original license

<!-- Verbatim contents of https://raw.githubusercontent.com/obra/superpowers/main/LICENSE -->
```

### Ports > Skill files

Skills have YAML frontmatter (`name`, `description`, optional `disable-model-invocation`, optional `allowed-tools`) and a markdown body.

For all three workflow ports below: apply the framework-vs-work language rule from the "Adapting from Superpowers" section. Strip framework-enforcement language; keep work-enforcement language.

#### `~/.claude/skills/brainstorm/SKILL.md`

**Source:** `skills/brainstorming/SKILL.md` (Superpowers'). The current upstream version is ~96 lines with this structure: `# Brainstorming Ideas Into Designs` heading, then sections `## Overview`, `## Anti-Pattern: "This Is Too Simple To Need A Design"`, `## Checklist` (6 items), `## Process Flow` (digraph), `## The Process`, `## After the Design`, `## Key Principles`. The skill currently saves design docs to `docs/plans/YYYY-MM-DD-<topic>-design.md`.

**Required frontmatter (replace upstream's table-style frontmatter with this YAML):**

```yaml
---
name: brainstorm
description: Use when refining a rough feature idea into a written spec, designing a new feature, or thinking through what to build before writing code.
allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*), Bash(mkdir:*), Grep, Glob, Task
---
```

Note the description follows the writing-skills rule: triggering conditions only, no workflow summary.

**Body transformations:**

_Strip (framework-enforcement):_

1. The "You MUST use this before any creative work" framing in the description (already replaced via the new frontmatter above)
2. "Do NOT invoke any other skill. writing-plans is the next step." — delete entirely
3. "The terminal state is invoking writing-plans" — delete entirely
4. "Do NOT invoke frontend-design, mcp-builder, or any other implementation skill. The ONLY skill you invoke after brainstorming is writing-plans" — delete entirely
5. The "Invoke writing-plans skill" terminal node in the digraph and the edge into it. Replace with a simple end state ("Ready for /write-plan") or a note pointing the user to `/write-plan`.
6. The "## After the Design > Implementation" subsection's "Invoke the writing-plans skill to create a detailed implementation plan" line — replace with "Suggest /write-plan when the user is ready, after reviewing the spec."
7. References to `elements-of-style:writing-clearly-and-concisely skill` — that's a Superpowers-specific dependency we don't have.

_Keep (work-enforcement):_

1. "Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it" — this enforces the spec-as-review-gate, which is core to our design. **Keep.**
2. "Every project goes through this process. A todo list, a single-function utility, a config change — all of them" — keep the anti-pattern section's discipline.
3. "you MUST present it and get approval" in the anti-pattern section — keep; this is review-gate enforcement.
4. "You MUST create a task for each of these items" — keep; this is process discipline.
5. All the one-question-at-a-time, multiple-choice-preferred, YAGNI-ruthlessly content — keep verbatim.
6. The 2–3 approaches, design sections, present-and-get-approval pattern — keep.

_Path substitutions:_

- `docs/plans/YYYY-MM-DD-<topic>-design.md` → `docs/specs/<YYYY-MM-DD>-<topic>.md`.

_Checklist update:_

- Step 6 currently reads: "Transition to implementation — invoke writing-plans skill to create implementation plan"
- Replace with: "Suggest the user reviews and edits the spec, then runs `/write-plan` or says 'plan it' when ready"

#### `~/.claude/skills/write-plan/SKILL.md`

**Source:** `skills/writing-plans/SKILL.md` (Superpowers').

**Required frontmatter:**

```yaml
---
name: write-plan
description: Use when generating a detailed implementation plan from an approved spec, before execution.
allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*), Bash(mkdir:*), Grep, Glob, Task
---
```

Description follows the writing-skills rule.

**Body transformations:**

_Strip (framework-enforcement):_

1. The "REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans" header in the generated plan template — replace with a simple comment or remove.
2. References to `using-git-worktrees` — including "Context: This should be run in a dedicated worktree".
3. "Invoke subagent-driven-development" / "Invoke executing-plans" instructions — replace with "Suggest `/execute-plan` when the user is ready."
4. Any `superpowers:` skill prefixes in cross-references.

_Keep (work-enforcement):_

1. The verbose detail level — plan template, per-task breakdown structure, exact file paths, code-level guidance. **This is what makes Haiku viable as implementer.** Do not trim.
2. The TDD checkbox structure per task: failing test → run → verify red → implement → run → verify green → commit.
3. Any imperative language about _what each task must contain_ — that's work-enforcement.
4. The "design units with clear boundaries", "one clear responsibility per file" guidance.

_Path substitutions:_

- Whatever upstream uses for plan output → `docs/plans/<YYYY-MM-DD>-<feature>.md`
- Spec input path → `docs/specs/<YYYY-MM-DD>-<topic>.md`

_Canonical task template — preserve in the generated plan format:_

The upstream uses a specific structure that's the most important part of the plan format. Each task in a generated plan must follow this template (port verbatim, adjust to project's actual language):

````
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**
  ```python
  def test_specific_behavior():
      result = function(input)
      assert result == expected
````

- [ ] **Step 2: Run test to verify it fails**
      Run: `pytest tests/path/test.py::test_name -v`
      Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

  ```python
  def function(input):
      return expected
  ```

- [ ] **Step 4: Run test to verify it passes**
      Run: `pytest tests/path/test.py::test_name -v`
      Expected: PASS

- [ ] **Step 5: Commit**
  ```bash
  git add tests/path/test.py src/path/file.py
  git commit -m "feat: add specific feature"
  ```

```

The implementer subagent reads this template directly and executes it. Every step must contain the actual content the engineer needs — file paths, code blocks, exact test commands, expected outputs. The plan is implementer-facing, not human-facing; verbosity is a feature.

*Plan header — required:*
```

# Plan: <feature name>

Spec: docs/specs/<YYYY-MM-DD>-<topic>.md

## Tasks

````
This lets `execute-plan` find the spec.

*Plan-review step — bespoke addition:*
After generating the plan, the skill should dispatch `@plan-reviewer` with the plan path and the spec path. If plan-reviewer returns issues, address them before saving the final plan and showing it to the user. This is a quality gate before the user even sees the plan.

*Dispatching:*
The skill should dispatch the `architect` agent for the actual plan generation (since this is heavy thinking work).

#### `~/.claude/skills/execute-plan/SKILL.md`

**Source:** `skills/subagent-driven-development/SKILL.md` (Superpowers').

**Required frontmatter:**
```yaml
---
name: execute-plan
description: Use when executing implementation plans with independent tasks in the current session. Explicit invocation only.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash(git rev-parse:*), Bash(git log:*), TodoWrite, Task
---
````

The description follows the writing-skills rule — triggering conditions only, no workflow summary. The bad version (avoid): "...dispatches implementer, spec-reviewer, and code-reviewer subagents" (this summarises the workflow and the agent skips reading the body).

(`Edit` is in `allowed-tools` because the skill ticks plan-file checkboxes as tasks complete.)

**Body transformations:**

_Strip (framework-enforcement):_

1. References to `using-git-worktrees` — we don't use worktrees.
2. References to `finishing-a-development-branch` — we use a simpler final review pass instead.
3. The "1% Rule" / meta-skill references.
4. Any "always invoke X skill" routing language.
5. `superpowers:` skill prefixes — strip.

_Keep (work-enforcement):_

1. The DONE/DONE_WITH_CONCERNS/NEEDS_CONTEXT/BLOCKED status protocol enforcement.
2. The implement → spec-review → code-review per-task loop discipline.
3. Imperative language about _not_ skipping reviews, _not_ batching tasks, _not_ moving on with red tests — these are quality gates we want.
4. The dispatch-prompt patterns Superpowers uses for each subagent — they're well-tuned. Just substitute paths and remove worktree references.
5. The model-selection guidance: "cheap models (e.g. Haiku) for mechanical 1-2 file tasks; standard models for multi-file integration; capable models for architecture and review."
6. The context isolation principle — "subagents receive only the context they need."

_Per-task loop:_

The skill should:

- Read the plan file (find it from the user's invocation, or look for the most recent file in `docs/plans/`).
- Read the spec referenced in the plan's header.
- Build a TodoWrite list from unchecked checkboxes in the plan.
- For each unchecked task:
  1. Capture `BASE_SHA = $(git rev-parse HEAD)`
  2. Dispatch `@implementer` via the Task tool with: the task text from the plan (full text, not a file reference — see context-isolation principle), the path to the spec, the path to principles. Wait for status: DONE / DONE_WITH_CONCERNS / NEEDS_CONTEXT / BLOCKED.
  3. Branch on status:
     - `DONE` → continue to review
     - `DONE_WITH_CONCERNS` → read the concerns; if they're about correctness or scope, address them before review; if they're observations (e.g. "this file is getting large"), note and proceed
     - `NEEDS_CONTEXT` → provide the missing context, re-dispatch
     - `BLOCKED` → assess: context problem (provide more, re-dispatch with same model); reasoning problem (re-dispatch with more capable model); too large (break into smaller pieces); plan wrong (escalate to user)
  4. Capture `HEAD_SHA = $(git rev-parse HEAD)`
  5. Dispatch `@spec-reviewer` with `BASE_SHA`, `HEAD_SHA`, the spec path, and the implementer's report. Receive findings.
  6. Branch on severity (max 3 review iterations per task):
     - Any `BLOCK` → re-dispatch `@implementer` with the findings and instruction to apply the `receiving-review` skill (verify before implementing); after re-implementation, re-run spec-review
     - Any `CONCERN` → log and continue
     - Only `NIT` or no findings → continue
  7. Dispatch `@code-reviewer` with `BASE_SHA`, `HEAD_SHA`, the plan path. Same severity branching as spec-reviewer.
  8. If still BLOCKed after 3 iterations → surface to user, ask how to proceed
  9. Tick the corresponding checkbox in the plan file (use Edit tool to change `- [ ]` to `- [x]`).
  10. Mark task complete in TodoWrite. Continue to next.
- After all tasks: dispatch `@code-reviewer` once over the entire diff (`BASE_SHA` = the SHA before the first task; `HEAD_SHA` = current HEAD).

_Resume from interruption:_

If the skill is invoked when the plan already has some checked items, only iterate over unchecked ones. Don't redo completed work.

### Verification step (recommended after porting)

After all ports are done, do a final pass:

1. Read each ported file and grep for: `worktree`, `1% Rule`, `using-superpowers`, `superpowers:`, `finishing-a-development-branch`. Any hits indicate incomplete adaptation.
2. Read each file and grep for `docs/superpowers/`, `docs/plans/.*-design`. Any hits indicate stale paths.
3. Verify each file's frontmatter is valid YAML and contains the required fields above.
4. Verify the inline `# Adapted from obra/superpowers (MIT)` header is present in each ported file.
5. Verify each skill description follows the triggering-conditions-only rule (no workflow summaries — see the writing-skills section above for the test).
6. Read each file as a whole and judge: does any remaining "MUST" / "Do NOT" language enforce the _work_ (TDD, quality gates, process discipline) or the _framework_ (skill routing, meta-skill behaviour)? Strip framework-enforcement language only. When in doubt, keep.
7. Verify `agents/implementer.md` includes the four-category self-review checklist (Completeness / Quality / Discipline / Testing) verbatim from upstream.
8. Verify `agents/spec-reviewer.md` includes the "Do Not Trust the Report" posture verbatim from upstream.
9. Verify the canonical task template structure is in `skills/write-plan/SKILL.md`.

---

## Build order

1. `~/.claude/principles.md` (full content above — paste and adjust)
2. `NOTICES.md` in dotfiles repo (fetch LICENSE from upstream, wrap per template above)
3. `~/.claude/skills/tdd/SKILL.md` (port verbatim from upstream; ~372 lines)
4. `~/.claude/skills/tdd/testing-anti-patterns.md` (port verbatim from upstream)
5. `~/.claude/skills/verify-before-done/SKILL.md` (port verbatim from upstream)
6. `~/.claude/skills/receiving-review/SKILL.md` (port from upstream `receiving-code-review`)
7. `~/.claude/agents/code-reviewer.md` (port from upstream; six-section structure; severity tag swap)
8. `~/.claude/agents/spec-reviewer.md` (port; preserve "Do Not Trust the Report" verbatim; add Calibration)
9. `~/.claude/agents/implementer.md` (port; preserve self-review checklist verbatim)
10. `~/.claude/agents/plan-reviewer.md` (port from upstream `plan-document-reviewer-prompt.md`)
11. `~/.claude/agents/architect.md` (full content above)
12. `~/.claude/skills/brainstorm/SKILL.md` (port; see Implementation reference)
13. `~/.claude/skills/write-plan/SKILL.md` (port; preserve canonical task template; add plan-review dispatch)
14. `~/.claude/skills/execute-plan/SKILL.md` (port; per-task dispatch loop with `receiving-review` for BLOCKs; `disable-model-invocation: true`)
15. **Symlink into `~/.claude/` via dotfiles. Validate Phase 1 with a real feature end-to-end.**
16. `~/.claude/skills/sketch/SKILL.md` (full content above)
17. `~/.claude/hooks/session-end-cleanup.sh` (full content above; chmod +x)
18. Add `SessionEnd` entry to `~/.claude/settings.json` (preserve existing prettier hook)
19. **Pause.** Use the kit for 2–4 weeks. Iterate on prompts and principles based on real use.

---

## Success criteria

- The user stops reaching for Superpowers commands out of habit
- Brainstorm-to-spec consistently produces specs needing only light edits
- Specs are reviewable in detail; plans are spot-checkable
- The implementer rarely returns `NEEDS_CONTEXT`
- Implementer self-review is consistently catching issues before the spec-reviewer does
- Spec-reviewer surfaces real BLOCKs (calibration is working — not bouncing back on NITs)
- Spec-reviewer catches false claims (the "Do Not Trust the Report" posture is doing its job — caught at least one fabricated test result or skipped requirement during validation)
- New projects work immediately without per-project setup
- The whole `~/.claude/` config (excluding pre-existing skills) is < 2500 lines and every file is understood
- Skill invocation feels natural — neither over-eager auto-firing nor frustrating to invoke

If a sixth workflow skill or seventh agent gets added, pause and ask whether it's pulling weight or adding ceremony.
