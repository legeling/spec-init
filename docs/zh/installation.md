# 安装说明

## 当前项目内安装（默认推荐）

在项目根目录执行：

```bash
npx --yes github:legeling/spec-init
```

或者：

```bash
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
```

默认会安装到：

```text
.agents/skills/spec-init
```

这条路径最适合直接把 skill 放进项目里，方便团队共享和版本管理。

## 安装到全局宿主目录

```bash
npx --yes github:legeling/spec-init --host claude
npx --yes github:legeling/spec-init --host opencode

curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host claude
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host opencode
```

## 安装到自定义目录

```bash
npx --yes github:legeling/spec-init --dir ./tools/skills/spec-init
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --dir ./tools/skills/spec-init
```

## 手动复制（备用）

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```

## 验证方式

安装后，尝试显式调用：

- Claude / OpenCode: `/spec-init`
- 项目内安装 / Codex: `$spec-init`

或者直接询问：

- “帮我把这个想法整理成 requirements、design 和 verification plan”
- “这是一个现成项目，帮我补 spec，先读代码再写文档”
