---
name: spec-init
description: 启动 SDD 工作流 / kick off a new project with stage-based SDD docs, project rules, README, and AGENTS scaffolding before implementation starts.
compatibility: Requires bash. Works best in Claude Code, Codex, OpenCode, and other Agent Skills compatible tools.
metadata:
  stage: beta
  language: zh-CN
  workflow: project-bootstrap
---

# /spec-init — SDD 项目启动器

这个 skill 用于把“我想做个项目”变成一套可执行的 SDD 起步结构，而不是只生成空文件夹。

目标：

- 初始化一个适合 Spec-Driven Development (SDD) + Test-Driven Development (TDD) 的项目骨架
- 生成分阶段的 `docs/`、`docs/rules/`、`README.md`、`AGENTS.md`、`src/`、`tests/`、`scripts/`
- 用模板帮助开发者区分“需求文档”和“设计文档”
- 在开始编码前，把项目目标、边界、方案、测试策略、任务清单和默认工程规则写清楚

## 何时使用

- 用户说“初始化项目”“从 0 到 1 搭个项目骨架”
- 用户想要 `README.md`、`AGENTS.md`、`docs/`、`rules/` 模板
- 用户不知道需求、设计、实现计划、测试计划的区别
- 用户想做 spec-first / doc-first / tdd-first 的起步流程

## 何时不要使用

- 用户只是想临时创建一个单文件脚本或一次性实验目录
- 用户已经有成熟项目结构，只是要补一两份文档
- 当前任务是修 bug、补测试、review 或重构，而不是初始化项目工作流

## 先理解文档边界

在生成任何文档前，先阅读 `references/doc-boundaries.md`，严格区分：

- `docs/00-intake/README.md`: 先澄清背景、用户、目标、非目标
- `docs/01-requirements/README.md`: 写 what / why / success，不写技术实现
- `docs/02-design/README.md`: 写 how / architecture / trade-offs，不重复产品目标
- `docs/03-implementation/README.md`: 写里程碑、先后顺序、依赖关系
- `docs/04-tdd/README.md`: 写如何用测试证明需求落地
- `docs/05-tasks/README.md`: 写可执行任务，并回链到需求/设计/测试
- `docs/rules/`: 写项目级编码、测试、文档同步和完成定义规则

如果用户是新手，再额外阅读 `references/example-idea-to-docs.md`，用最小例子帮助对方理解这些文档如何衔接。

## 核心原则

- 不要一上来就写代码，先把文档骨架和规则骨架补齐
- 不确定的内容写成 `[待确认]`，不要编造
- 缺少信息但不阻塞时，先生成模板并留下问题清单
- 对需求边界、技术栈、架构方向、数据模型、权限模型、测试覆盖策略存在关键疑点时，必须使用 `question` 工具向用户确认
- 使用 `question` 时，要给用户方案选择，并说明优点、代价、风险和推荐理由，不能替用户拍板
- 如果目标仓库已经有 `README.md` 或 `AGENTS.md`，优先增量更新，不要粗暴覆盖

## 项目类型提示

- `web`: 页面、后台界面、站点、控制台、前端产品
- `api`: HTTP API、BFF、后端接口服务、系统集成层
- `cli`: 命令行工具、开发辅助脚本、终端工作流
- `library`: SDK、可复用包、组件库、工具函数集
- `service`: worker、调度器、事件消费者、长期运行进程

如果用户没有明确说类型，就根据目标用户、交付物和使用方式推断，并把推断依据写进 `docs/00-intake/README.md`。

## 语言支持

- 默认输出中文模板
- 如果用户明确要求英文，或显式传入 `--lang en`，输出英文模板
- 当前脚本支持：`--lang zh` / `--lang en`

## 调用方式

不同宿主对 skill 的显式调用语法不同，例如可能是 `/spec-init`、`$spec-init` 或技能选择器。

核心输入意图是一致的：

- 初始化一个新项目
- 指定目标目录或项目名
- 可选指定项目类型，如 `web`、`api`、`cli`、`library`、`service`
- 可选指定输出语言，如 `zh`、`en`
- 可选允许覆盖已有模板文件

## 初始化完成的最小交付

在你认为初始化完成之前，至少确认以下结果已经出现：

