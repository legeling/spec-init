<div align="center">

# spec-init

<p>
  <strong>一个偏向 spec engineering 的项目启动 skill：先写清需求、设计、测试和任务，再开始实现。</strong>
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

## 项目简介

`spec-init` 是一个放在 `skills/` 目录里的项目启动 skill，但它更接近一套轻量的 spec engineering 工作流入口。

它不是“帮你多建几个目录”的脚手架，而是把一个模糊的项目想法，先落成一套可执行的 spec 工程文档系统：

- `docs/00-project-intake.md`
- `docs/01-requirements.md`
- `docs/02-design.md`
- `docs/03-implementation-plan.md`
- `docs/04-tdd-plan.md`
- `docs/05-task-breakdown.md`
- `README.md`
- `AGENTS.md`

核心目标很明确：

- 帮开发者区分需求和设计
- 在写代码前把边界、方案、测试和任务拆清楚
- 让项目从第一天开始按 spec engineering 的方式推进
- 建立一条完整的追踪链：`FR -> DES -> TEST -> T`

## 为什么做这个 skill

很多项目不是死在技术上，而是死在一开始根本没搞清楚：

- 到底要做什么
- 为什么做
- 哪些不做
- 方案怎么承接需求
- 测试怎么证明需求被实现
- 任务怎么从需求和设计里拆出来

结果通常是：

- 需求和设计混写
- 实现计划和任务清单混写
- 测试永远是“后面补”
- README 只剩一句空话
- 新人看不懂项目从哪开始

这个 skill 的定位，就是把这些坑前置解决。

## 两张图看懂

### 1. 仓库里的 skill 结构

```text
.
|-- README.md
|-- README.en.md
|-- .gitignore
`-- skills/
    `-- spec-init/
        |-- SKILL.md
        |-- scripts/
        |-- references/
        |-- assets/
        `-- examples/
```

### 2. 项目初始化后的工作流

项目初始化后，会先形成 intake -> requirements -> design -> implementation plan -> tdd plan -> task breakdown 这一条可执行文档链，再进入编码阶段。

## 这个 skill 会产出什么

运行后，至少会生成或补齐：

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

而且这些不是纯空模板。

现在这套模板里已经包含：

- 写作边界提示
- 新手自检项
- 优先级和版本边界提示
- `FR-*` / `DES-*` / `TEST-*` / `T-*` 的追踪关系要求
- 一个最小完整示例项目

## 它适合什么场景

- 从 0 到 1 开一个新项目
- 你知道自己想做什么，但不知道该怎么整理需求和设计
- 你想用 spec-first / doc-first / tdd-first 启动项目
- 你要给团队或未来的自己留下一个可读、可追踪、可执行的项目入口

## 它不适合什么场景

- 临时写一个一次性脚本
- 只想快速起一个 demo，不关心文档和过程
- 已经有成熟项目，只是补一两份文档
- 当前任务其实是修 bug、补测试或做 code review

## 支持的宿主

| 宿主 | 推荐安装位置 | 显式调用方式 | 说明 |
|---|---|---|---|
| Claude Code | `~/.claude/skills/spec-init` | `/spec-init` | 支持更丰富的 frontmatter 和动态注入 |
| Codex | `.agents/skills/spec-init` | `$spec-init` 或技能选择器 | 当前已提供 `agents/openai.yaml` 作为展示与调用增强 |
| OpenCode | `~/.config/opencode/skills/spec-init` | `/spec-init` 或自动加载 | 同时兼容 `.claude/skills` 和 `.agents/skills` |

## 安装

### Claude Code

```bash
cp -R skills/spec-init ~/.claude/skills/spec-init
```

### Codex

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
```

仓库已经自带：

- `skills/spec-init/agents/openai.yaml`

它用于给 Codex 提供：

- 展示名称
- 简短描述
- 默认提示词
- 隐式调用策略

### OpenCode

```bash
cp -R skills/spec-init ~/.config/opencode/skills/spec-init
```

## 使用示例

不同宿主的显式调用语法不同，但意图是一致的。

示例：

```text
/spec-init my-app
/spec-init ./demo-service --type=api
/spec-init --here --type=web
$spec-init my-cli --type=cli
```

也可以直接自然语言触发：

- “帮我初始化一个新项目骨架”
- “先帮我建需求、设计和 TDD 文档模板”
- “我想做一个 API 项目，先别写代码，先把文档骨架建好”

## 项目类型

这个 skill 当前支持这些项目类型判断：

- `web`
- `api`
- `cli`
- `library`
- `service`

如果用户没明确说，skill 会根据场景推断，并把推断依据写进 `docs/00-project-intake.md`。

## 这套方法的关键不是模板，而是追踪关系

这套 skill 最重要的不是 `docs/` 文件数量，而是它会逼着项目形成一条完整闭环：

- `FR-*`: 需求是什么
- `DES-*`: 方案怎么满足需求
- `TEST-*`: 怎么证明需求真的被实现了
- `T-*`: 现在先做哪一个动作

推荐最少先建立一条完整链路：

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

没有这条链，文档很容易再次退化成“好看但无用的说明文件”。

## 示例项目

仓库里已经带了一个最小完整示例：

[`skills/spec-init/examples/demo-app/`](./skills/spec-init/examples/demo-app/)

这个示例不是空模板复制，而是一个真正填过内容的参考样本。它展示了：

- intake 怎么写
- requirements 怎么写
- design 怎么承接 requirements
- TDD plan 怎么映射需求
- task breakdown 怎么落成任务

## 仓库结构

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

## 当前状态

- 已有可运行的初始化脚本
- 已有 requirements / design / TDD / tasks 模板
- 已有最小完整示例项目
- 已有中英文 README
- 已有真实封面图
- 已有 `docs/` 多语言文档结构
- 已有 Codex `agents/openai.yaml` 适配文件

## 下一步计划

- 按项目类型输出更细分的模板差异
- 增加更多示例，例如 `cli-tool`、`api-service`
- 继续增强 Codex 元数据与宿主适配体验

## 许可说明

当前仓库采用 `PolyForm Noncommercial 1.0.0`。

这意味着：

- 允许学习、研究、个人项目和非商用使用
- 禁止商业用途
- 分发时必须附带许可证文本或对应链接

完整条款见仓库根目录 `LICENSE`。

如果你准备公开发布，建议下一步补：

- 仓库 topics
- release notes
- 示例截图或录屏
