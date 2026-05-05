<div align="center">

# spec-init

<p>
  <strong>A project kickoff skill for spec engineering: define requirements, design, tests, and tasks before implementation.</strong>
</p>

<p>
  <a href="./README.md">简体中文</a>
  ·
  <a href="./README.en.md">English</a>
</p>

<p>
  <img alt="Status Beta" src="https://img.shields.io/badge/status-beta-F59E0B">
  <img alt="Agent Skills Open Standard" src="https://img.shields.io/badge/agent%20skills-open%20standard-111827">
  <img alt="Claude Code" src="https://img.shields.io/badge/Claude%20Code-supported-7C3AED">
  <img alt="Codex" src="https://img.shields.io/badge/Codex-supported-059669">
  <img alt="OpenCode" src="https://img.shields.io/badge/OpenCode-supported-2563EB">
  <img alt="Workflow" src="https://img.shields.io/badge/workflow-SDD%20%2B%20TDD-0F766E">
  <img alt="Docs" src="https://img.shields.io/badge/docs-ZH%20%7C%20EN-E11D48">
</p>

<img src="./docs/assets/images/spec-init-poster.png" alt="spec-init poster" width="100%">

</div>

## Overview

`spec-init` is a project kickoff skill stored in `skills/`, but it is better understood as a lightweight spec engineering workflow entry point.

It does more than generate folders. It turns a vague idea into an executable spec-driven documentation system before implementation starts:

- `docs/00-project-intake.md`
- `docs/01-requirements.md`
- `docs/02-design.md`
- `docs/03-implementation-plan.md`
- `docs/04-tdd-plan.md`
- `docs/05-task-breakdown.md`
- `README.md`
- `AGENTS.md`

The goal is simple:

- separate requirements from design
- define boundaries before coding
- move testing earlier instead of “later”
- move the project into a spec engineering workflow from day one
- keep a clear traceability chain: `FR -> DES -> TEST -> T`

## Why this exists

Many projects do not fail because of technology. They fail because nobody made the following explicit early enough:

- what are we building
- why now
- what is out of scope
- how design maps to requirements
- how tests prove the work is done
- how tasks derive from requirements and design

This skill exists to make those things explicit at project start.

## Visuals

After initialization, the project should form an executable documentation flow: intake -> requirements -> design -> implementation plan -> tdd plan -> task breakdown, and only then move into implementation.

## What it generates

The skill creates or fills at least:

```text
docs/
docs/adr/
src/
tests/
scripts/
README.md
AGENTS.md
docs/00-project-intake.md
docs/01-requirements.md
docs/02-design.md
docs/03-implementation-plan.md
docs/04-tdd-plan.md
docs/05-task-breakdown.md
docs/adr/0000-record-template.md
```

These are not empty placeholders anymore. The templates include:

- writing boundaries
- self-check prompts
- version / priority hints
- `FR-*` / `DES-*` / `TEST-*` / `T-*` traceability expectations
- a minimal complete example project

## Best fit

- starting a project from 0 to 1
- wanting a spec-first / doc-first / tdd-first workflow
- teaching new developers the difference between requirements and design
- building a maintainable project entry point for future collaborators

## Not a fit

- one-off throwaway scripts
- quick demos with no documentation discipline
- mature repos that only need a small doc update
- bug fixing, reviewing, or adding tests to an existing project

## Supported hosts

| Host | Recommended install path | Typical invocation | Notes |
|---|---|---|---|
| Claude Code | `~/.claude/skills/spec-init` | `/spec-init` | supports richer frontmatter and dynamic context features |
| Codex | `.agents/skills/spec-init` | `$spec-init` or skill picker | includes `agents/openai.yaml` for better presentation and invocation defaults |
| OpenCode | `~/.config/opencode/skills/spec-init` | `/spec-init` or auto-load | also compatible with `.claude/skills` and `.agents/skills` |

## Installation

### Claude Code

```bash
cp -R skills/spec-init ~/.claude/skills/spec-init
```

### Codex

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```

This repository already includes:

- `skills/spec-init/agents/openai.yaml`

It improves Codex presentation by defining:

- display name
- short description
- default prompt
- implicit invocation policy

### OpenCode

```bash
cp -R skills/spec-init ~/.config/opencode/skills/spec-init
```

## Usage examples

```text
/spec-init my-app
/spec-init ./demo-service --type=api
/spec-init --here --type=web
$spec-init my-cli --type=cli
```

Or trigger it with natural language:

- “Initialize a new project skeleton for me”
- “Set up requirements, design, and TDD docs before coding”
- “I want an API project, but start with documentation, not implementation”

## Project types

Currently supported:

- `web`
- `api`
- `cli`
- `library`
- `service`

If the user does not specify one, the skill infers the most likely type and records the reasoning in `docs/00-project-intake.md`.

## The core value: traceability

The real value is not the number of markdown files. The value is that the repo gets pushed toward a connected chain:

- `FR-*`: what must be delivered
- `DES-*`: how the design satisfies it
- `TEST-*`: how to verify it
- `T-*`: what gets executed next

At minimum, the project should form one complete chain:

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

Without that chain, documentation tends to decay back into disconnected notes.

## Example project

See the included minimal complete example:

[`skills/spec-init/examples/demo-app/`](./skills/spec-init/examples/demo-app/)

It shows how intake, requirements, design, TDD, and tasks should connect in practice.

## Repository layout

```text
docs/
|-- assets/images/
|-- zh/
`-- en/
skills/
`-- spec-init/
    |-- SKILL.md
    |-- scripts/
    |-- references/
    |-- assets/
    `-- examples/
```

```text
skills/spec-init/
|-- SKILL.md
|-- agents/
|   `-- openai.yaml
|-- scripts/
|   `-- spec-init.sh
|-- references/
|   |-- doc-boundaries.md
|   `-- example-idea-to-docs.md
|-- assets/
|   `-- templates/
|       `-- project/
`-- examples/
    `-- demo-app/
```

## Status

- working bootstrap script
- stronger templates for requirements / design / TDD / tasks
- minimal complete example project
- bilingual README
- generated cover image
- multilingual docs structure
- Codex `agents/openai.yaml` included

## Next steps

- add more project-type-specific examples
- improve template variation by `web` / `api` / `cli`
- continue improving Codex metadata and host-specific polish

## License

This repository uses `PolyForm Noncommercial 1.0.0`.

That means:

- noncommercial use is allowed
- commercial use is not allowed
- distribution must include the license text or URL

See the root `LICENSE` file for the full terms.

If you plan to publish this repo, the next natural additions are:

- repository topics
- release notes
- screenshots or short demo recordings
