# Change Management Rules

## 基本原则

- 当前状态文档和历史变更文档必须同时维护。
- 新需求、bugfix、重构、发布，不允许只改代码不留文档痕迹。

## 记录规则

- 新需求或需求变化：更新 workflow 与 knowledge 中受影响内容，并在 `docs/changes/active/<change-key>/` 建立工作区
- bug 修复：更新受影响文档，并在 `docs/changes/active/<change-key>/` 记录症状、根因、验证和影响范围
- 架构或关键技术变化：更新 `docs/workflow/02-design/README.md`、`docs/knowledge/structure/README.md`，并补 `docs/adr/`
- 版本发布：新增或更新 `docs/releases/vx.y.z.md`
- 实现前：完成 analyze 检查，确认 `FR / DES / TEST / T` 和 change workspace 没有冲突
- 实现后：完成 converge 回写，确认代码真实行为、验证结果和文档一致
- 变更完成后：把工作区移动到 `docs/changes/completed/`
- 提交变更时：遵循 `docs/rules/commit-rules.md`，在提交正文中关联 Issue、change workspace、需求 / 设计 / 验证文档，并记录修改范围、影响范围和测试状态

## 最低要求

- 每条 change 工作区必须写清背景、影响范围、同步文档和待确认项
- 每条 bug 记录必须写清症状、根因、修复方案和回归要求
- 每个 release 记录必须写清新增、修复、破坏性变化和已知问题
- 每轮实现前必须能说明 analyze 结论；每轮交付前必须能说明 converge 结果
- 每次提交必须只绑定一个主要改动点，并能回链到对应文档记录