- `docs/`、`docs/rules/`、`README.md`、`AGENTS.md`、`src/`、`tests/`、`scripts/` 已创建或补齐
- `docs/00-intake/README.md` 至少写清项目目标、目标用户、非目标、待确认问题
- `docs/01-requirements/README.md` 中至少有一组 `FR-*` 和 `AC-*`
- `docs/02-design/README.md` 中至少有一组 `DES-*`，并映射到 `FR-*`
- `docs/04-tdd/README.md` 中至少有一组 `TEST-*`，并映射到 `FR-*`
- `docs/05-tasks/README.md` 中至少有一组 `T-*`，并映射到 `FR-*` / `DES-*` / `TEST-*`
- `docs/rules/definition-of-done.md` 已存在
- 至少形成一条完整追踪链：`FR-001 -> DES-001 -> TEST-001 -> T-001`

## 执行指令

需求来源：

- 当前用户请求
- 如果运行环境支持参数注入，可额外参考传入参数

---

### Step 0: 判断初始化场景

1. 确定目标目录：
   - 有 `--here` → 当前目录
   - 有路径 → 使用该路径
   - 否则默认当前目录
2. 推断项目名：
   - 优先使用显式传入名称
   - 否则取目标目录名
3. 推断项目类型：
   - 优先使用用户明确给出的类型
   - 否则根据交付物和使用方式推断
   - 如果仍不确定，选择最接近的类型，并在 intake 文档里注明“当前推断”
4. 推断输出语言：
   - 优先使用用户明确要求的语言或显式参数
   - 否则默认中文
5. 检查仓库现状：
   - 新目录 / 空目录 → 走完整初始化
   - 已有项目 → 仅补齐缺失文档、规则目录与基础目录
6. 如果存在同名文件且会覆盖，只有这时再询问用户是否覆盖；否则默认保留原文件

### Step 1: 先做问题澄清，不先做方案

先收集或推断以下信息。如果信息不完整，不要阻塞，写进 `docs/00-intake/README.md` 的 `[待确认]` 区域：

- 这个项目解决什么问题
- 谁会使用它
- 为什么现在要做
- 成功标准是什么
- 明确不做什么
- 有哪些约束（时间、平台、合规、预算、性能）
- 当前假设里最容易出错的点是什么

如果用户信息很少，也不要停在“需要更多信息”。先把当前已知内容整理为 intake，并把缺失项写成 `[待确认]`。

### Step 2: 创建目录骨架

优先使用本 skill 自带脚本：

```bash
bash "<skill-root>/scripts/spec-init.sh" [目标路径] --name "[项目名]" --type "[项目类型]" --lang "[输出语言]"
```

说明：

- `scripts/spec-init.sh`、`references/`、`assets/templates/project/` 都是当前 skill 自带资源
- 某些宿主会给出 skill 根目录变量或自动路径注入，例如 Claude 风格的 `${CLAUDE_SKILL_DIR}`
- 某些宿主不会，这时以当前 `SKILL.md` 所在目录作为 `<skill-root>`
- 如果宿主不能直接执行 skill 内脚本，就手动按以下结构创建：

```text
docs/
docs/00-intake/README.md
docs/01-requirements/README.md
docs/02-design/README.md
docs/03-implementation/README.md
docs/04-tdd/README.md
docs/05-tasks/README.md
docs/adr/0000-record-template.md
docs/rules/README.md
docs/rules/coding-standards.md
docs/rules/testing-standards.md
docs/rules/doc-sync-rules.md
docs/rules/definition-of-done.md
src/
tests/
scripts/
README.md
AGENTS.md
```

### Step 3: 按顺序填充文档

严格按下面顺序工作，不要跳步：

1. `docs/00-intake/README.md`
2. `docs/01-requirements/README.md`
3. `docs/02-design/README.md`
4. `docs/03-implementation/README.md`
5. `docs/04-tdd/README.md`
6. `docs/05-tasks/README.md`
7. `docs/rules/`

不要只留下空模板。至少把用户已经说清楚的信息写进去；只有真正缺失的地方才保留 `[待确认]`。

#### 3.1 Intake 文档

用于把“脑子里的想法”变成可讨论的问题陈述。重点写：

- 业务背景
- 用户画像
- 典型使用场景
- 成功标准
- 非目标
- 待确认问题

#### 3.2 Requirements 文档

要求只回答“做什么”和“为什么做”：

- 用户故事
- 功能需求 `FR-*`
- 非功能需求 `NFR-*`
- 验收标准 `AC-*`
- 范围外内容
- 风险假设

不要在这里写：

- 用什么框架
- 用什么数据库
- API 路径怎么命名
- 表结构怎么设计
- 组件怎么拆

#### 3.3 Design 文档

