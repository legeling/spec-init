# Installation

## Install into the current project (recommended)

Run this from the project root:

```bash
npx --yes github:legeling/spec-init
```

Or:

```bash
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
```

By default this installs to:

```text
.agents/skills/spec-init
```

That path is the simplest option when the skill should live with the repository and be shared with the rest of the team.

## Install into a global host directory

```bash
npx --yes github:legeling/spec-init --host claude
npx --yes github:legeling/spec-init --host opencode

curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host claude
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host opencode
```

This skill also includes:

- `skills/spec-init/agents/openai.yaml`

to improve Codex presentation metadata and default invocation messaging.

## Install into a custom directory

```bash
npx --yes github:legeling/spec-init --dir ./tools/skills/spec-init
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --dir ./tools/skills/spec-init
```

## Manual copy fallback

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```
