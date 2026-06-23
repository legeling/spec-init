# spec-init Overview

`spec-init` is a skill for kicking off a spec engineering workflow, not just a folder tree.

It helps projects start with:

- intake
- requirements
- design
- implementation plan
- verification plan
- test strategy, standards, design methodology, case matrix, regression suite, test data, and coverage map
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
- separate test strategy, standards, design methodology, case matrix, and regression suite before turning testing into executable tasks
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
- `docs/workflow/04-verification/01-test-strategy-and-quality-gates.md`
- `docs/workflow/04-verification/02-test-standards.md`
- `docs/workflow/04-verification/03-test-design-methodology.md`
- `docs/workflow/04-verification/04-test-case-matrix.md`
- `docs/workflow/04-verification/05-regression-suite.md`
- `docs/workflow/04-verification/06-test-data-and-fixtures.md`
- `docs/workflow/04-verification/07-coverage-map.md`
- `docs/workflow/05-tasks/README.md`
- `docs/knowledge/`
- `docs/issues/README.md`
- `docs/changes/README.md`
- `docs/releases/README.md`
- `docs/archive/README.md`
- `docs/rules/`
