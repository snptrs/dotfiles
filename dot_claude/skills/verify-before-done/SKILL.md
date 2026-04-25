---
name: verify-before-done
description: Use before claiming work is complete, before reporting test passes, fixes, or success. Requires running the verification command and reading the output before any claim.
user-invocable: false
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim                 | Requires                        | Not Sufficient                 |
| --------------------- | ------------------------------- | ------------------------------ |
| Tests pass            | Test command output: 0 failures | Previous run, "should pass"    |
| Linter clean          | Linter output: 0 errors         | Partial check, extrapolation   |
| Build succeeds        | Build command: exit 0           | Linter passing, logs look good |
| Bug fixed             | Test original symptom: passes   | Code changed, assumed fixed    |
| Regression test works | Red-green cycle verified        | Test passes once               |
| Agent completed       | VCS diff shows changes          | Agent reports "success"        |
| Requirements met      | Line-by-line checklist          | Tests passing                  |

## When to Stop and Run the Command

If you catch yourself in any of these patterns, you don't have evidence yet — go run the verification command before continuing.

**Behavioral patterns:**

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!")
- About to commit, push, or open a PR without verification
- Trusting an agent's success report instead of checking the diff
- Relying on partial verification (linter passed → assume tests pass)

**Rationalizations and their counters:**

| Excuse                                      | Counter                                                                |
| ------------------------------------------- | ---------------------------------------------------------------------- |
| "Should work now"                           | Confidence ≠ evidence. Run the verification.                           |
| "Linter passed"                             | Linter doesn't check compilation, and compiler doesn't check behavior. |
| "Agent said success"                        | Verify independently — check the diff.                                 |
| "I'm tired / just this once"                | Tired-and-wanting-it-over is exactly when bugs ship.                   |
| "Partial check is enough"                   | Partial proves nothing about the part you didn't check.                |
| "Different words so the rule doesn't apply" | Spirit over letter — any implication of success counts.                |

## Key Patterns

**Tests:**

```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**

```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**

```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**

```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**

```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## Why This Matters

- Honesty is a core value. If you lie, you'll be replaced.
- Trust breaks when you report success without verification.
- Undefined functions, missing requirements, and incomplete features ship when verification is skipped.
- Time wasted on false completion leads to rework.

## When To Apply

Run verification before any claim of success — committing, opening a PR, completing a task, moving to the next task, or delegating to an agent. The rule covers exact phrases, paraphrases, synonyms, and any communication that implies completion or correctness. Saying it differently doesn't exempt the claim.
