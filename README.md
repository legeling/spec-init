# spec-init

[English](README.en.md)

让项目保留足以指导开发的有效约定，按风险控制文档投入。

普通修复可以不改文档；确认需求变化就原位替换权威文档中的旧要求；高风险变化保留必要设计与验证。用户要求实施时，Skill 会推进实现，不以补齐文档体系代替开发。

## 默认怎么工作

1. 定向读取项目指令、相关代码、测试和有效文档。
2. 明确要改成什么、影响什么、如何验证；关键决策清楚就进入实施。
3. 完成源码、测试和必要文档批次后，统一验证并校准有效约定。

不要求每次新建 change，不强制 `FR → DES → TEST → T` 编号链，不扫描全项目文档补旧账。明确要求完整设计或确有高风险时，才展开相应内容。

## 什么需要留档

| 内容 | 做法 |
|---|---|
| 最新确认的需求、边界、验收 | 每主题一份权威文档，确认变更立即原位替换旧要求 |
| 实施动作、进度、阻塞 | 按需保留活动计划并引用权威需求，不重复定义 |
| 关键取舍和失败恢复办法 | 写在相关文档；需要独立维护时才建立决策记录 |
| 历史过程 | 普通编辑使用 Git；旧记录仅用于追溯，不作为当前待办 |

未确认提议不覆盖需求；已确认的新需求立即更新到唯一真源，尚未完成的实现标为“待实施”。相关现行文档（包括 AGENTS）里的旧约定同步纠正或改为引用，不能只追加新说法。历史明确失效，不提供当前待办。

现有目录可以继续使用。新项目需要独立文档时，可使用 `docs/specs/<topic>.md` 和 `docs/plans/<topic>.md`，无需提前创建空文件。

## 安装

在目标项目根目录执行：

```bash
npx --yes github:legeling/spec-init
```

或使用 Bash 安装器：

```bash
curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
```

默认安装到项目的 `.agents/skills/spec-init`。`--host codex` 是项目目录的别名；`--host claude` 安装到 `~/.claude/skills/spec-init`，`--host opencode` 安装到 `~/.config/opencode/skills/spec-init`。通过 `--dir PATH` 可指定目录。

这些 GitHub 命令安装远端版本，不包含尚未推送的本地修改。安装本地工作区版本：

```bash
node bin/spec-init.js --dir /absolute/path/to/project/.agents/skills/spec-init
```

安装器的 `--force` 只替换已有的完整技能安装，拒绝空参数、不相关目录、符号链接路径和源目标重叠。新版先复制并校验，再替换；失败恢复旧版，恢复失败会保留恢复目录并报告路径。成功更新会替换个人定制，更新前先备份。安装 Skill 不会自动改写目标项目的 AGENTS 或文档。

## 使用

```text
$spec-init 整理这个功能的有效约定，并继续完成实现和验证。
$spec-init 更新导出需求：沿用现有功能文档，把旧计划改成新的范围。
$spec-init 先为这次数据迁移完成设计，包括兼容、失败恢复与验证。
$spec-init 将这个项目的旧文档流程精简，保留项目特有规则。
```

普通代码修改不自动启动完整文档流程。自动技能选择仍保持启用；触发说明聚焦于明确的规范与文档维护需求。

## 可选骨架

只有需要空项目文档骨架时才运行：

```bash
bash skills/spec-init/scripts/spec-init.sh ./demo --type api --lang zh
```

默认仅生成三个文件：`README.md`、`AGENTS.md`、`docs/README.md`。不生成规则大全、示例变更、追踪矩阵、topology 或源码目录。脚本不理解业务，生成完成不等于规范完成。

保留 `--here`、`--name`、`--type`、`--lang` 和 `--force`；项目类型支持 web、api、cli、library、service，语言支持 zh、en。类型用于项目描述，不再生成类型专属的大套模板。未指定类型时按名称提示推断，不能代替实际项目调查。

默认保留已有文件。骨架脚本的 `--force` 仅备份并替换其三个目标文件，不删除旧目录。备份在用户状态目录的 `spec-init/backups` 下，包含恢复说明；可用 `SPEC_INIT_BACKUP_ROOT` 指定项目外路径。输出提供备份位置，项目内不会留下旧规则副本。现有项目的规则迁移应定向编辑，不使用强制骨架覆盖代替合并。

## 升级与回滚

旧的 workflow、knowledge、changes 路径无需一次性迁移。优先修改旧流程门禁、明确有效文档入口、撤下过期待办，其他历史按需整理。不能忽略仍然有效的项目约束。

详见 [迁移说明](skills/spec-init/references/doc-boundaries.md) 和 [本次精简方案与验收](docs/optimization-plan.md)。回滚时只恢复本次变动，避免覆盖后续用户修改。

## 维护与验证

```bash
npm run lint
npm test
```

脚本测试验证生成范围、原内容保护、参数错误和备份行为；场景验收检查普通修复、功能调整、需求反转、高风险迁移的决策，不能只靠文案匹配证明 Skill 有效。

- [Skill 入口](skills/spec-init/SKILL.md)
- [示例项目](skills/spec-init/examples/demo-app/README.md)
- [贡献指南](docs/zh/contributing.md)

许可证：[PolyForm Noncommercial](LICENSE)。
