---
name: write-plan
description: Use when an approved spec exists in `docs/specs/` and you need a task-by-task implementation plan written to `docs/plans/`, before execution. If no spec exists yet, use `brainstorm` first.
allowed-tools: Read, Write, Bash(git add:*), Bash(git commit:*), Bash(mkdir:*), Grep, Glob, Task
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for the codebase and questionable taste. Document everything they need to know: which files to touch for each task, what behaviors they must cover, exact commands, frequent commits.

The implementer will often be a weaker model (haiku). Your plan is the only context they have. DRY. YAGNI. TDD. Frequent commits.

**Dispatch the `@architect` agent** to do the heavy thinking and generate the plan structure. Once the architect returns, format the output into the canonical task template below and save it.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure — but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Behavior Contracts, Not Test Code

You are writing the plan without seeing the codebase's actual test idioms, fixtures, imports, or factory functions. Test code you write here will be wrong in those details, and the implementer can't easily evolve it without violating the plan.

**Specify what to test, not how to test it.** Give the implementer a tight behavior contract — they translate it into real test code in the codebase's actual idiom.

Each task includes a `Test:` section with:

- **Type** — one of `behavior` | `integration` | `smoke` | `none` (see below)
- **Behaviors to verify** — concrete input/output pairs the test must assert
- **Edge cases** — additional cases that should be covered
- **Setup notes** (optional) — e.g. "uses existing `make_form_data()` factory"

### Test types

| Type          | When to use                                                                                                                               |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `behavior`    | Default for most tasks. Standard TDD per-behavior tests.                                                                                  |
| `integration` | When the feature is best validated end-to-end and unit decomposition would be artificial. One high-level test instead of many small ones. |
| `smoke`       | Thin glue code where one happy-path assertion is enough. Don't use this to dodge real coverage.                                           |
| `none`        | Pure config, generated code, formatting, or trivial renames. **Requires explicit one-line justification in the plan.**                    |

Default to `behavior`. Use `integration` when fine-grained tests would test implementation, not behavior. Use `smoke` and `none` sparingly — both must be defensible to the spec-reviewer.

### Granularity

Prefer the highest-level test that gives confidence. Many fine-grained unit tests are worse than one good integration test if the unit boundary is artificial. Listen for "many tiny tests of internal helpers" — that's a smell that the test type should be `integration`.

## Task Granularity

Each task is a coherent unit of work the implementer ships in one go: a test (or test set), an implementation that makes it pass, a commit. Don't fragment within the task — the implementer follows the TDD cycle (RED → GREEN → COMMIT) for the whole task.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# Plan: <feature name>

Spec: docs/specs/<YYYY-MM-DD>-<topic>.md

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---

## Tasks
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**

- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Test:** `behavior` (or `integration` / `smoke` / `none — <justification>`)

**Behaviors to verify:**

- empty email input → returns `{ error: "Email required" }`
- whitespace-only email → returns `{ error: "Email required" }`
- valid email "user@example.com" → returns `{ ok: true }`

**Edge cases:**

- email at max length (254 chars)
- mixed-case domain (`User@Example.COM` should normalize)

**Setup notes:** Uses the existing `makeFormData()` factory in `tests/helpers/form.ts`.

**Test difficulty:** standard | high (mark `high` for non-trivial async, mocking, or integration setup — the executor uses this to bump model selection)

- [ ] **Step 1: RED — write failing test(s) for the contract above**

      The implementer writes test code in the codebase's idiom covering every behavior + edge case listed. Runs the test; confirms it fails for the right reason.

- [ ] **Step 2: GREEN — implement minimal code to pass**

      ```python
      def submit_form(data):
          if not data.get("email", "").strip():
              return {"error": "Email required"}
          # ...
      ```

      Runs tests; confirms pass + no regressions in the surrounding suite.

- [ ] **Step 3: Commit**

      ```bash
      git add tests/path/test.py src/path/file.py
      git commit -m "feat: validate email on form submit"
      ```
````

The implementer subagent reads this template directly and executes it. Every step must contain the actual content the engineer needs — file paths, behavior contracts, implementation code, exact commands. The plan is implementer-facing, not human-facing; verbosity is a feature.

**Implementation code** still lives in the plan (Step 2). Test code does not — the contract goes in the `Test:` section, the implementer writes the actual test.

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:

- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Test the function" (without a behavior contract)
- "Similar to Task N" (repeat the content — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for implementation steps)
- References to types, functions, or methods not defined in any task
- `Test: none` without a justification
- Behavior contracts with vague entries like "handles invalid input" — name the input and the expected output

## Remember

- Exact file paths always
- Behavior contract for every test — concrete inputs and expected outputs
- Implementation code in every Step 2 — show the code
- Exact commit commands
- DRY, YAGNI, TDD, frequent commits

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it.

**1. Spec coverage:** Skim each section/requirement in the spec. Can you point to a task that implements it? List any gaps.

**2. Placeholder scan:** Search the plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**3. Test type honesty:** Any `none` tags justified? Any `smoke` tags hiding real coverage gaps? Any `integration` tags that are actually a dodge for "I don't want to write a contract"?

**4. Behavior contract quality:** For every `behavior` and `integration` task, are the listed behaviors concrete (named inputs, named outputs)? "Validates input" is not a contract; "rejects empty string with error 'Required'" is.

**5. Type consistency:** Do the types, method signatures, and property names used in later tasks match what was defined in earlier tasks? A function called `clearLayers()` in Task 3 but `clearFullLayers()` in Task 7 is a bug.

If you find issues, fix them inline. If you find a spec requirement with no task, add the task.

## Plan Review Gate

After saving the plan, dispatch `@plan-reviewer` with:

- Path to the plan file
- Path to the spec file

If plan-reviewer returns issues, address them before showing the plan to the user. This is a quality gate before the user sees the plan.

## Execution Handoff

After the plan passes review, save it to `docs/plans/<YYYY-MM-DD>-<feature>.md` and commit. Then suggest `/execute-plan` when the user is ready.
