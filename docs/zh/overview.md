# spec-init 文档总览

## 简介

`spec-init` 是一个用于启动 spec engineering 工作流的 skill。

它的重点不是“帮你生成空目录”，而是让项目从第一天开始就具备：

- 需求文档
- 设计文档
- 实现计划
- TDD 计划
- 任务拆解
- 项目 README
- 项目级 AGENTS 规则

## 核心理念

- 先澄清问题，再开始设计
- 先明确验证方式，再开始大规模实现
- 文档之间必须可追踪，而不是孤立存在

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

## 相关文档

- `docs/zh/installation.md`
- `docs/zh/contributing.md`
- `docs/zh/issue-guidelines.md`
- `docs/zh/pr-guidelines.md`
