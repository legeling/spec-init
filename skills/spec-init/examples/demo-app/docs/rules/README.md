# Project Rules: demo-app

> 更新时间：2026-05-26

这些规则用于把文档驱动开发从“建议”变成“默认工作方式”。

## 规则导航

- `docs/rules/clarification-rules.md`: 需求澄清与用户确认规则
- `docs/rules/coding-standards.md`: 编码规范与边界
- `docs/rules/bug-fix-rules.md`: bug 定位、根因修复与回归要求
- `docs/rules/testing-standards.md`: 测试策略与回归要求
- `docs/rules/doc-sync-rules.md`: 文档与代码同步规则
- `docs/rules/change-management-rules.md`: 新需求、bugfix、发布的记录规则
- `docs/rules/commit-rules.md`: 提交格式、文档关联、范围和测试状态规则
- `docs/rules/document-archive-rules.md`: 记录型文档编号、索引和按年月归档规则
- `docs/rules/issue-management-rules.md`: issue 跟踪与废弃文档归档规则
- `docs/rules/definition-of-done.md`: 完成定义检查清单
- `docs/rules/document-routing-rules.md`: 文档语义到目录路径的路由规则

## 使用建议

1. 在开始编码前先阅读本目录
2. 遇到取舍时，先看规则是否已有默认答案
3. 在实现前执行 analyze 检查，确认需求、设计、验证、任务和 change workspace 没有冲突
4. 在实现后执行 converge 检查，回写当前文档、长期真相和变更历史
5. 提交前阅读 `docs/rules/commit-rules.md`，确保提交正文包含关联、范围、影响和测试状态
6. 如果项目演进出新的团队规则，在这个目录增补，不要只散落在聊天或 PR 评论中
