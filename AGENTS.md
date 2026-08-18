# DWM-Sky Agent Instructions

## Mission

Maintain and improve this DWM-Sky system as a stable, reproducible personal desktop environment.

Priorities, in order:

1. Preserve working behavior.
2. Make the system understandable and reproducible.
3. Make the smallest correct change.
4. Verify before considering work complete.
5. Avoid unnecessary redesign or cleanup.

This is a long-lived personal system. Stability is more important than novelty.

## Working philosophy

Work slowly and incrementally.

Do not generate large amounts of code merely because it is possible.

Before changing anything:

1. Inspect the relevant files and runtime behavior.
2. Identify the actual source of truth.
3. Trace dependencies and callers.
4. Determine what is actually active.
5. Make the smallest change that solves the problem.
6. Verify the result.
7. Inspect the diff.
8. Continue only when the previous step is understood.

Prefer existing mechanisms over introducing new ones.

Do not assume a file is active because its name looks relevant.

Do not assume two similarly named files serve the same purpose.

## Evidence over assumptions

When something is unclear:

- inspect it
- search for references
- check the running process/environment
- check Git history when relevant
- verify configuration resolution

Do not guess.

For potentially destructive or ambiguous changes, stop and ask the user.

## Scope control

Only modify files necessary for the current phase.

Do not:

- redesign unrelated systems
- perform opportunistic cleanup
- remove "stale" files without proving they are unused
- modify system files when a user-level solution exists
- modify `/usr/local/bin` unless explicitly requested
- modify the Titus legacy tree unless explicitly required
- change unrelated desktop behavior

If a change appears useful but belongs to another phase, leave it alone and mention it.

## Backups

Before modifying important configuration or repository state:

- create an appropriate external backup
- preserve Git state
- never use `git reset --hard` unless explicitly authorized
- never blindly overwrite existing configuration

Backups must not become part of the Git repository.

## Git rules

Before significant repository changes:

```bash
git status
git diff
git diff --cached
```
