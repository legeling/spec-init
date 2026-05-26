<div align="center">

# spec-init

<p>
  <strong>一个面向项目文档与 spec workflow 的 agent skill：用于持续整理 workflow、knowledge、changes、issues 和 archive。</strong>
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
    <td><strong>Project Docs</strong><br/>从 intake、requirements、design 到 verification、tasks 的完整项目文档流</td>
    <td><strong>Built-in Rules</strong><br/>澄清、设计、修 bug、变更治理、问题跟踪规则直接进项目</td>
    <td><strong>Traceability</strong><br/>从 `FR` 到 `T` 的可回溯工作链</td>
  </tr>
</table>

<img src="./docs/assets/images/spec-init-flow.svg" alt="spec-init workflow" width="100%">

<img src="./docs/assets/images/spec-init-poster.png" alt="spec-init poster" width="100%">

</div>

## 项目简介

`spec-init` 是一个放在 `skills/` 目录里的 agent skill，但它不是“目录初始化脚本”。

它的真正定位是：让 agent 帮用户做文档驱动开发，把一个模糊想法或一个已有项目，整理成一套可执行、可追踪、带规则、带拓扑的 spec：

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

核心目标：

- 帮开发者区分 workflow、knowledge、change workspace 和 records
- 把“文档驱动开发”从建议变成默认工作方式
- 在开始编码前把边界、方案、验证和任务关系写清楚
- 建立完整追踪链：`FR -> DES -> TEST -> T`
- 内置项目级规则，而不只是几个空模板
- 对关键疑点先向用户澄清，不允许开发者自行拍板
- 设计必须写清技术栈、架构方案、权衡和质量目标
- 修 bug 必须定位根因，不能靠猜测修复
- 测试必须显式进入 verification 计划，并覆盖白盒、性能、安全等相关质量要求

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

## 适用场景

- 新项目：把一句模糊想法整理成 intake、requirements、design、knowledge、verification、tasks
- 现有项目：先读代码和现有文档，再补齐缺失的 spec
- 新需求引入：同时更新 workflow、knowledge 和 `docs/changes/active/`
- bugfix：记录症状、根因、修复方案、回归测试和影响范围
- 版本发布：把本次新增、修复、破坏性变化写进 `docs/releases/`
- 长期维护：把阻塞项、技术债、已知风险放进 `docs/issues/`，把废弃文档放进 `docs/archive/`

这个仓库适合需要维护项目文档、长期真相、变更工作区和问题跟踪的 Agent Skills 工作流。

## 这个 skill 会产出什么

运行时，agent 会根据用户目标和项目现状，创建或更新这些 spec：

```text
docs/
docs/workflow/00-intake/README.md
docs/workflow/01-requirements/README.md
docs/workflow/02-design/README.md
docs/workflow/03-implementation/README.md
docs/workflow/04-verification/README.md
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

这些文件不应该是空模板，而应该是 agent 基于当前上下文写出的真实内容。当前 skill 还带有模板和脚本资源，但它们只是辅助，不是结果本身。

agent 产出的内容至少应包含：

- 文档边界提示与路由规则
- 自检项
- 优先级和版本边界提示
- `FR-*` / `DES-*` / `TEST-*` / `T-*` 的追踪要求
- 项目级开发规则目录 `docs/rules/`
- 关键疑点必须先问用户的澄清规则
- 根因修复和回归测试规则
- 白盒 / 性能 / 安全测试要求
- 前端项目的分辨率 / 颜色 / 字号 / 组件规范引导
- 后端项目的 API / 数据库 / migration / 命名约定引导
- 面向新手的项目类型决策向导与必问问题清单
- 可直接参考的示例答案、范围裁剪助手、常见错误示例
- 现有项目补文档时的现状归纳
- 对关键缺失信息的方案、选择、对比和建议
- 新需求、bugfix、版本发布时的 change workspace 入口
- 完整需求、完整设计、持续完善 spec 的工作闭环
- issue 跟踪、文档归档、废弃文档管理

更具体地说，它覆盖四层文档：

- workflow：`intake / requirements / design / implementation / verification / tasks`
- knowledge：`context / structure / behavior / reference`
- changes：`active / completed / legacy`
- records：`issues / releases / adr / archive / rules`

## 结构设计

这个 skill 现在不再把 SDD 文档直接平铺在 `docs/` 根目录，而是按语义层组织：

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
|   |   `-- README.md
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
    |-- issue-management-rules.md
    |-- document-routing-rules.md
    `-- definition-of-done.md
```

这样做的原因是：

