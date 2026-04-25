---
name: receiving-review
description: Use when receiving code review feedback, before implementing reviewer suggestions, especially if feedback seems unclear or technically questionable.
---

# Receiving Code Review

## Core Principle

Verify before implementing. Ask before assuming. Technical correctness over social comfort.

## The Protocol

WHEN receiving code review feedback:

1. **READ:** Complete feedback without reacting
2. **UNDERSTAND:** Restate requirement in own words (or ask)
3. **VERIFY:** Check against codebase reality
4. **EVALUATE:** Technically sound for THIS codebase?
5. **RESPOND:** Technical acknowledgment or reasoned pushback
6. **IMPLEMENT:** One item at a time, test each

## If Any Item Is Unclear

IF any item is unclear: **STOP** — do not implement anything yet. ASK for clarification on unclear items.

WHY: items may be related; partial understanding = wrong implementation.

## Before Implementing

1. Check: Technically correct for THIS codebase?
2. Check: Breaks existing functionality?
3. Check: Reason for current implementation?
4. Check: Works on all platforms/versions?
5. Check: Does reviewer understand full context?

IF suggestion seems wrong: push back with technical reasoning.

IF can't easily verify: say so: "I can't verify this without [X]. Should I [investigate/ask/proceed]?"

## Prohibited Responses

Avoid performative language: "You're absolutely right!", "Great point!", "Excellent feedback!"

Show understanding through concrete fixes, not gratitude. "Fixed. [Description]" demonstrates you heard the feedback.

## Implementation Sequence

Address blocking issues first, then simple fixes, followed by complex refactoring. Test each change individually to prevent regressions.

## Correcting Mistaken Pushback

State the correction factually without lengthy apologies: "Verified this and you're correct. My understanding was wrong because [reason]. Fixing now."

## Closing Principle

External feedback = suggestions to evaluate, not orders to follow. Verify. Question. Then implement. No performative agreement.
