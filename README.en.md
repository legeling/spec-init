<div align="center">

# spec-init

<p>
  <strong>An agent skill for project documentation and spec workflow: continuously organizing workflow, knowledge, changes, issues, and archive docs.</strong>
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
  <img alt="Workflow" src="https://img.shields.io/badge/workflow-SDD%20%2B%20Topology-0F766E">
  <img alt="Docs" src="https://img.shields.io/badge/docs-ZH%20%7C%20EN-E11D48">
</p>

<table>
  <tr>
    <td><strong>Project Docs</strong><br/>A full documentation flow from intake and requirements to verification and executable tasks.</td>
    <td><strong>Built-in Rules</strong><br/>Clarification, bug-fix, change-management, and issue-tracking rules ship with the skill.</td>
    <td><strong>Traceability</strong><br/>A project starts with an explicit `FR -> DES -> TEST -> T` chain.</td>
  </tr>
</table>

<img src="./docs/assets/images/spec-init-flow.svg" alt="spec-init workflow" width="100%">

<img src="./docs/assets/images/spec-init-poster.png" alt="spec-init poster" width="100%">

</div>

## Overview

`spec-init` is an agent skill stored in `skills/`, but it is not just a directory bootstrap script.

Its real role is to help an agent turn either a vague idea or an existing project into an executable, traceable, rule-aware, topology-aware spec set:

- `docs/workflow/00-intake/README.md`
- `docs/workflow/01-requirements/README.md`
- `docs/workflow/02-design/README.md`
- `docs/knowledge/context/README.md`
- `docs/knowledge/structure/README.md`
- `docs/knowledge/behavior/README.md`
- `docs/knowledge/reference/README.md`
- `docs/workflow/03-implementation/README.md`
- `docs/workflow/04-verification/README.md`
- `docs/workflow/05-tasks/README.md`
- `docs/issues/README.md`
- `docs/changes/README.md`
- `docs/releases/README.md`
- `docs/archive/README.md`
- `spec-init.topology.yml`
- `docs/adr/README.md`
- `docs/adr/0000-record-template.md`
- `docs/rules/README.md`
- `README.md`
- `AGENTS.md`

Core goals:

- separate workflow, long-lived knowledge, change workspaces, and project records
- turn document-driven development into the default workflow
- define boundaries, validation, and task relationships before coding
- maintain a full traceability chain: `FR -> DES -> TEST -> T`
- ship project-level engineering rules, not just empty document shells
- require user clarification before making material decisions
- require design docs to include stack, architecture, trade-offs, and quality goals
- require root-cause analysis for bug fixes instead of guess-based changes
- require explicit verification planning with relevant white-box, performance, and security coverage
- require verification docs to separate strategy, standards, test design, case matrix, regression suite, test data, and coverage mapping instead of mixing them into one progress report
- require consistency analysis after task generation and documentation convergence after implementation

## Why this exists

Many projects do not fail because of technology. They fail because these questions were never made explicit early enough:

- what exactly are we building
- why are we building it now
- what is explicitly out of scope
- how design maps to requirements
- how tests prove the work is done
- how tasks derive from requirements and design
- what engineering rules the team is supposed to follow by default

Common outcomes:

- requirements and design get mixed together
- implementation planning and task lists get mixed together
- testing is always “added later”
- the README turns into empty marketing text
- rules only live in chat or PR comments instead of the repo itself

This skill exists to solve those problems at project start.

## Best for

- New projects: turn one fuzzy idea into intake, requirements, design, knowledge, verification, and tasks
- Existing projects: read real code first, then fill missing specs
- New requirements: update workflow, knowledge, and `docs/changes/active/`
- Bug fixes: record symptoms, root cause, fix approach, regression tests, and impact scope
- Releases: summarize additions, fixes, and breaking changes in `docs/releases/`
- Long-term maintenance: keep blockers, debt, and known risks in `docs/issues/`, and retired docs in `docs/archive/`

This repository is intended for Agent Skills workflows that need ongoing project documentation, long-lived knowledge, change workspaces, and issue management.

## What it produces

During execution, the agent creates or updates these spec artifacts based on the user's goal and the real project context:

```text
docs/
docs/workflow/00-intake/README.md
docs/workflow/01-requirements/README.md
docs/workflow/02-design/README.md
docs/workflow/03-implementation/README.md
docs/workflow/04-verification/README.md
docs/workflow/04-verification/01-test-strategy-and-quality-gates.md
docs/workflow/04-verification/02-test-standards.md
docs/workflow/04-verification/03-test-design-methodology.md
docs/workflow/04-verification/04-test-case-matrix.md
docs/workflow/04-verification/05-regression-suite.md
docs/workflow/04-verification/06-test-data-and-fixtures.md
docs/workflow/04-verification/07-coverage-map.md
docs/workflow/05-tasks/README.md
docs/knowledge/context/README.md
docs/knowledge/structure/README.md
docs/knowledge/behavior/README.md
docs/knowledge/reference/README.md
docs/issues/README.md
docs/rules/README.md
docs/rules/clarification-rules.md
docs/rules/coding-standards.md
docs/rules/bug-fix-rules.md
docs/rules/testing-standards.md
docs/rules/doc-sync-rules.md
docs/rules/change-management-rules.md
docs/rules/commit-rules.md
docs/rules/document-archive-rules.md
docs/rules/issue-management-rules.md
docs/rules/definition-of-done.md
docs/rules/document-routing-rules.md
docs/changes/README.md
docs/changes/active/<change-key>/
docs/changes/completed/
docs/changes/legacy/
docs/releases/README.md
docs/archive/README.md
docs/adr/README.md
docs/adr/0000-record-template.md
spec-init.topology.yml
README.md
AGENTS.md
```

