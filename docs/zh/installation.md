# 安装说明

## Claude Code

```bash
cp -R skills/spec-init ~/.claude/skills/spec-init
```

## Codex

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```

另外，这个 skill 已经自带：

- `skills/spec-init/agents/openai.yaml`

用于增强 Codex 中的展示信息和默认调用提示。

## OpenCode

```bash
cp -R skills/spec-init ~/.config/opencode/skills/spec-init
```

## 验证方式

安装后，尝试显式调用：

- Claude / OpenCode: `/spec-init`
- Codex: `$spec-init`

或者直接询问：

- “帮我初始化一个新项目骨架”
