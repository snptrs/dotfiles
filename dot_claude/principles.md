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
