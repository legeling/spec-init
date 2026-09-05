#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
SCRIPT="$ROOT/skills/spec-init/scripts/spec-init.sh"
TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/spec-init-test.XXXXXX")"
TMP_ROOT="$(cd "$TMP_ROOT" && pwd -P)"
trap 'rm -rf -- "$TMP_ROOT"' EXIT
export SPEC_INIT_BACKUP_ROOT="$TMP_ROOT/backups"
checks=0
fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }
ok() { checks=$((checks + 1)); }
exists() { [[ -f "$1" ]] || fail "missing $1"; }
reject() {
  if "$@" > "$TMP_ROOT/rejected.out" 2>&1; then fail "expected rejection: $*"; fi
  ok
}
manifest() { (cd "$1" && find . -type f | LC_ALL=C sort); }
expect_three() {
  local got
  got="$(manifest "$1")"
  [[ "$got" == $'./AGENTS.md\n./README.md\n./docs/README.md' ]] || fail "unexpected scaffold files: $got"
  ok
}

# Installer compatibility: local copies only, no network or host-global destinations.
mkdir "$TMP_ROOT/project"
(cd "$TMP_ROOT/project" && node "$ROOT/bin/spec-init.js") > "$TMP_ROOT/install.out"
exists "$TMP_ROOT/project/.agents/skills/spec-init/SKILL.md"
reject node "$ROOT/bin/spec-init.js" --dir "$TMP_ROOT/project/.agents/skills/spec-init"
node "$ROOT/bin/spec-init.js" --dir "$TMP_ROOT/node-copy" > /dev/null
diff -r "$ROOT/skills/spec-init" "$TMP_ROOT/node-copy" > /dev/null
SPEC_INIT_INSTALL_SOURCE="$ROOT" bash "$ROOT/install.sh" --dir "$TMP_ROOT/bash-copy" > /dev/null
diff -r "$ROOT/skills/spec-init" "$TMP_ROOT/bash-copy" > /dev/null
reject node "$ROOT/bin/spec-init.js" --host unknown
ok

# Both languages and all supported type values keep the bounded output contract.
for lang in zh en; do
  for type in web api cli library service; do
    out="$TMP_ROOT/$lang-$type"
    bash "$SCRIPT" "$out" --type="$type" --lang="$lang" > /dev/null
    expect_three "$out"
    case "$lang" in
      zh) label="项目类型：$type";; en) label="Project type: $type";;
    esac
    [[ "$(cat "$out/README.md")" == *"$label"* ]] || fail 'type/language not rendered'
  done
done
name='A & B / \ __PROJECT_TYPE__ $HOME `literal` 中文'
bash "$SCRIPT" "$TMP_ROOT/literal" --name "$name" --type cli > /dev/null
IFS= read -r title < "$TMP_ROOT/literal/README.md"
[[ "$title" == "# $name" ]] || fail 'literal project name changed'
ok
mkdir "$TMP_ROOT/here"
(cd "$TMP_ROOT/here" && bash "$SCRIPT" --here --name 'Worker' --lang EN --type API) > /dev/null
expect_three "$TMP_ROOT/here"
bash "$SCRIPT" "$TMP_ROOT/queue-worker" > /dev/null
[[ "$(cat "$TMP_ROOT/queue-worker/README.md")" == *'项目类型：service'* ]] || fail 'inference changed'
ok

# Rerun preserves every existing byte; force preserves old data and creates recoverable backups.
existing="$TMP_ROOT/existing"
bash "$SCRIPT" "$existing" > /dev/null
printf 'custom readme\n' > "$existing/README.md"
printf 'custom instructions\n' > "$existing/AGENTS.md"
printf 'custom entry\n' > "$existing/docs/README.md"
mkdir -p "$existing/docs/00-intake" "$existing/docs/changes/active/user-change"
printf 'old business context\n' > "$existing/docs/00-intake/business.md"
printf 'unfinished work\n' > "$existing/docs/changes/active/user-change/tasks.md"
cp -R "$existing" "$TMP_ROOT/before"
bash "$SCRIPT" "$existing" --name Changed > /dev/null
diff -r "$existing" "$TMP_ROOT/before" > /dev/null
ok
bash "$SCRIPT" "$existing" --force --lang en > "$TMP_ROOT/force.out"
backup="$(sed -n 's/^Backup: //p' "$TMP_ROOT/force.out")"
[[ -d "$backup" ]] || fail 'backup path missing'
expect_three "$backup/files"
exists "$backup/RESTORE.txt"
[[ "$backup" != "$existing/"* ]] || fail 'backup is inside project'
for file in README.md AGENTS.md docs/README.md; do
  cmp "$backup/files/$file" "$TMP_ROOT/before/$file"
  cp -p "$backup/files/$file" "$existing/$file"
