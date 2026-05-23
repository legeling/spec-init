# Task Breakdown: Demo App

> 更新时间：2026-05-20
>
> 任务必须可执行、可验证、可追踪。

## 任务编写规则

- 每个任务只做一件事
- 单个任务最好在半天到一天内完成
- 每个任务都要关联 requirement / design / test
- 没有关联关系的任务不要进入开发
- 任务描述要能直接执行，例如“实现 X 并补 Y 测试”，不要写成“完善体验”这种空话

## 任务模板

```text
- [ ] T-001 [任务描述]
  - Requirement: FR-001
  - Design: DES-001
  - Test: TEST-001
  - Output: [文档 / 规则 / 说明]
  - Depends on: [无或任务 ID]
```

## 初始任务建议

- [ ] T-001 补齐第一版 agent 驱动 spec 示例链路
  - Requirement: FR-001
  - Design: DES-001
  - Test: TEST-001
  - Output: 有内容的 intake / requirements / design / tdd / tasks 示例
  - Depends on: 无

- [ ] T-002 补关键缺失信息时的方案对比与推荐示例
  - Requirement: FR-002
  - Design: DES-002
  - Test: TEST-002
  - Output: requirements / design 中的方案对比说明
  - Depends on: T-001

- [ ] T-003 增加“现有项目补 spec”工作流的示例说明
  - Requirement: FR-003
  - Design: DES-001
  - Test: TEST-003
  - Output: 面向已有仓库的 spec 补齐说明
  - Depends on: T-002

- [ ] T-004 建立最小完整示例追踪链
  - Requirement: FR-004
  - Design: DES-003
  - Test: TEST-004
  - Output: 示例中的 `FR-001 -> DES-001 -> TEST-001 -> T-001`
  - Depends on: T-003

- [ ] T-005 为 spec 工作流补测试策略与回归检查
  - Requirement: FR-001, FR-003, FR-004
  - Design: DES-001, DES-003, DES-004
  - Test: TEST-001, TEST-003, TEST-004
  - Output: `docs/04-tdd/README.md`
  - Depends on: T-004

- [ ] T-006 校对 README、AGENTS、rules 和示例，确保定位一致
  - Requirement: FR-004
  - Design: DES-004
  - Test: TEST-004
  - Output: `docs/rules/`、README、AGENTS 与示例文档
  - Depends on: T-005

## 当前任务列表

[这个示例已经把初始任务建议转成了可执行任务列表]

## 任务自检

- 每个任务都能指出它服务于哪条需求
- 每个高优先级需求最终都能落到至少一个任务
- 没有脱离需求和设计的“游离任务”
- 第一批任务优先覆盖高风险和高不确定性部分
