#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_PATH="$ROOT_DIR/skills/spec-init/scripts/spec-init.sh"
INSTALLER_PATH="$ROOT_DIR/install.sh"
NODE_INSTALLER_PATH="$ROOT_DIR/bin/spec-init.js"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/spec-init-test.XXXXXX")"

cleanup() {
  rm -rf "$TMP_ROOT"
}

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file_exists() {
  [[ -f "$1" ]] || fail "expected file to exist: $1"
}

assert_contains() {
  local file_path="$1"
  local expected="$2"

  if ! grep -Fq "$expected" "$file_path"; then
    fail "expected $file_path to contain: $expected"
  fi
}

assert_equals() {
  local actual="$1"
  local expected="$2"
  local message="$3"

  if [[ "$actual" != "$expected" ]]; then
    fail "$message"
  fi
}

trap cleanup EXIT

bash -n "$SCRIPT_PATH"
bash -n "$INSTALLER_PATH"
node --check "$NODE_INSTALLER_PATH"

project_install_root="$TMP_ROOT/project-install"
mkdir -p "$project_install_root"

(
  cd "$project_install_root"
  node "$NODE_INSTALLER_PATH" >"$TMP_ROOT/node-install.out"
)

assert_file_exists "$project_install_root/.agents/skills/spec-init/SKILL.md"
assert_file_exists "$project_install_root/.agents/skills/spec-init/scripts/spec-init.sh"
assert_contains "$TMP_ROOT/node-install.out" 'Installed spec-init to:'
assert_contains "$TMP_ROOT/node-install.out" '.agents/skills/spec-init'

custom_install_dir="$TMP_ROOT/custom-install/spec-init"
node "$NODE_INSTALLER_PATH" --dir "$custom_install_dir" >"$TMP_ROOT/node-custom.out"

assert_file_exists "$custom_install_dir/SKILL.md"
assert_file_exists "$custom_install_dir/scripts/spec-init.sh"

if node "$NODE_INSTALLER_PATH" --host unknown >"$TMP_ROOT/node-invalid.out" 2>"$TMP_ROOT/node-invalid.err"; then
  fail 'expected unsupported installer host to fail'
fi

assert_contains "$TMP_ROOT/node-invalid.err" 'unsupported host: unknown'

bash_install_dir="$TMP_ROOT/bash-install/spec-init"
SPEC_INIT_INSTALL_SOURCE="$ROOT_DIR" bash "$INSTALLER_PATH" --dir "$bash_install_dir" >"$TMP_ROOT/bash-install.out"

assert_file_exists "$bash_install_dir/SKILL.md"
assert_file_exists "$bash_install_dir/scripts/spec-init.sh"
assert_contains "$TMP_ROOT/bash-install.out" 'Installed spec-init to:'

explicit_dir="$TMP_ROOT/cli-tool"
bash "$SCRIPT_PATH" "$explicit_dir" --name "Demo CLI" --type cli >"$TMP_ROOT/explicit.out"