- `workflow/` 让编号阶段目录不再和其他目录混排
- `knowledge/` 承载长期稳定真相，而不是把一切都塞进当前阶段文档
- `changes/` 承载单次变更工作区和历史演进
- `spec-init.topology.yml` 与 `document-routing-rules.md` 让语义和物理路径解耦
- `rules/` 可以把项目级规范内置进初始化结果
- `changes/` 和 `releases/` 可以把历史变化留痕下来
- `issues/` 和 `archive/` 可以让未解决问题和废弃文档都有去处
- 新成员更容易理解“先看哪一层，再做哪一层”

## 支持的安装目标

| 目标 | 默认路径 | 显式调用方式 | 说明 |
|---|---|---|---|
| 当前项目（默认） | `.agents/skills/spec-init` | `$spec-init` 或技能选择器 | 最适合直接随仓库一起管理，也兼容 OpenCode 的项目内技能目录 |
| Claude Code | `~/.claude/skills/spec-init` | `/spec-init` | 适合全局安装到 Claude Code |
| OpenCode | `~/.config/opencode/skills/spec-init` | `/spec-init` 或自动加载 | 适合全局安装到 OpenCode |

## 安装

推荐默认直接装到当前项目根目录。

在你的项目根目录执行：

```bash
npx --yes github:legeling/spec-init
```

或者：

```bash
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
```

默认会安装到当前目录下的 `.agents/skills/spec-init`。

如果你想直接安装到 Claude Code 或 OpenCode 的全局技能目录：

```bash
npx --yes github:legeling/spec-init --host claude
npx --yes github:legeling/spec-init --host opencode

curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host claude
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host opencode
```

如果你想安装到自定义目录：

```bash
npx --yes github:legeling/spec-init --dir ./tools/skills/spec-init
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --dir ./tools/skills/spec-init
```

仍然可以手动复制目录，但它现在只是备用方式：

```bash
cp -R skills/spec-init /path/to/repo/.agents/skills/spec-init
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

- “帮我把这个想法整理成 requirements、design 和 verification plan”
- “这是一个现成项目，帮我补 spec，先读代码再写文档”
- “我想做一个 API 项目，先别写代码，先把 spec 理清”
- “给我分析一下现有仓库还缺哪些文档和规则”

## 项目类型

当前支持这些项目类型：

- `web`
- `api`
- `cli`
- `library`
- `service`

如果用户没明确说，skill 会根据项目名和目录名做基础推断，并把推断依据写进 `docs/workflow/00-intake/README.md`。

## 输出语言

辅助模板资源支持：

- `--lang zh`
- `--lang en`

当前行为：

- 默认输出中文模板
- 传 `--lang en` 时输出英文模板
- `web` / `api` / `cli` 三类在中英文下都已有差异化模板

## 类型差异化

当前 `web` / `api` / `cli` 已提供差异化模板，重点体现在：

- `docs/workflow/01-requirements/README.md` 的用户故事和需求语境不同
- `docs/workflow/02-design/README.md` 的系统边界、模块职责和调用链不同
- `docs/workflow/04-verification/README.md` 的测试重点不同
- `docs/workflow/05-tasks/README.md` 的初始执行任务不同

## 内置规则

这个项目现在不只生成文档，还会生成项目级工程规范：

- `docs/rules/clarification-rules.md`
- `docs/rules/coding-standards.md`
- `docs/rules/bug-fix-rules.md`
- `docs/rules/testing-standards.md`
- `docs/rules/doc-sync-rules.md`
- `docs/rules/change-management-rules.md`
- `docs/rules/issue-management-rules.md`
- `docs/rules/definition-of-done.md`
- `docs/rules/document-routing-rules.md`

`AGENTS.md` 负责把规则固化为 agent 执行顺序，`docs/rules/` 负责把规则沉淀为项目内文档资产，`spec-init.topology.yml` 负责把语义路由到具体路径。

其中现在特别强化了 4 类规则：

1. 关键疑点必须先向用户确认，可以给方案和利弊，但不能自己直接定
2. 设计必须写技术栈、架构方案、权衡和质量目标，而不是只写最简单的做法
3. 修 bug 必须先定位根因，禁止凭猜测修复
4. 验证必须显式进入 verification 计划，并覆盖白盒、性能、安全等与当前版本相关的要求

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
- verification plan 怎么映射需求
- task breakdown 怎么落成任务
- knowledge / changes / releases / issues / archive 怎么分别承接长期真相、历史变化和长期维护
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

## 星标历史

[![Star History Chart](https://api.star-history.com/svg?repos=legeling/spec-init&type=Date)](https://www.star-history.com/#legeling/spec-init&Date)

## 贡献者

感谢所有参与这个项目的人。

[![Contributors](https://contrib.rocks/image?repo=legeling/spec-init)](https://github.com/legeling/spec-init/graphs/contributors)