These files should not remain empty placeholders. The skill still includes template and script resources, but those are helpers, not the final result.

The resulting content should include:

- document boundary guidance and routing rules
- self-check lists
- priority and version-boundary prompts
- `FR-*` / `DES-*` / `TEST-*` / `T-*` traceability expectations
- a project rules directory under `docs/rules/`
- clarification rules for material ambiguities
- root-cause bug-fix rules
- white-box / performance / security testing expectations
- layered verification expectations for strategy, quality gates, standards, test design, case matrix, regression suite, test data, and coverage mapping
- frontend guidance for resolution targets, colors, typography, and component rules
- backend guidance for API, database, migration, and naming conventions
- beginner-friendly decision guides and must-ask checklists by project type
- copyable example answers, scope trimming help, and common mistake examples
- current-state synthesis for existing projects
- explicit options, trade-offs, and recommendations for missing decisions
- change-workspace entry points for new requirements, bug fixes, and releases
- support for fuller requirements, fuller design, and ongoing spec refinement
- issue tracking, document retirement, and archive support

More concretely, it manages four documentation layers:

- workflow: `intake / requirements / design / implementation / verification / tasks`
- knowledge: `context / structure / behavior / reference`
- changes: `active / completed / legacy`
- records: `issues / releases / adr / archive / rules`

## Workflow phases

`spec-init` keeps its layered `docs/` topology while borrowing Spec Kit's staged rhythm:

| Phase | spec-init location | Goal |
|---|---|---|
| specify | `docs/workflow/00-intake/`, `docs/workflow/01-requirements/` | turn the idea into goals, boundaries, FR/NFR/AC |
| clarify | open-question sections, and `docs/issues/` when needed | clarify decisions that affect scope, design, data, permissions, or tests |
| plan | `docs/workflow/02-design/`, `03-implementation/`, `04-verification/`, `docs/knowledge/` | define design, delivery sequence, verification strategy, and long-lived truth |
| tasks | `docs/workflow/05-tasks/`, `docs/changes/active/<change-key>/tasks.md` | create executable, verifiable, traceable tasks |
| analyze | pre-implementation consistency analysis | find orphan IDs, missing mappings, conflicting docs, and blocking `[To confirm]` items |
| implement | code, tests, scripts, migrations | execute work that traces back to `FR -> DES -> TEST -> T` |
| converge | post-implementation documentation convergence | align real code behavior, current docs, and historical records again |

This does not make `specs/` the default project document directory. `docs/` remains the long-term source of truth.

## Structure

The generated SDD documents are now organized by semantic layers instead of being flattened in the root `docs/` directory:

```text
docs/
|-- workflow/
|   |-- 00-intake/
|   |   `-- README.md
|   |-- 01-requirements/
|   |   `-- README.md
|   |-- 02-design/
|   |   `-- README.md
|   |-- 03-implementation/
|   |   `-- README.md
|   |-- 04-verification/
|   |   |-- README.md
|   |   |-- 01-test-strategy-and-quality-gates.md
|   |   |-- 02-test-standards.md
|   |   |-- 03-test-design-methodology.md
|   |   |-- 04-test-case-matrix.md
|   |   |-- 05-regression-suite.md
|   |   |-- 06-test-data-and-fixtures.md
|   |   `-- 07-coverage-map.md
|   `-- 05-tasks/
|       `-- README.md
|-- knowledge/
|   |-- context/
|   |   `-- README.md
|   |-- structure/
|   |   `-- README.md
|   |-- behavior/
|   |   `-- README.md
|   `-- reference/
|       `-- README.md
|-- issues/
|   `-- README.md
|-- changes/
|   |-- README.md
|   |-- active/
|   |-- completed/
|   `-- legacy/
|-- releases/
|   `-- README.md
|-- archive/
|   `-- README.md
|-- adr/
|   |-- README.md
|   `-- 0000-record-template.md
`-- rules/
    |-- README.md
    |-- clarification-rules.md
    |-- coding-standards.md
    |-- bug-fix-rules.md
    |-- testing-standards.md
    |-- doc-sync-rules.md
    |-- change-management-rules.md
    |-- commit-rules.md
    |-- document-archive-rules.md
    |-- issue-management-rules.md
    |-- document-routing-rules.md
    `-- definition-of-done.md
