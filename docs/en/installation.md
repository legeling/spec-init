# Installation and updates

The [README](../../README.en.md#install) owns installation commands and host paths. Unpublished changes require installation from the local checkout; GitHub commands retrieve the remote version.

Distinguish two operations:

- Installing the skill copies its package without changing project documents. Installer `--force` prepares the replacement first and restores the old installation on failure. Successful updates replace customizations; back them up first. Invalid arguments and unsafe targets are rejected before writes.
- Scaffolding creates README, AGENTS, and docs/README when a skeleton is needed. Scaffold `--force` backs up those three targets outside the project before replacing them, without deleting old directories. `SPEC_INIT_BACKUP_ROOT` can select an outside-project backup location.

Old project workflow gates may remain after upgrading. Apply a scoped merge using the [migration reference](../../skills/spec-init/references/doc-boundaries.md), rather than treating installation or forced scaffolding as migration. Roll back only this change and preserve later user edits.