assert_file_exists "$explicit_dir/README.md"
assert_file_exists "$explicit_dir/AGENTS.md"
assert_file_exists "$explicit_dir/spec-init.topology.yml"
assert_file_exists "$explicit_dir/docs/workflow/00-intake/README.md"
assert_file_exists "$explicit_dir/docs/workflow/05-tasks/README.md"
assert_file_exists "$explicit_dir/docs/knowledge/context/README.md"
assert_file_exists "$explicit_dir/docs/knowledge/structure/README.md"
assert_file_exists "$explicit_dir/docs/knowledge/behavior/README.md"
assert_file_exists "$explicit_dir/docs/knowledge/reference/README.md"
assert_file_exists "$explicit_dir/docs/issues/README.md"
assert_file_exists "$explicit_dir/docs/changes/README.md"
assert_file_exists "$explicit_dir/docs/changes/active/CHG-0001-template/overview.md"
assert_file_exists "$explicit_dir/docs/changes/active/CHG-0001-template/design.md"
assert_file_exists "$explicit_dir/docs/changes/active/CHG-0001-template/verification.md"
assert_file_exists "$explicit_dir/docs/changes/active/CHG-0001-template/tasks.md"
assert_file_exists "$explicit_dir/docs/changes/active/CHG-0001-template/impact.md"
assert_file_exists "$explicit_dir/docs/changes/completed/README.md"
assert_file_exists "$explicit_dir/docs/changes/legacy/README.md"
assert_file_exists "$explicit_dir/docs/releases/README.md"
assert_file_exists "$explicit_dir/docs/releases/v0.1.0-template.md"
assert_file_exists "$explicit_dir/docs/archive/README.md"
assert_file_exists "$explicit_dir/docs/adr/README.md"
assert_file_exists "$explicit_dir/docs/rules/README.md"
assert_file_exists "$explicit_dir/docs/rules/clarification-rules.md"
assert_file_exists "$explicit_dir/docs/rules/coding-standards.md"
assert_file_exists "$explicit_dir/docs/rules/bug-fix-rules.md"
assert_file_exists "$explicit_dir/docs/rules/change-management-rules.md"
assert_file_exists "$explicit_dir/docs/rules/issue-management-rules.md"
assert_file_exists "$explicit_dir/docs/rules/document-routing-rules.md"
assert_contains "$explicit_dir/README.md" "项目类型：cli"
assert_contains "$explicit_dir/spec-init.topology.yml" 'workflow.intake: docs/workflow/00-intake/README.md'
assert_contains "$explicit_dir/docs/workflow/00-intake/README.md" '当前推断的项目类型：`cli`'
assert_contains "$explicit_dir/docs/workflow/00-intake/README.md" '新手决策向导'
assert_contains "$explicit_dir/docs/workflow/00-intake/README.md" '推断依据：用户明确通过命令参数指定项目类型：cli。'
assert_contains "$explicit_dir/docs/workflow/01-requirements/README.md" '工具输出稳定、退出码明确'
assert_contains "$explicit_dir/docs/workflow/01-requirements/README.md" '主要是给人工使用，还是需要接入自动化流水线'
assert_contains "$explicit_dir/docs/workflow/01-requirements/README.md" '可直接参考的 V1 示例'
assert_contains "$explicit_dir/docs/workflow/01-requirements/README.md" '常见错误示例'
assert_contains "$explicit_dir/docs/workflow/02-design/README.md" 'Command Parser'
assert_contains "$explicit_dir/docs/workflow/04-verification/README.md" '退出码不稳定'
assert_contains "$explicit_dir/docs/workflow/05-tasks/README.md" 'T-CLI-001'
assert_contains "$explicit_dir/docs/knowledge/context/README.md" '长期稳定的业务上下文'
assert_contains "$explicit_dir/docs/knowledge/structure/README.md" '长期稳定的系统结构'
assert_contains "$explicit_dir/docs/knowledge/behavior/README.md" '长期稳定的关键流程'
assert_contains "$explicit_dir/docs/knowledge/reference/README.md" '样例、协议、schema'
assert_contains "$explicit_dir/docs/issues/README.md" '还没解决的问题'
assert_contains "$explicit_dir/docs/changes/README.md" '变更工作区'
assert_contains "$explicit_dir/docs/changes/active/CHG-0001-template/overview.md" '为什么要改'
assert_contains "$explicit_dir/docs/releases/README.md" '最终对外交付了什么'
assert_contains "$explicit_dir/docs/archive/README.md" '已废弃'
assert_contains "$explicit_dir/docs/rules/README.md" '文档驱动开发'
assert_contains "$explicit_dir/docs/rules/README.md" 'change-management-rules.md'
assert_contains "$explicit_dir/docs/rules/README.md" 'issue-management-rules.md'
assert_contains "$explicit_dir/docs/rules/README.md" 'document-routing-rules.md'
assert_contains "$explicit_dir/docs/rules/clarification-rules.md" '必须先问用户'
assert_contains "$explicit_dir/docs/rules/clarification-rules.md" '按项目类型补充必问问题'
assert_contains "$explicit_dir/docs/rules/bug-fix-rules.md" '定位根因'
assert_contains "$explicit_dir/docs/rules/change-management-rules.md" 'workflow 与 knowledge'
assert_contains "$explicit_dir/docs/rules/issue-management-rules.md" '未解决问题要进入 `docs/issues/`'
assert_contains "$explicit_dir/docs/rules/document-routing-rules.md" 'workflow.intake'
assert_contains "$explicit_dir/docs/workflow/04-verification/README.md" 'White-box'
assert_contains "$explicit_dir/docs/changes/completed/README.md" '历史价值'
assert_contains "$explicit_dir/docs/changes/legacy/README.md" '参考价值的变更记录'
assert_contains "$explicit_dir/docs/adr/README.md" '关键架构和技术决策'