要求只回答“怎么实现”：

- 系统边界和架构图
- 模块职责
- 数据模型
- 接口契约
- 状态流 / 调用链
- 技术选型与权衡
- 对需求条目的映射
- 架构质量目标（可维护性、性能、安全、可测试性）

不要在这里重复写需求背景，也不要把任务拆解直接塞进设计文档。

补充要求：

- 设计不能只写“最简单可跑”的做法，而要写“为什么这个栈和架构适合当前需求”。
- 对存在多个合理方案的关键设计，必须列出候选方案和利弊，并确认是否已获用户确认。

#### 3.4 Implementation Plan 文档

把设计变成交付顺序：

- 里程碑
- 依赖关系
- 高风险优先项
- 每个阶段的可验收产出
- 回滚 / 降级策略

#### 3.5 TDD Plan 文档

把“完成定义”前置：

- 哪些需求需要白盒单元测试
- 哪些需求需要集成测试
- 哪些用户流程需要端到端测试
- 哪些需求需要性能测试或安全测试
- 红 / 绿 / 重构的第一轮从哪里开始
- 回归测试如何覆盖高风险路径

要求至少建立一个“需求 ID → 测试方式”的映射表。

补充要求：

- 不要先写实现，再回头“补点测试”。
- 白盒、性能、安全测试只要与当前版本相关，就应该进入计划，而不是默认跳过。

#### 3.6 Task Breakdown 文档

把计划变成能执行的任务：

- 每个任务都要有 ID
- 每个任务都要能在半天到一天内完成
- 每个任务都要关联 requirement / design / test
- 任务描述必须是动作，不是愿景

#### 3.7 Rules 文档

把默认工程规则沉淀进项目：

- 需求澄清与用户确认规则
- 编码规范
- bug 修复规则
- 测试规范
- 文档同步规则
- Definition of Done

规则应该服务项目执行，而不是变成空泛口号。

### Step 4: 建立追踪关系

在初始化结束前，显式检查以下映射已经存在：

- `FR-* -> AC-*`
- `FR-* -> DES-*`
- `FR-* -> TEST-*`
- `FR-* / DES-* / TEST-* -> T-*`

如果任何链条断掉，就补到对应文档，而不是把缺口留给后续。

### Step 5: 生成 README.md

`README.md` 至少包含：

- 项目一句话说明
- 项目目标
- 文档导航
- 规则导航
- 目录结构
- 推荐开发流程
- 快速开始占位
- 当前状态与下一步

### Step 6: 生成 AGENTS.md

`AGENTS.md` 用来固化这个项目的工作规则，至少包含：

- 先需求、再设计、再实现的顺序
- 文档边界
- rules 目录的优先级说明
- TDD 要求
- 关联变更同步要求（代码、测试、文档一起更新）
- Definition of Done
- 不确定信息写 `[待确认]`，禁止编造

### Step 7: 输出初始化报告

最终汇报时说明：

- 创建 / 更新了哪些目录和文件
- 还有哪些 `[待确认]` 信息
- 建议开发者先从哪一份文档开始补齐
- 需求 / 设计 / 实现计划 / 测试计划 / rules 之间如何衔接

## 输出要求

最终回复时，优先说明：

- 初始化到了哪个目录
- 创建或更新了哪些关键文件
- 当前推断的项目类型是什么，以及依据是什么
- 输出语言是什么
- 已经形成了哪几条 `FR -> DES -> TEST -> T` 追踪链
- 还有哪些 `[待确认]` 需要用户补充

## 质量要求

- 任何模板都要可直接编辑，而不是只有标题
- 每份文档都要告诉用户“该写什么”和“不该写什么”
- 不要生成过度企业化的空话
- 默认中文；如果用户明确要求英文，再切换语言
- 结构要轻量，但必须有 traceability：需求 → 设计 → 测试 → 任务
- `docs/rules/` 必须能约束实现，而不是装饰目录
- 对关键疑点的确认、根因修复和严格 TDD 要在模板里显式可见

## 参考资源

本 skill 自带以下文件：

- `references/doc-boundaries.md`: 解释需求、设计、实现计划、测试计划、任务和规则的边界
- `references/example-idea-to-docs.md`: 用一个最小例子演示想法如何落到文档
- `assets/templates/project/`: 项目初始化模板
- `scripts/spec-init.sh`: 一键生成目录与基础文件
- `examples/demo-app/`: 生成后的示例项目骨架

使用这个 skill 时，优先复用这些资源，不要从零发明另一套格式。
