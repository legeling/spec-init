# spec-init 文档总览

## 简介

`spec-init` 是一个用于启动 spec engineering 工作流的 skill。

它的重点不是“帮你生成空目录”，而是让项目从第一天开始就具备：

- intake 文档
- 需求文档
- 设计文档
- 实现计划
- verification 计划
- 任务拆解
- issue 跟踪
- 变更记录
- 发布记录
- 归档与废弃文档索引
- 项目规则目录
- 项目 README
- 项目级 AGENTS 规则

## 核心理念

- 先澄清问题，再开始设计
- 先明确验证方式，再开始大规模实现
- 文档之间必须可追踪，而不是孤立存在
- 任务生成后先做 analyze，一致后再实现
- 实现完成后做 converge，把代码现状、当前文档和变更历史重新对齐

## 阶段循环

```text
specify -> clarify -> plan -> tasks -> analyze -> implement -> converge
```

`spec-init` 借鉴这个节奏，但长期文档源仍然是 `docs/` 分层拓扑，不默认切换到 `specs/`。

## 最小追踪链

```text
FR-001 -> DES-001 -> TEST-001 -> T-001
```

## 仓库里的关键位置

- `skills/spec-init/SKILL.md`
- `skills/spec-init/scripts/spec-init.sh`
- `skills/spec-init/references/`
- `skills/spec-init/assets/templates/project/`
- `skills/spec-init/examples/demo-app/`

## 生成结构重点

- `docs/workflow/00-intake/README.md`
- `docs/workflow/01-requirements/README.md`
- `docs/workflow/02-design/README.md`
- `docs/workflow/03-implementation/README.md`
- `docs/workflow/04-verification/README.md`
- `docs/workflow/05-tasks/README.md`
- `docs/knowledge/`
- `docs/issues/README.md`
- `docs/changes/README.md`
- `docs/releases/README.md`
- `docs/archive/README.md`
- `docs/rules/`

## 相关文档

- `docs/zh/installation.md`
- `docs/zh/contributing.md`
- `docs/zh/issue-guidelines.md`
- `docs/zh/pr-guidelines.md`
