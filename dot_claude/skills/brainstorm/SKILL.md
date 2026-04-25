---
name: brainstorm
description: Use when turning a rough feature idea into a written spec — before any spec exists. For early-stage design conversations: refining what to build, exploring approaches, and writing the spec to `docs/specs/`. If a spec already exists and you're moving to implementation planning, use `write-plan` instead.
allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*), Bash(mkdir:*), Grep, Glob, Task
---

# Brainstorming Ideas Into Designs

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. A todo list, a single-function utility, a config change — all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple projects), but you must present it and get approval.

## The Process

Track these as tasks and complete in order.

### 1. Explore project context

Check the current project state — files, docs, recent commits. Before asking detailed questions, assess scope: if the request describes multiple independent subsystems (e.g., "build a platform with chat, file storage, billing, and analytics"), flag this immediately. Don't refine details of a project that needs to be decomposed first.

If the project is too large for a single spec, help the user decompose into sub-projects: what are the independent pieces, how do they relate, what order should they be built? Then brainstorm the first sub-project through the normal flow. Each sub-project gets its own spec → plan → implementation cycle.

### 2. Ask clarifying questions

For appropriately-scoped projects, refine the idea by asking questions one at a time. Focus on purpose, constraints, success criteria.

- One question per message. If a topic needs more exploration, break it into multiple questions.
- Prefer multiple choice when possible — easier to answer than open-ended.

### 3. Propose 2-3 approaches

Present options conversationally with trade-offs. Lead with your recommended option and explain why. Different approaches should make different fundamental tradeoffs, not minor variations.

### 4. Present the design

Once you understand what you're building, present the design section by section and get approval after each section before moving on.

- Scale each section to its complexity: a few sentences if straightforward, up to 200-300 words if nuanced.
- Cover: architecture, components, data flow, error handling, testing.
- Be ready to go back and clarify if something doesn't make sense.

**Design for isolation and clarity.** Break the system into smaller units that each have one clear purpose, communicate through well-defined interfaces, and can be understood and tested independently. For each unit, you should be able to answer: what does it do, how do you use it, what does it depend on? If someone can't understand a unit without reading its internals, or you can't change the internals without breaking consumers, the boundaries need work. Smaller, well-bounded units are also easier to work with — you reason better about code you can hold in context at once, and edits are more reliable when files are focused.

**In existing codebases.** Explore the current structure before proposing changes; follow existing patterns. Where existing code has problems that affect the work (a file that's grown too large, unclear boundaries, tangled responsibilities), include targeted improvements as part of the design — the way a good developer improves code they're working in. Don't propose unrelated refactoring; stay focused on what serves the current goal.

### 5. Write the spec

After the user approves the design, write it to `docs/specs/<YYYY-MM-DD>-<topic>.md` and commit.

### 6. Self-review the spec

Look at the written spec with fresh eyes:

1. **Placeholder scan:** Any "TBD", "TODO", incomplete sections, or vague requirements? Fix them.
2. **Internal consistency:** Do any sections contradict each other? Does the architecture match the feature descriptions?
3. **Scope check:** Focused enough for a single implementation plan, or does it need decomposition?
4. **Ambiguity check:** Could any requirement be interpreted two different ways? Pick one and make it explicit.

Fix any issues inline.

### 7. User review gate

Ask the user to review the written spec:

> "Spec written and committed to `<path>`. Please review it and let me know if you want to make any changes before we start writing out the implementation plan."

If they request changes, make them and re-run step 6. Only proceed once the user approves.

### 8. Hand off to write-plan

Once the user has approved the spec, suggest `/write-plan` (or "plan it") when they're ready.

## Principles to apply throughout

- **YAGNI ruthlessly** — remove unnecessary features from designs.
- **Be flexible** — go back and clarify when something doesn't make sense.
