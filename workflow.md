# DWM-Sky Development Workflow

## Principle

Slow is smooth. Smooth is fast.

The purpose of using an LLM is not to generate the entire system instantly.

The LLM should help:

- inspect
- reason
- trace dependencies
- implement small changes
- review
- test
- document

The user remains responsible for understanding and approving architectural decisions.

## Standard cycle

### 1. Understand

Inspect the current implementation.

Answer:

- What currently happens?
- Why does it happen?
- Which file/process owns it?
- What depends on it?
- What is the desired behavior?

### 2. Plan

Define the smallest implementation that achieves the goal.

Identify:

- files involved
- risks
- dependencies
- rollback strategy
- verification

### 3. Implement

Make small, focused changes.

Avoid unrelated refactoring.

### 4. Verify

Run:

- syntax checks
- targeted tests
- runtime checks
- behavior tests

### 5. Review

Inspect:

```bash
git diff
git status
```
