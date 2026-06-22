# spec-init Overview

`spec-init` is a skill for kicking off a spec engineering workflow, not just a folder tree.

It helps projects start with:

- intake
- requirements
- design
- implementation plan
- verification plan
- task breakdown
- issues
- changes
- releases
- archive
- project rules
- README
- AGENTS rules

## Core idea

- clarify the problem before design
- define validation before large implementation
- keep documents connected through traceability
- run analyze after tasks and before implementation
- run converge after implementation so code, current docs, and change history align again

## Phase loop

```text
specify -> clarify -> plan -> tasks -> analyze -> implement -> converge
```

`spec-init` borrows this rhythm while keeping the layered `docs/` topology as the long-term source of truth instead of defaulting to `specs/`.

## Minimal traceability chain

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

## Generated structure highlights

- `docs/workflow/00-intake/README.md`
- `docs/workflow/01-requirements/README.md`
- `docs/workflow/02-design/README.md`
- `docs/workflow/03-implementation/README.md`
- `docs/workflow/04-verification/README.md`
- `docs/workflow/05-tasks/README.md`
- `docs/knowledge/`
- `docs/issues/README.md`
- `docs/changes/README.md`
- `docs/releases/README.md`
- `docs/archive/README.md`
- `docs/rules/`
