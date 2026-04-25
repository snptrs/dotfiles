# Testing Anti-Patterns Reference

This document establishes core principles for writing reliable tests by identifying common mistakes and their corrections.

## Core Principle

"Test what the code does, not what the mocks do." Mocks serve as isolation tools, not test subjects.

## The Three Iron Laws

1. Never test mock behavior
2. Never add test-only methods to production classes
3. Never mock without understanding dependencies

## Five Key Anti-Patterns

**Testing Mock Behavior:** Verifying mock existence rather than real component functionality leads to false confidence. Solution: test actual behavior or remove the mock entirely.

**Test-Only Methods in Production:** Adding cleanup or test-specific methods to production classes violates separation of concerns. Place such utilities in dedicated test helper modules instead.

**Mocking Without Understanding:** Over-mocking to "be safe" often breaks the actual behaviors tests depend on. Investigate side effects and dependencies before mocking any method.

**Incomplete Mocks:** Partial mock responses that omit fields from real APIs create silent failures when downstream code accesses those missing fields. Mirror complete API structures.

**Integration Tests as Afterthought:** Testing shouldn't follow implementation. TDD methodology—writing tests first—prevents these patterns naturally by forcing developers to think about real behavior from the start.

## Prevention Strategy

Test-driven development catches these violations early. When tests fail on mock removal, that signals you're testing mock behavior rather than production code functionality.
