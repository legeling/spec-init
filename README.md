<div align="center">

# spec-init

<p>
  <strong>一个偏向 SDD 的项目启动 skill：先落文档结构、开发规则和测试约束，再进入实现。</strong>
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

<table>
  <tr>
    <td><strong>Stage-based SDD</strong><br/>从 intake 到 tasks 的目录化文档流</td>
    <td><strong>Built-in Rules</strong><br/>澄清、设计、修 bug、TDD 规则直接进项目</td>
    <td><strong>Traceability</strong><br/>从 `FR` 到 `T` 的可回溯工作链</td>
  </tr>
</table>

<img src="./docs/assets/images/spec-init-flow.svg" alt="spec-init workflow" width="100%">

<img src="./docs/assets/images/spec-init-poster.png" alt="spec-init poster" width="100%">

</div>

## 项目简介

`spec-init` 是一个放在 `skills/` 目录里的项目启动 skill，但它更准确的定位是一套轻量的 SDD（Spec-Driven Development）启动系统。

它不是“帮你多建几个目录”的脚手架，而是把一个模糊的项目想法先落成一套可执行、可追踪、带规则的工程入口：

- `docs/00-intake/README.md`
- `docs/01-requirements/README.md`
- `docs/02-design/README.md`
- `docs/03-implementation/README.md`
- `docs/04-tdd/README.md`
- `docs/05-tasks/README.md`
- `docs/rules/README.md`
- `README.md`
- `AGENTS.md`

核心目标：

- 帮开发者区分需求、设计、实施计划、测试计划和任务拆解
- 把“文档驱动开发”从建议变成默认工作方式
- 在开始编码前把边界、方案、验证和任务关系写清楚
- 建立完整追踪链：`FR -> DES -> TEST -> T`
- 内置项目级规则，而不只是几个空模板
- 对关键疑点先向用户澄清，不允许开发者自行拍板
- 设计必须写清技术栈、架构方案、权衡和质量目标
- 修 bug 必须定位根因，不能靠猜测修复
- 测试必须严格走 TDD，并覆盖白盒、性能、安全等相关质量要求

## 为什么做这个 skill

很多项目不是死在技术上，而是死在一开始没有把这些问题说清楚：

- 到底要做什么
- 为什么现在做
- 哪些内容明确不做
- 设计如何承接需求
- 测试如何证明需求被实现
- 任务如何从需求和设计拆出来
- 团队默认遵循什么工程规则

常见结果是：

- 需求和设计混写
- 实施计划和任务清单混写
- 测试永远“后面补”
- README 只剩空话
- 规则只存在聊天记录里，没有沉淀到项目内

这个 skill 的定位，就是把这些坑在项目启动阶段前置解决。

## 这个 skill 会产出什么

运行后，至少会生成或补齐：

```text
docs/
docs/00-intake/README.md
docs/01-requirements/README.md
docs/02-design/README.md
docs/03-implementation/README.md
docs/04-tdd/README.md
docs/05-tasks/README.md
docs/rules/README.md
docs/rules/clarification-rules.md
docs/rules/coding-standards.md
docs/rules/bug-fix-rules.md
docs/rules/testing-standards.md
docs/rules/doc-sync-rules.md
docs/rules/definition-of-done.md
docs/adr/0000-record-template.md
src/
tests/
scripts/
README.md
AGENTS.md
```

这些不是纯空模板。现在模板里已经包含：

- 文档边界提示
- 自检项
- 优先级和版本边界提示
- `FR-*` / `DES-*` / `TEST-*` / `T-*` 的追踪要求
- 项目级开发规则目录 `docs/rules/`
- 关键疑点必须先问用户的澄清规则
- 根因修复和回归测试规则
- 白盒 / 性能 / 安全测试要求
- 最小完整示例项目

## 结构设计

这个 skill 现在不再把 SDD 文档直接平铺在 `docs/` 根目录，而是按阶段目录组织：

```text
docs/
|-- 00-intake/
|   `-- README.md
|-- 01-requirements/
|   `-- README.md
|-- 02-design/
|   `-- README.md
|-- 03-implementation/
|   `-- README.md
|-- 04-tdd/
|   `-- README.md
|-- 05-tasks/
|   `-- README.md
|-- adr/
|   `-- 0000-record-template.md
`-- rules/
    |-- README.md
    |-- clarification-rules.md
    |-- coding-standards.md
    |-- bug-fix-rules.md
    |-- testing-standards.md
    |-- doc-sync-rules.md
    `-- definition-of-done.md
