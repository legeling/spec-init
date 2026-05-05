# Demo App

> 项目类型：web
>
> 初始化日期：2026-04-29

## 项目简介

Demo App 展示一个文档驱动、测试驱动的 spec engineering 项目启动流程，帮助开发者在编码前先明确需求、设计、测试和任务之间的关系。

## 项目目标

- 展示 spec-init skill 的最小完整产物
- 演示需求、设计、测试、任务之间的追踪关系
- 让新手看到“需求和设计如何分开写”的实际样子

## 开发方式

本项目采用 Spec-Driven Development (SDD) + Test-Driven Development (TDD)。

推荐顺序：

1. 填写 `docs/00-project-intake.md`
2. 明确 `docs/01-requirements.md`
3. 输出 `docs/02-design.md`
4. 拆分 `docs/03-implementation-plan.md`
5. 制定 `docs/04-tdd-plan.md`
6. 生成 `docs/05-task-breakdown.md`
7. 开始编码，并同步更新测试和文档

## 文档导航

- `docs/00-project-intake.md`: 项目背景、用户、目标、非目标
- `docs/01-requirements.md`: 需求定义，只写 what / why
- `docs/02-design.md`: 技术设计，只写 how
- `docs/03-implementation-plan.md`: 里程碑、顺序、依赖
- `docs/04-tdd-plan.md`: 测试策略与需求-测试映射
- `docs/05-task-breakdown.md`: 可执行任务清单
- `docs/adr/`: 关键架构决策记录

## 追踪关系

本示例至少包含一条完整追踪链：

- `FR-001`: 生成项目骨架
- `DES-001`: Scaffold Generator 负责生成目录与基础文件
- `TEST-001`: 运行初始化后应生成全部核心文件
- `T-001`: 实现项目骨架生成并验证核心文件输出

## 目录结构

```text
.
|-- AGENTS.md
|-- README.md
|-- docs
|   |-- 00-project-intake.md
|   |-- 01-requirements.md
|   |-- 02-design.md
|   |-- 03-implementation-plan.md
|   |-- 04-tdd-plan.md
|   |-- 05-task-breakdown.md
|   `-- adr
|       `-- 0000-record-template.md
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

- 已完成：项目骨架、文档模板、示例文档
- 已完成：最小追踪链示例
- 已知风险：不同项目类型的模板定制仍然较少

## 下一步

1. 完成 `docs/00-project-intake.md` 中的待确认项
2. 把关键目标转换成 `FR-*` / `NFR-*` / `AC-*`
3. 在 `docs/02-design.md` 中明确第一版技术方案
4. 在 `docs/04-tdd-plan.md` 中定义首批红灯测试