web_dir="$TMP_ROOT/admin-web"
bash "$SCRIPT_PATH" "$web_dir" --type web >"$TMP_ROOT/web.out"

assert_contains "$web_dir/docs/workflow/01-requirements/README.md" '以浏览器页面为主要入口的产品'
assert_contains "$web_dir/docs/workflow/01-requirements/README.md" '主要用户更常在手机还是桌面使用'
assert_contains "$web_dir/docs/workflow/01-requirements/README.md" 'V2 候选内容'
assert_contains "$web_dir/docs/workflow/02-design/README.md" '页面壳层与路由入口'
assert_contains "$web_dir/docs/workflow/02-design/README.md" '前端体验与视觉规范'
assert_contains "$web_dir/docs/workflow/02-design/README.md" '目标终端与分辨率'
assert_contains "$web_dir/docs/workflow/02-design/README.md" '色彩体系'
assert_contains "$web_dir/docs/workflow/02-design/README.md" '组件规范'
assert_contains "$web_dir/docs/workflow/04-verification/README.md" '关键页面'
assert_contains "$web_dir/docs/workflow/05-tasks/README.md" 'T-WEB-001'
assert_contains "$web_dir/docs/workflow/04-verification/README.md" 'Performance'
assert_contains "$web_dir/docs/workflow/04-verification/README.md" 'Security'

api_dir="$TMP_ROOT/orders-api"
bash "$SCRIPT_PATH" "$api_dir" --type api >"$TMP_ROOT/api.out"

assert_contains "$api_dir/docs/workflow/01-requirements/README.md" '以 HTTP 接口为主要交付物的服务'
assert_contains "$api_dir/docs/workflow/01-requirements/README.md" '首批资源、动作和调用方分别是什么'
assert_contains "$api_dir/docs/workflow/01-requirements/README.md" 'V2 候选内容'
assert_contains "$api_dir/docs/workflow/02-design/README.md" 'API Transport Layer'
assert_contains "$api_dir/docs/workflow/02-design/README.md" '后端工程约定与数据规范'
assert_contains "$api_dir/docs/workflow/02-design/README.md" '数据库约定'
assert_contains "$api_dir/docs/workflow/02-design/README.md" 'migration 规范'
assert_contains "$api_dir/docs/workflow/02-design/README.md" '事务边界'
assert_contains "$api_dir/docs/workflow/04-verification/README.md" '真实 HTTP 契约'
assert_contains "$api_dir/docs/workflow/05-tasks/README.md" 'T-API-001'
assert_contains "$api_dir/docs/workflow/02-design/README.md" '架构质量目标'

inferred_dir="$TMP_ROOT/order-worker"
bash "$SCRIPT_PATH" "$inferred_dir" --name "Order Worker" >"$TMP_ROOT/inferred.out"

assert_contains "$inferred_dir/README.md" "项目类型：service"
assert_contains "$inferred_dir/docs/workflow/00-intake/README.md" '当前推断的项目类型：`service`'
assert_contains "$inferred_dir/docs/workflow/00-intake/README.md" 'worker/consumer/queue/job/scheduler/daemon/service'
assert_contains "$inferred_dir/docs/workflow/01-requirements/README.md" '范围裁剪助手'
assert_contains "$inferred_dir/docs/workflow/01-requirements/README.md" '常见错误示例'
assert_contains "$inferred_dir/docs/workflow/03-implementation/README.md" '范围分阶段建议'

existing_dir="$TMP_ROOT/existing-project"
mkdir -p "$existing_dir"
printf 'custom readme\n' > "$existing_dir/README.md"

bash "$SCRIPT_PATH" "$existing_dir" --type web >"$TMP_ROOT/existing.out"