done
# Backups are outside the project and cannot introduce old rules into its tree.
rm -rf -- "$backup"
diff -r "$existing" "$TMP_ROOT/before" > /dev/null
ok
bash "$SCRIPT" "$TMP_ROOT/new-force" --force > /dev/null
expect_three "$TMP_ROOT/new-force"

# All invalid arguments fail before any target is created.
for option in '--bad' '--lang=fr' '--type=app' '--name=' '--lang=' '--type='; do
  reject bash "$SCRIPT" "$TMP_ROOT/invalid" "$option"
  [[ ! -e "$TMP_ROOT/invalid" ]] || fail 'invalid arguments created target'
done
for option in --name --lang --type; do
  reject bash "$SCRIPT" "$TMP_ROOT/invalid" "$option"
  [[ ! -e "$TMP_ROOT/invalid" ]] || fail 'missing value created target'
done
reject bash "$SCRIPT" "$TMP_ROOT/invalid" --name $'two\nlines'
reject bash "$SCRIPT" "$TMP_ROOT/invalid" --lang --force
reject bash "$SCRIPT" "$TMP_ROOT/invalid" "$TMP_ROOT/second"
[[ ! -e "$TMP_ROOT/invalid" && ! -e "$TMP_ROOT/second" ]] || fail 'bad arguments wrote data'

# Preflight checks every destination before writing anything, with and without force.
mkdir -p "$TMP_ROOT/external" "$TMP_ROOT/link-file" "$TMP_ROOT/link-docs" "$TMP_ROOT/wrong-type"
printf 'external content\n' > "$TMP_ROOT/external/original.md"
ln -s "$TMP_ROOT/external/original.md" "$TMP_ROOT/link-file/AGENTS.md"
ln -s "$TMP_ROOT/external" "$TMP_ROOT/link-docs/docs"
ln -s "$TMP_ROOT/external" "$TMP_ROOT/link-parent"
ln -s "$TMP_ROOT/nonexistent" "$TMP_ROOT/dangling"
mkdir "$TMP_ROOT/wrong-type/AGENTS.md"
for force in '' --force; do
  for target in link-file link-docs link-parent/child dangling wrong-type; do
    if [[ -n "$force" ]]; then
      reject bash "$SCRIPT" "$TMP_ROOT/$target" "$force"
    else
      reject bash "$SCRIPT" "$TMP_ROOT/$target"
    fi
  done
done
[[ "$(manifest "$TMP_ROOT/external")" == './original.md' ]] || fail 'wrote outside target'
[[ "$(cat "$TMP_ROOT/external/original.md")" == 'external content' ]] || fail 'external content changed'
for target in link-file link-docs wrong-type; do
  [[ ! -e "$TMP_ROOT/$target/README.md" ]] || fail 'partial output before rejection'
done
ok

# Missing template must fail before creating an empty project.
rm "$TMP_ROOT/node-copy/assets/templates/project/en/AGENTS.md.tmpl"
reject bash "$TMP_ROOT/node-copy/scripts/spec-init.sh" "$TMP_ROOT/missing-template" --lang en
[[ ! -e "$TMP_ROOT/missing-template" ]] || fail 'missing template created output'

# Installer argument errors cannot fall back to or mutate the default installation.
for kind in node bash; do
  project="$TMP_ROOT/args-$kind"
  mkdir "$project"
  if [[ "$kind" == node ]]; then
    installer=(node "$ROOT/bin/spec-init.js")
  else
    installer=(env SPEC_INIT_INSTALL_SOURCE="$ROOT" bash "$ROOT/install.sh")
  fi
  "${installer[@]}" --dir "$project/.agents/skills/spec-init" > /dev/null
  printf 'custom rule\n' > "$project/.agents/skills/spec-init/custom.md"
  cp -R "$project" "$TMP_ROOT/args-before-$kind"
  for option in --dir= --dir --host= --host; do
    (cd "$project" && reject "${installer[@]}" "$option" --force)
  done
  (cd "$project" && reject "${installer[@]}" --host unknown --dir "$project/other")
  (cd "$project" && reject "${installer[@]}" --dir --host project)
  if [[ "$kind" == bash ]]; then
    (cd "$project" && reject "${installer[@]}" --ref= --force)
    (cd "$project" && reject "${installer[@]}" --ref --force)
  fi
  diff -r "$project" "$TMP_ROOT/args-before-$kind" > /dev/null
  ok

  # Normal replacement succeeds, and copy/activation failure preserves the old version.
  destination="$TMP_ROOT/replace-$kind"
  "${installer[@]}" --dir "$destination" > /dev/null
  printf 'old customization\n' > "$destination/custom.md"
  cp -R "$destination" "$TMP_ROOT/replace-before-$kind"
  fake="$TMP_ROOT/fake-$kind"
  mkdir "$fake"
  if [[ "$kind" == node ]]; then
    cat > "$fake/fail-copy.cjs" <<'HOOK'
