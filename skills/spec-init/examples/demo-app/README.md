# Demo App

> 项目类型：web
>
> 初始化日期：2026-05-20

## 项目简介

Demo App 展示一个由 agent 驱动的文档开发流程：先理解项目目标或现有代码，再整理 intake、requirements、design、tdd、tasks 和工程规则，而不是只创建模板。

## 项目目标

- 展示 spec-init skill 如何帮助用户把想法或现有项目整理成 spec
- 演示需求、设计、测试、任务和项目规则之间的追踪关系
- 展示 agent 如何在信息不足时给出方案、对比、建议和待确认项

## 开发方式

本项目采用 Spec-Driven Development (SDD) + Test-Driven Development (TDD)。

推荐顺序：

1. 填写 `docs/00-intake/README.md`
2. 明确 `docs/01-requirements/README.md`
3. 输出 `docs/02-design/README.md`
4. 拆分 `docs/03-implementation/README.md`
5. 制定 `docs/04-tdd/README.md`
6. 生成 `docs/05-tasks/README.md`
7. 阅读 `docs/rules/README.md`
8. 开始编码，并同步更新测试和文档

## 文档导航

- `docs/00-intake/README.md`: 项目背景、用户、目标、非目标
- `docs/01-requirements/README.md`: 需求定义，只写 what / why
- `docs/02-design/README.md`: 技术设计，只写 how
- `docs/03-implementation/README.md`: 里程碑、顺序、依赖
- `docs/04-tdd/README.md`: 测试策略与需求-测试映射
- `docs/05-tasks/README.md`: 可执行任务清单
- `docs/issues/README.md`: 未解决问题、阻塞项、风险与技术债
- `docs/changes/README.md`: 新需求、bugfix、重构记录
- `docs/releases/README.md`: 版本发布记录
- `docs/archive/README.md`: 归档和废弃文档索引
- `docs/rules/README.md`: 编码、测试、文档同步和完成定义规则
- `docs/adr/`: 关键架构决策记录

## 追踪关系

本示例至少包含一条完整追踪链：

- `FR-001`: agent 能把模糊需求整理成结构化 spec
- `DES-001`: 文档工作流负责把 intake、requirements、design、tdd 和 tasks 串起来
- `TEST-001`: 能验证 spec 是否形成完整追踪链与关键待确认项
- `T-001`: 先补齐第一条 `FR -> DES -> TEST -> T` 链路

## 目录结构

```text
.
|-- AGENTS.md
|-- README.md
|-- docs
|   |-- 00-intake
|   |   `-- README.md
|   |-- 01-requirements
|   |   `-- README.md
|   |-- 02-design
|   |   `-- README.md
|   |-- 03-implementation
|   |   `-- README.md
|   |-- 04-tdd
|   |   `-- README.md
|   |-- 05-tasks
|   |   `-- README.md
|   |-- issues
|   |   `-- README.md
|   |-- changes
|   |   |-- README.md
|   |   |-- BUG-0001-template.md
|   |   `-- CR-0001-template.md
|   |-- releases
|   |   |-- README.md
|   |   `-- v0.1.0-template.md
|   |-- archive
|   |   `-- README.md
|   |-- adr
|   |   `-- 0000-record-template.md
|   `-- rules
|       |-- README.md
|       |-- clarification-rules.md
|       |-- coding-standards.md
|       |-- bug-fix-rules.md
|       |-- testing-standards.md
|       |-- doc-sync-rules.md
|       |-- change-management-rules.md
|       |-- issue-management-rules.md
|       `-- definition-of-done.md
|-- scripts
|   `-- .gitkeep
|-- src
|   `-- .gitkeep
`-- tests
    `-- .gitkeep
```

## 快速开始

补充项目实际命令：

```bash
# 安装依赖
[命令]

# 启动开发环境
[命令]

# 运行测试
[命令]

# 构建产物
[命令]
```

## 当前状态

- 已完成：目录化 SDD 文档结构、规则目录、示例文档
- 已完成：最小追踪链示例
- 已知风险：`service` / `library` 场景的 agent 指导仍不够细

## 下一步

1. 完成 `docs/00-intake/README.md` 中的待确认项
2. 把关键目标转换成 `FR-*` / `NFR-*` / `AC-*`
3. 在 `docs/02-design/README.md` 中明确第一版技术方案
4. 在 `docs/04-tdd/README.md` 中定义首批红灯测试
5. 当引入新需求或 bugfix 时，同步记录到 `docs/changes/`
6. 当有未解决问题或废弃文档时，同步更新 `docs/issues/` 和 `docs/archive/`