assert_equals "$(cat "$existing_dir/README.md")" "custom readme" "expected existing README.md to be preserved without --force"
assert_file_exists "$existing_dir/docs/workflow/01-requirements/README.md"

force_dir="$TMP_ROOT/force-project"
mkdir -p "$force_dir"
printf 'custom readme\n' > "$force_dir/README.md"

bash "$SCRIPT_PATH" "$force_dir" --type api --force >"$TMP_ROOT/force.out"

assert_contains "$force_dir/README.md" '项目类型：api'

english_dir="$TMP_ROOT/english-cli"
bash "$SCRIPT_PATH" "$english_dir" --type cli --lang en >"$TMP_ROOT/english.out"

assert_contains "$english_dir/README.md" 'Project type: cli'
assert_contains "$english_dir/AGENTS.md" 'Clarify the current delivery scope, long-lived project truth, verification strategy, and change workspace before coding'
assert_contains "$english_dir/docs/workflow/00-intake/README.md" 'Current inferred project type: `cli`'
assert_contains "$english_dir/docs/workflow/00-intake/README.md" 'Beginner Decision Guide'
assert_contains "$english_dir/docs/workflow/05-tasks/README.md" 'T-CLI-001 Define the command tree'
assert_contains "$english_dir/docs/issues/README.md" 'unresolved problems'
assert_contains "$english_dir/docs/changes/README.md" 'change-workspace lifecycles'
assert_contains "$english_dir/docs/releases/README.md" 'what was actually delivered'
assert_contains "$english_dir/docs/archive/README.md" 'retired, replaced, or historical documents'
assert_contains "$english_dir/docs/rules/definition-of-done.md" 'Before a task is marked done'
assert_contains "$english_dir/docs/rules/clarification-rules.md" 'ask the user first'
assert_contains "$english_dir/docs/rules/clarification-rules.md" 'Project-Type-Specific Must-Ask Questions'
assert_contains "$english_dir/docs/rules/bug-fix-rules.md" 'root cause'
assert_contains "$english_dir/docs/rules/change-management-rules.md" 'workflow and knowledge docs'
assert_contains "$english_dir/docs/rules/issue-management-rules.md" 'Unresolved problems belong in `docs/issues/`'
assert_contains "$english_dir/docs/rules/document-routing-rules.md" 'where each document semantic type should live'
assert_contains "$english_dir/spec-init.topology.yml" 'knowledge.context: docs/knowledge/context/'
assert_contains "$english_dir/docs/workflow/01-requirements/README.md" 'Is the tool mainly for humans or for automation pipelines?'
assert_contains "$english_dir/docs/workflow/01-requirements/README.md" 'Copyable V1 Example'
assert_contains "$english_dir/docs/workflow/01-requirements/README.md" 'Common Mistakes'
assert_contains "$english_dir/docs/workflow/03-implementation/README.md" 'Ongoing Refinement Plan'
assert_contains "$english_dir/docs/workflow/02-design/README.md" 'CLI Experience and Conventions'
assert_contains "$english_dir/docs/workflow/02-design/README.md" 'Exit-code rules'
assert_contains "$english_dir/docs/workflow/04-verification/README.md" 'White-box Unit'

invalid_dir="$TMP_ROOT/invalid-project"
if bash "$SCRIPT_PATH" "$invalid_dir" --type app >"$TMP_ROOT/invalid.out" 2>"$TMP_ROOT/invalid.err"; then
  fail 'expected unsupported project type to fail'
fi

assert_contains "$TMP_ROOT/invalid.err" 'Unsupported project type: app'
assert_contains "$TMP_ROOT/invalid.err" 'Supported types: web, api, cli, library, service'

invalid_lang_dir="$TMP_ROOT/invalid-lang-project"
if bash "$SCRIPT_PATH" "$invalid_lang_dir" --lang fr >"$TMP_ROOT/invalid-lang.out" 2>"$TMP_ROOT/invalid-lang.err"; then
  fail 'expected unsupported language to fail'
fi

assert_contains "$TMP_ROOT/invalid-lang.err" 'Unsupported language: fr'
assert_contains "$TMP_ROOT/invalid-lang.err" 'Supported languages: zh, en'

printf 'spec-init smoke tests passed\n'
