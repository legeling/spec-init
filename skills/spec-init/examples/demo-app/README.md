# Demo App

> 项目类型：web
>
> 初始化日期：2026-05-20

## 项目简介

Demo App 展示一个文档驱动、测试驱动、规则驱动的 SDD 项目启动流程，帮助开发者在编码前先明确需求、设计、测试、任务和工程规则之间的关系。

## 项目目标

- 展示 spec-init skill 在新版目录化 SDD 结构下的最小完整产物
- 演示需求、设计、测试、任务和项目规则之间的追踪关系
- 让新手看到“文档结构和默认工程规范如何一起落地”的实际样子

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
- `docs/rules/README.md`: 编码、测试、文档同步和完成定义规则
- `docs/adr/`: 关键架构决策记录

## 追踪关系

本示例至少包含一条完整追踪链：

- `FR-001`: 生成目录化 SDD 项目骨架
- `DES-001`: Scaffold Generator 负责生成阶段目录、规则目录和基础文件
- `TEST-001`: 运行初始化后应生成全部核心文件与规则文件
- `T-001`: 实现项目骨架生成并验证核心文件输出

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
|   |-- adr
|   |   `-- 0000-record-template.md
|   `-- rules
|       |-- README.md
|       |-- clarification-rules.md
|       |-- coding-standards.md
|       |-- bug-fix-rules.md
|       |-- testing-standards.md
|       |-- doc-sync-rules.md
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

- 已完成：目录化 SDD 骨架、规则目录、示例文档
- 已完成：最小追踪链示例
- 已知风险：`service` / `library` 仍未拆出专门模板

## 下一步

1. 完成 `docs/00-intake/README.md` 中的待确认项
2. 把关键目标转换成 `FR-*` / `NFR-*` / `AC-*`
3. 在 `docs/02-design/README.md` 中明确第一版技术方案
4. 在 `docs/04-tdd/README.md` 中定义首批红灯测试
