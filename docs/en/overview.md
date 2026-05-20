# spec-init Overview

`spec-init` is a skill for kicking off a spec engineering workflow, not just a folder tree.

It helps projects start with:

- intake
- requirements
- design
- implementation plan
- TDD plan
- task breakdown
- project rules
- README
- AGENTS rules

## Core idea

- clarify the problem before design
- define validation before large implementation
- keep documents connected through traceability

## Minimal traceability chain

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

## Generated structure highlights

- `docs/00-intake/README.md`
- `docs/01-requirements/README.md`
- `docs/02-design/README.md`
- `docs/03-implementation/README.md`
- `docs/04-tdd/README.md`
- `docs/05-tasks/README.md`
- `docs/rules/`