```

Why this structure:

- `workflow/` stops numbered stage docs from being mixed with every other root-level doc
- `knowledge/` holds long-lived truth instead of forcing everything into current-stage docs
- `changes/` holds one-change workspaces and lifecycle states
- `spec-init.topology.yml` and `document-routing-rules.md` decouple semantics from physical paths
- `rules/` lets the project keep engineering rules inside the generated scaffold
- `changes/` and `releases/` preserve historical context instead of losing it
- `issues/` and `archive/` give unresolved problems and retired docs a clear home
- newcomers can see what to read first and what to do next

## Installation targets

| Target | Default path | Typical invocation | Notes |
|---|---|---|---|
| Current project (default) | `.agents/skills/spec-init` | `$spec-init` or skill picker | best when the skill should live with the repository; also works for project-local OpenCode setups |
| Claude Code | `~/.claude/skills/spec-init` | `/spec-init` | suitable for a global Claude Code install |
| OpenCode | `~/.config/opencode/skills/spec-init` | `/spec-init` or auto-load | suitable for a global OpenCode install |

## Installation

The default recommendation is to install directly into the current project.

Run this from the project root:

```bash
npx --yes github:legeling/spec-init
```

Or:

```bash
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
```

By default this installs to `.agents/skills/spec-init` in the current directory.

If you want the global Claude Code or OpenCode location instead:

```bash
npx --yes github:legeling/spec-init --host claude
npx --yes github:legeling/spec-init --host opencode

curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host claude
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host opencode
```

If you want a custom location:

```bash
npx --yes github:legeling/spec-init --dir ./tools/skills/spec-init
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --dir ./tools/skills/spec-init
```

Manual copying still works, but it is now just a fallback:

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```

## Usage examples

Different hosts use different explicit invocation syntax, but the intent is the same.

Examples:

```text
/spec-init my-app
/spec-init ./demo-service --type=api
/spec-init --here --type=web --lang=en
$spec-init my-cli --type=cli
```

You can also trigger it with natural language:

- “Turn this idea into requirements, design, and a verification plan”
- “This is an existing project, read the code first and then help me add specs”
- “I want an API project, but start by clarifying the specs before coding”
- “Analyze this repo and tell me which docs and rules are missing”

## Project types

Currently supported:

- `web`
- `api`
- `cli`
- `library`
- `service`

If the user does not specify one, the skill makes a baseline inference from the project name and directory name, then records the reasoning in `docs/workflow/00-intake/README.md`.

## Output language

The helper template resources support:

- `--lang zh`
- `--lang en`

Current behavior:

- Chinese is the default output language
- `--lang en` generates English templates
- `web` / `api` / `cli` have differentiated templates in both languages

## Type-specific templates

`web`, `api`, and `cli` already have differentiated templates, mainly in:

- `docs/workflow/01-requirements/README.md`
- `docs/workflow/02-design/README.md`
- `docs/workflow/04-verification/README.md`
- `docs/workflow/05-tasks/README.md`

## Built-in rules

This project no longer generates only documents. It also generates project-level engineering rules:

- `docs/rules/clarification-rules.md`
- `docs/rules/coding-standards.md`
- `docs/rules/bug-fix-rules.md`
- `docs/rules/testing-standards.md`
- `docs/rules/doc-sync-rules.md`
- `docs/rules/change-management-rules.md`
- `docs/rules/commit-rules.md`
- `docs/rules/document-archive-rules.md`
- `docs/rules/issue-management-rules.md`
- `docs/rules/definition-of-done.md`
- `docs/rules/document-routing-rules.md`

`AGENTS.md` defines execution order for agents, `docs/rules/` keeps those rules as in-repo engineering assets, and `spec-init.topology.yml` maps semantics to concrete paths.

The current rule set especially strengthens four areas:

1. material ambiguities must be confirmed with the user, with options and trade-offs explained
2. design docs must include stack, architecture, trade-offs, and quality goals
3. bug fixes must identify root cause instead of guessing
4. verification must be explicit and include relevant white-box, performance, and security coverage
5. analyze before implementation and converge before delivery so docs do not remain only a plan

## The real value: traceability

The real value is not the number of markdown files. The value is that the project gets pushed toward a connected chain:

- `FR-*`: what must be delivered
- `DES-*`: how the design satisfies it
- `TEST-*`: how to verify it
- `T-*`: what gets executed next

At minimum, the project should form one complete chain:

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

Without that chain, documentation easily decays back into disconnected notes.

## Example project

See the included minimal complete example:

[`skills/spec-init/examples/demo-app/`](./skills/spec-init/examples/demo-app/)

It shows:

- how intake is written
- how requirements are written
- how design maps to requirements
- how the verification plan maps to requirements
- how the task breakdown becomes executable work
- how knowledge, changes, releases, issues, and archive docs support long-term maintenance
- how `rules/` becomes part of the generated project structure

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

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=legeling/spec-init&type=Date)](https://www.star-history.com/#legeling/spec-init&Date)

## Contributors

Thanks to everyone who has contributed to this project.

[![Contributors](https://contrib.rocks/image?repo=legeling/spec-init)](https://github.com/legeling/spec-init/graphs/contributors)

## License

This repository uses `PolyForm Noncommercial 1.0.0`.

That means:

- noncommercial use is allowed
- commercial use is not allowed
- distribution must include the license text or URL

See the root `LICENSE` file for the full terms.
