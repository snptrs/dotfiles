---
name: pr-summary
description: Generate a pull request title and description for the current branch. Use this whenever the user asks to write, draft, or generate a PR title, PR description, pull request summary, or wants to open a PR — even if they just say "write up the PR" or "summarize this branch for a PR". Don't wait for an explicit /pr-summary command; trigger on intent.
---

Generate a pull request title and description for the current branch.

1. Run these commands to understand the branch:
   - `git log main..HEAD --oneline` — commits on this branch
   - `git diff main...HEAD --stat` — files changed
   - `git diff main...HEAD` — full diff (skim for intent, not line-by-line)

2. Determine the base branch. If `main` has no commits in common, try `master` or the most recent branch point.

3. Write a PR title:
   - Under 70 characters
   - Imperative mood ("Add X", "Fix Y", "Remove Z")
   - No ticket numbers unless one appears in the branch name

4. Write a PR description using this structure:

```
## Summary
- <bullet 1>
- <bullet 2>
- <bullet 3 if needed>

## Changes
<brief explanation of what changed and why — focus on intent, not a restatement of the diff>

## Test plan
- [ ] <specific thing to verify>
- [ ] <edge case or regression to check>
```

5. Output the title and description in a code block so they're easy to copy.

Do not ask clarifying questions — generate based on the diff and commit messages.