require('node:fs').cpSync = () => { throw new Error('injected copy failure'); };
HOOK
    cat > "$fake/fail-activation.cjs" <<'HOOK'
const fs = require('node:fs');
const original = fs.renameSync;
fs.renameSync = (source, target) => {
  if (source.endsWith('/package')) throw new Error('injected activation failure');
  return original(source, target);
};
HOOK
    reject env NODE_OPTIONS="--require=$fake/fail-copy.cjs" "${installer[@]}" --dir "$destination" --force
    diff -r "$destination" "$TMP_ROOT/replace-before-$kind" > /dev/null
    reject env NODE_OPTIONS="--require=$fake/fail-activation.cjs" "${installer[@]}" --dir "$destination" --force
  else
    mkdir "$fake/copy" "$fake/activation"
    printf '#!/bin/sh\nexit 28\n' > "$fake/copy/cp"
    cat > "$fake/activation/mv" <<'HOOK'
#!/bin/sh
case "$1" in */package) exit 29;; esac
exec /bin/mv "$@"
HOOK
    chmod +x "$fake/copy/cp" "$fake/activation/mv"
    reject env PATH="$fake/copy:$PATH" "${installer[@]}" --dir "$destination" --force
    diff -r "$destination" "$TMP_ROOT/replace-before-$kind" > /dev/null
    reject env PATH="$fake/activation:$PATH" "${installer[@]}" --dir "$destination" --force
  fi
  diff -r "$destination" "$TMP_ROOT/replace-before-$kind" > /dev/null
  [[ -z "$(find "$TMP_ROOT" -maxdepth 1 -name '.spec-init-install-*' -print)" ]] || fail 'installer staging leaked'
  "${installer[@]}" --dir "$destination" --force > /dev/null
  diff -r "$ROOT/skills/spec-init" "$destination" > /dev/null
  ok

  mkdir "$TMP_ROOT/unrelated-$kind"
  printf 'business data\n' > "$TMP_ROOT/unrelated-$kind/keep.txt"
  reject "${installer[@]}" --dir "$TMP_ROOT/unrelated-$kind" --force
  [[ "$(cat "$TMP_ROOT/unrelated-$kind/keep.txt")" == 'business data' ]] || fail 'unrelated directory damaged'
  ln -s "$destination" "$TMP_ROOT/install-link-$kind"
  reject "${installer[@]}" --dir "$TMP_ROOT/install-link-$kind" --force
  mini="$TMP_ROOT/self-$kind"
  mkdir -p "$mini/bin" "$mini/skills"
  cp "$ROOT/bin/spec-init.js" "$mini/bin/spec-init.js"
  cp -R "$ROOT/skills/spec-init" "$mini/skills/spec-init"
  if [[ "$kind" == node ]]; then
    reject node "$mini/bin/spec-init.js" --dir "$mini/skills/spec-init" --force
  else
    reject env SPEC_INIT_INSTALL_SOURCE="$mini" bash "$ROOT/install.sh" --dir "$mini/skills/spec-init" --force
  fi
  diff -r "$ROOT/skills/spec-init" "$mini/skills/spec-init" > /dev/null
  diff -r "$ROOT/skills/spec-init" "$destination" > /dev/null
  ok
done

# Reject an in-project backup root before replacing any existing document.
cp -R "$existing" "$TMP_ROOT/before-backup-rejection"
reject env SPEC_INIT_BACKUP_ROOT="$existing/backups" bash "$SCRIPT" "$existing" --force
diff -r "$existing" "$TMP_ROOT/before-backup-rejection" > /dev/null
ok

printf 'Passed %s behavioral checks (install, scaffold, preservation, rollback, invalid input, symlinks).\n' "$checks"
