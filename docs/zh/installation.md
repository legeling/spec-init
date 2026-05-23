# 安装说明

## Claude Code

```bash
cp -R skills/spec-init ~/.claude/skills/spec-init
```

## Codex

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```

## OpenCode

```bash
cp -R skills/spec-init ~/.config/opencode/skills/spec-init
```

## 验证方式

安装后，尝试显式调用：

- Claude / OpenCode: `/spec-init`
- Codex: `$spec-init`

或者直接询问：

- “帮我把这个想法整理成 requirements、design 和 TDD plan”
- “这是一个现成项目，帮我补 spec，先读代码再写文档”
