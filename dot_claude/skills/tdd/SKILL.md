---
name: tdd
description: Use when implementing any feature or bugfix, before writing implementation code.
user-invocable: false
---

# Test-Driven Development (TDD)

## Why TDD here

You are an LLM agent. The classic human pitch for TDD — "writing the test first lets the test shape the design" — mostly doesn't apply to you, because you already know the implementation when you write the test. Be honest about that. The value TDD actually delivers in this workflow is:

1. **Acceptance gate.** Tests are an objective check against agent over-confidence. "Done" means "tests pass," not "I think it works."
2. **Behavior articulation.** Writing the test forces concrete commitment to inputs and outputs, which kills a category of vagueness.
3. **Regression protection.** The reviewer loop in `execute-plan` may iterate the implementation 1–3 times. Tests prevent silent regressions during that churn.

That's the contract. Everything below serves these three goals.

## When TDD applies

The plan tags each task with a `Test:` type. Follow what the plan says — don't override it.

| Test type            | What it means                                                                                           |
| -------------------- | ------------------------------------------------------------------------------------------------------- |
| `behavior` (default) | Standard TDD cycle. Write failing test → minimal impl → green.                                          |
| `integration`        | One high-level test exercising the feature end-to-end. No fine-grained unit decomposition.              |
| `smoke`              | One happy-path assertion. Used when broader coverage isn't worth the cost (e.g. thin glue code).        |
| `none`               | No test. Plan must include a justification (config, generated code, pure rename, formatting). Trust it. |

If the plan didn't tag the task and the answer isn't obviously `behavior`, ask before guessing.

## The Cycle

Three steps, not five:

```
RED → GREEN → COMMIT
```

### RED — write the test, watch it fail

Write the test that describes the behavior. Run it. Confirm it fails for the right reason (feature missing, not typo or import error).

For trivially mechanical assertions where the function genuinely doesn't exist yet, the failure mode is obvious — running the test is a formality. Skip the verify step in that case. Keep it for non-trivial assertions where "fails for the right reason" is informative.

### GREEN — implement, run tests, confirm pass

Write the simplest code to pass the test. Don't add features beyond what the test requires. Don't refactor surrounding code. Run the test and the surrounding suite. Confirm pass + no regressions.

Output should be pristine — no warnings, no errors. Warnings are signal.

### COMMIT

One coherent change per commit. Test and implementation together.

## Writing good tests

Whatever the plan specifies as the behavior contract, translate it into the codebase's actual test idiom — real fixtures, real imports, real conventions. Don't invent helpers that don't exist.

| Quality   | Good                                              | Bad                                                 |
| --------- | ------------------------------------------------- | --------------------------------------------------- |
| Minimal   | One behavior per test. "and" in the name = split. | `test('validates email and domain and whitespace')` |
| Clear     | Name describes behavior in caller's terms         | `test('test1')`, `test('handles edge case')`        |
| Real code | Exercise actual functions, not mocks              | Asserting on `mock.toHaveBeenCalledWith(...)`       |
| Stable    | Survives implementation refactor                  | Tied to internal structure / private methods        |

If a test is hard to write because the code is hard to test, that's design feedback. Pause and surface it.

## What "production code without a test" means

Don't write production code for a `behavior`-tagged task without a corresponding failing test. If you catch yourself doing it: write the test now, revert the impl, run the test to confirm it fails, restore the impl, run again to confirm pass. Same outcome as "delete and start over" without the theatrical waste.

This applies to behavior. It does not apply to:

- Tasks tagged `integration`, `smoke`, or `none`
- Test helpers, fixtures, or test infrastructure
- Genuinely throwaway exploration (the plan should have made that explicit)

## Common rationalizations

| Excuse                              | Reality                                                                      |
| ----------------------------------- | ---------------------------------------------------------------------------- |
| "Too simple to test"                | Simple code breaks. Test costs 30 seconds.                                   |
| "I'll add tests after"              | A test that passes on first run after the impl is written tells you nothing. |
| "Manual testing was enough"         | Ad-hoc isn't reproducible and won't catch the next regression.               |
| "The existing code has no tests"    | Add tests for the parts you touch. Don't expand the gap.                     |
| "This case is different because..." | If it really is, surface that to the user. Otherwise no.                     |
| "Test is hard to write"             | The code is hard to test. That's design feedback, not a TDD problem.         |

## Anti-patterns

When mocks or test utilities enter the picture, read @testing-anti-patterns.md. The short version:

- Don't test mock behavior — test what the code does
- Don't add test-only methods to production classes
- Don't mock things you don't understand

## Verification checklist

Before marking work complete:

- [ ] Test exists for every behavior the plan specified
- [ ] Edge cases listed in the plan are covered
- [ ] Tests pass; surrounding suite still passes
- [ ] Output is pristine — no warnings, no errors
- [ ] Tests exercise real code (mocks only where unavoidable)
- [ ] Test names describe behavior, not implementation

If a box doesn't check, fix it before reporting done.

## Bug fixes

Bug found? Write a failing test that reproduces it first. Then fix the code. The test proves the fix and prevents regression. Same RED → GREEN → COMMIT cycle.

## When stuck

| Problem                 | Move                                                                  |
| ----------------------- | --------------------------------------------------------------------- |
| Don't know how to test  | Write the wished-for API. If still stuck, ask the user.               |
| Test is too complicated | The interface is too complicated. Simplify, then test.                |
| Need to mock everything | Code is too coupled. Surface as a concern — may need design feedback. |
| Test setup is huge      | Extract helpers. If still huge, surface it.                           |
