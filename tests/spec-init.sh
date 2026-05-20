#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPT_PATH="$ROOT_DIR/skills/spec-init/scripts/spec-init.sh"
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

explicit_dir="$TMP_ROOT/cli-tool"
bash "$SCRIPT_PATH" "$explicit_dir" --name "Demo CLI" --type cli >"$TMP_ROOT/explicit.out"

assert_file_exists "$explicit_dir/README.md"
assert_file_exists "$explicit_dir/AGENTS.md"
assert_file_exists "$explicit_dir/docs/00-intake/README.md"
assert_file_exists "$explicit_dir/docs/05-tasks/README.md"
assert_file_exists "$explicit_dir/docs/rules/README.md"
assert_file_exists "$explicit_dir/docs/rules/clarification-rules.md"
assert_file_exists "$explicit_dir/docs/rules/coding-standards.md"
assert_file_exists "$explicit_dir/docs/rules/bug-fix-rules.md"
assert_contains "$explicit_dir/README.md" "项目类型：cli"
assert_contains "$explicit_dir/docs/00-intake/README.md" '当前推断的项目类型：`cli`'
assert_contains "$explicit_dir/docs/00-intake/README.md" '推断依据：用户明确通过命令参数指定项目类型：cli。'
assert_contains "$explicit_dir/docs/01-requirements/README.md" '工具输出稳定、退出码明确'
assert_contains "$explicit_dir/docs/02-design/README.md" 'Command Parser'
assert_contains "$explicit_dir/docs/04-tdd/README.md" '退出码不稳定'
assert_contains "$explicit_dir/docs/05-tasks/README.md" 'T-CLI-001'
assert_contains "$explicit_dir/docs/rules/README.md" '文档驱动开发'
assert_contains "$explicit_dir/docs/rules/clarification-rules.md" '必须先问用户'
assert_contains "$explicit_dir/docs/rules/bug-fix-rules.md" '定位根因'
assert_contains "$explicit_dir/docs/04-tdd/README.md" 'White-box'

web_dir="$TMP_ROOT/admin-web"
bash "$SCRIPT_PATH" "$web_dir" --type web >"$TMP_ROOT/web.out"

assert_contains "$web_dir/docs/01-requirements/README.md" '以浏览器页面为主要入口的产品'
assert_contains "$web_dir/docs/02-design/README.md" '页面壳层与路由入口'
assert_contains "$web_dir/docs/04-tdd/README.md" '关键页面'
assert_contains "$web_dir/docs/05-tasks/README.md" 'T-WEB-001'
assert_contains "$web_dir/docs/04-tdd/README.md" 'Performance'
assert_contains "$web_dir/docs/04-tdd/README.md" 'Security'

api_dir="$TMP_ROOT/orders-api"
bash "$SCRIPT_PATH" "$api_dir" --type api >"$TMP_ROOT/api.out"

assert_contains "$api_dir/docs/01-requirements/README.md" '以 HTTP 接口为主要交付物的服务'
assert_contains "$api_dir/docs/02-design/README.md" 'API Transport Layer'
assert_contains "$api_dir/docs/04-tdd/README.md" '真实 HTTP 契约'
assert_contains "$api_dir/docs/05-tasks/README.md" 'T-API-001'
assert_contains "$api_dir/docs/02-design/README.md" '架构质量目标'

inferred_dir="$TMP_ROOT/order-worker"
bash "$SCRIPT_PATH" "$inferred_dir" --name "Order Worker" >"$TMP_ROOT/inferred.out"

assert_contains "$inferred_dir/README.md" "项目类型：service"
assert_contains "$inferred_dir/docs/00-intake/README.md" '当前推断的项目类型：`service`'
assert_contains "$inferred_dir/docs/00-intake/README.md" 'worker/consumer/queue/job/scheduler/daemon/service'

existing_dir="$TMP_ROOT/existing-project"
mkdir -p "$existing_dir"
printf 'custom readme\n' > "$existing_dir/README.md"

bash "$SCRIPT_PATH" "$existing_dir" --type web >"$TMP_ROOT/existing.out"

assert_equals "$(cat "$existing_dir/README.md")" "custom readme" "expected existing README.md to be preserved without --force"
assert_file_exists "$existing_dir/docs/01-requirements/README.md"

force_dir="$TMP_ROOT/force-project"
mkdir -p "$force_dir"
printf 'custom readme\n' > "$force_dir/README.md"

bash "$SCRIPT_PATH" "$force_dir" --type api --force >"$TMP_ROOT/force.out"

assert_contains "$force_dir/README.md" '项目类型：api'

english_dir="$TMP_ROOT/english-cli"
bash "$SCRIPT_PATH" "$english_dir" --type cli --lang en >"$TMP_ROOT/english.out"

assert_contains "$english_dir/README.md" 'Project type: cli'
assert_contains "$english_dir/AGENTS.md" 'Clarify requirements, design, implementation order, and tests before coding'
assert_contains "$english_dir/docs/00-intake/README.md" 'Current inferred project type: `cli`'
assert_contains "$english_dir/docs/05-tasks/README.md" 'T-CLI-001 Define the command tree'
assert_contains "$english_dir/docs/rules/definition-of-done.md" 'Before a task is marked done'
assert_contains "$english_dir/docs/rules/clarification-rules.md" 'ask the user first'
assert_contains "$english_dir/docs/rules/bug-fix-rules.md" 'root cause'
assert_contains "$english_dir/docs/04-tdd/README.md" 'White-box Unit'

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