```

这样做的原因是：

- 更符合 SDD 的阶段语义
- 后续更容易在每个阶段扩展子文档
- `rules/` 可以把项目级规范内置进初始化结果
- 新成员更容易理解“先看哪一层，再做哪一层”

## 支持的宿主

| 宿主 | 推荐安装位置 | 显式调用方式 | 说明 |
|---|---|---|---|
| Claude Code | `~/.claude/skills/spec-init` | `/spec-init` | 支持更丰富的 frontmatter 和动态注入 |
| Codex | `.agents/skills/spec-init` | `$spec-init` 或技能选择器 | 兼容 Agent Skills 目录结构 |
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

### OpenCode

```bash
cp -R skills/spec-init ~/.config/opencode/skills/spec-init
```

## 使用示例

不同宿主的显式调用语法不同，但意图一致。

示例：

```text
/spec-init my-app
/spec-init ./demo-service --type=api
/spec-init --here --type=web --lang=en
$spec-init my-cli --type=cli
```

也可以自然语言触发：

- “帮我初始化一个新项目骨架”
- “先帮我建 SDD 文档和开发规则”
- “我想做一个 API 项目，先别写代码，先把文档骨架建好”

## 项目类型

当前支持这些项目类型：

- `web`
- `api`
- `cli`
- `library`
- `service`

如果用户没明确说，skill 会根据项目名和目录名做基础推断，并把推断依据写进 `docs/00-intake/README.md`。

## 输出语言

初始化脚本现在支持：

- `--lang zh`
- `--lang en`

当前行为：

- 默认输出中文模板
- 传 `--lang en` 时输出英文模板
- `web` / `api` / `cli` 三类在中英文下都已有差异化模板

## 类型差异化

当前 `web` / `api` / `cli` 已提供差异化模板，重点体现在：

- `docs/01-requirements/README.md` 的用户故事和需求语境不同
- `docs/02-design/README.md` 的系统边界、模块职责和调用链不同
- `docs/04-tdd/README.md` 的测试重点不同
- `docs/05-tasks/README.md` 的初始执行任务不同

## 内置规则

这个项目现在不只生成文档，还会生成项目级工程规范：

- `docs/rules/clarification-rules.md`
- `docs/rules/coding-standards.md`
- `docs/rules/bug-fix-rules.md`
- `docs/rules/testing-standards.md`
- `docs/rules/doc-sync-rules.md`
- `docs/rules/definition-of-done.md`

`AGENTS.md` 负责把规则固化为 agent 执行顺序，`docs/rules/` 负责把规则沉淀为项目内文档资产。

其中现在特别强化了 4 类规则：

1. 关键疑点必须先向用户确认，可以给方案和利弊，但不能自己直接定
2. 设计必须写技术栈、架构方案、权衡和质量目标，而不是只写最简单的做法
3. 修 bug 必须先定位根因，禁止凭猜测修复
4. 测试必须严格走 TDD，并覆盖白盒、性能、安全等与当前版本相关的要求

## 这套方法的关键不是模板，而是追踪关系

这套 skill 最重要的不是文档数量，而是它会逼着项目形成完整闭环：

- `FR-*`: 需求是什么
- `DES-*`: 方案怎么满足需求
- `TEST-*`: 怎么证明需求真的被实现了
- `T-*`: 现在先做哪一个动作

推荐最少先建立一条完整链路：

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

没有这条链，文档很容易退化成“好看但无用的说明文件”。

## 示例项目

仓库里已经带了一个最小完整示例：

[`skills/spec-init/examples/demo-app/`](./skills/spec-init/examples/demo-app/)

这个示例展示了：

- intake 怎么写
- requirements 怎么写
- design 怎么承接 requirements
- TDD plan 怎么映射需求
- task breakdown 怎么落成任务
- rules 怎么作为项目内约束沉淀下来

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
- 已有 Bash smoke tests 和 GitHub Actions CI
- 已支持目录化 SDD 结构输出
- 已支持 `--lang zh|en`
- 已有 `web` / `api` / `cli` 三类差异化模板
- 已内置 `docs/rules/` 规则目录
- 已有最小完整示例项目
- 已有中英文 README
- 已有真实封面图

## 下一步计划

- 为 `service` / `library` 增加差异化模板
- 增加更多示例，例如 `cli-tool`、`api-service`
- 继续增强宿主适配与发布体验

## 许可说明

当前仓库采用 `PolyForm Noncommercial 1.0.0`。

这意味着：

- 允许学习、研究、个人项目和非商用使用
- 禁止商业用途
- 分发时必须附带许可证文本或对应链接

完整条款见仓库根目录 `LICENSE`。
