# Change Management Rules

## 基本原则

- 当前状态文档和历史变更文档必须一起维护。
- 新需求、bugfix、重构和发布，不允许只改代码不留文档痕迹。

## 记录规则

- 新需求：更新当前文档，并补 `docs/changes/CR-xxxx-*.md`
- bugfix：更新当前文档，并补 `docs/changes/BUG-xxxx-*.md`
- 架构变化：更新 `docs/02-design/README.md` 并补 `docs/adr/`
- 发布：补 `docs/releases/vx.y.z.md`
