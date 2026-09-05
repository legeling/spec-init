# spec-init

[简体中文](README.md)

Keep the agreements that guide development, with documentation effort proportional to risk.

Small fixes may need no documentation. Confirmed requirement changes immediately replace old statements in the authoritative spec. High-risk changes retain necessary design and verification. When implementation is requested, documentation supports delivery rather than replacing it.

## Default workflow

1. Read project instructions, relevant code, tests, and current agreements.
2. Establish the intended outcome, boundaries, and verification. Start implementation once material decisions are clear.
3. Complete code, tests, and necessary documentation as a batch, then verify and reconcile the affected agreements.

No change workspace per request, mandatory `FR → DES → TEST → T` chain, or repository-wide documentation catch-up. Expand design only when explicitly requested or warranted by risk.

## What to retain

| Content | Treatment |
|---|---|
| Latest confirmed requirements, boundaries, acceptance | One authoritative document per topic; replace old requirements immediately upon confirmation |
| Implementation actions, progress, blockers | Keep a plan when needed and reference authoritative requirements without redefining them |
| Important tradeoffs and recovery decisions | Record in the relevant document; separate only for independent maintenance |
| History | Use Git for ordinary edits; historical records explain decisions, not current tasks |

Unconfirmed proposals cannot overwrite requirements. Confirmed changes update the single source immediately, with unfinished implementation marked pending. Correct conflicting current statements, including those in AGENTS, or replace duplicates with references; appending a new statement is insufficient. History is explicitly superseded and supplies no current tasks.

Existing paths remain valid. New projects may use `docs/specs/<topic>.md` and `docs/plans/<topic>.md` when needed, without creating empty directories in advance.

## Install

From the target project root:

```bash
npx --yes github:legeling/spec-init
```

Or use the Bash installer:

```bash
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
```

The default destination is `.agents/skills/spec-init` within the project. `--host codex` aliases that project destination; `--host claude` uses `~/.claude/skills/spec-init`; `--host opencode` uses `~/.config/opencode/skills/spec-init`. Use `--dir PATH` for an explicit destination.

GitHub commands install the remote version, not unpublished local changes. To install the local checkout:

```bash
node bin/spec-init.js --dir /absolute/path/to/project/.agents/skills/spec-init
```

Installer `--force` replaces only an existing complete skill installation. Empty arguments, unrelated directories, symlink paths and overlapping source/target paths are rejected. The new package is prepared and checked before replacement; failures restore the old installation, or retain a recovery directory and report its path if restoration fails. Successful updates replace customizations, so back them up first. Installing the skill does not migrate a project's existing AGENTS or documentation.

## Use

```text
$spec-init Update this feature's current agreements and complete implementation and verification.
$spec-init Revise the existing export plan to reflect the changed requirements.
$spec-init Design this data migration, including compatibility, recovery, and verification.
$spec-init Simplify this project's old documentation workflow while preserving project-specific rules.
```

Ordinary coding does not automatically start the full documentation workflow. Automatic skill selection remains enabled; discovery focuses on explicit specification and documentation maintenance needs.

## Optional scaffold

Use only when an empty project needs a documentation skeleton:

```bash
bash skills/spec-init/scripts/spec-init.sh ./demo --type api --lang en
```

Only three files are generated: `README.md`, `AGENTS.md`, and `docs/README.md`. No rules library, sample change, traceability matrix, topology, or source directories. The script cannot infer business requirements; generating a skeleton does not complete a spec.

The existing `--here`, `--name`, `--type`, `--lang`, and `--force` options remain. Types are web, api, cli, library, service; languages are zh and en. Types describe the project without selecting large specialized templates. Name-based type inference is a hint, not repository investigation.

Existing files are preserved by default. Scaffold `--force` backs up and replaces only its three target files, without deleting old directories. Backups live outside the project under the user state directory in `spec-init/backups`, with restore instructions. Set `SPEC_INIT_BACKUP_ROOT` to use another outside-project location; output identifies backups. Migrate existing rules with targeted edits rather than force-overwriting scaffolds.

## Upgrade and rollback

Existing workflow, knowledge, and changes paths need not move. Replace old workflow gates within the authorized scope, identify current agreements, and remove superseded tasks from active navigation. Preserve effective project-specific constraints.

See the [migration reference](skills/spec-init/references/doc-boundaries.md) and [implementation and acceptance plan](docs/optimization-plan.md) (Chinese). Roll back only this change, preserving subsequent user edits.

## Maintenance

```bash
npm run lint
npm test
```

Script checks cover output scope, preservation, argument failures, and backups. Behavioral acceptance covers small fixes, ordinary features, requirement reversals, and risky migrations; phrase matching alone cannot establish sound agent decisions.

- [Skill entry](skills/spec-init/SKILL.md)
- [Example project](skills/spec-init/examples/demo-app/README.md)
- [Contribution guide](docs/en/contributing.md)

License: [PolyForm Noncommercial](LICENSE).
