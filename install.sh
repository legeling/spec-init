#!/usr/bin/env bash
set -euo pipefail

fail() { printf 'Error: %s\n' "$1" >&2; exit 1; }
usage() {
  printf '%s\n' 'Usage: install.sh [--host project|codex|claude|opencode] [--dir PATH] [--force] [--ref REF]'
  printf '%s\n' '--force safely replaces an existing skill installation; back up customizations first.'
}
HOST=project
TARGET_DIR=""
REF=main
FORCE=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --host|--dir|--ref)
      [[ -n "${2:-}" && "$2" != --* ]] || fail "$1 requires a value"
      case "$1" in --host) HOST="$2";; --dir) TARGET_DIR="$2";; --ref) REF="$2";; esac
      shift 2 ;;
    --host=*|--dir=*|--ref=*)
      option="${1%%=*}"; value="${1#*=}"
      [[ -n "$value" && "$value" != --* ]] || fail "$option requires a value"
      case "$option" in --host) HOST="$value";; --dir) TARGET_DIR="$value";; --ref) REF="$value";; esac
      shift ;;
    --force) FORCE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unexpected argument: $1" ;;
  esac
done
case "$HOST" in
  project|codex) default_target="$PWD/.agents/skills/spec-init";;
  claude) default_target="$HOME/.claude/skills/spec-init";;
  opencode) default_target="$HOME/.config/opencode/skills/spec-init";;
  *) fail "unsupported host: $HOST";;
esac
TARGET_DIR="${TARGET_DIR:-$default_target}"
[[ "$REF" != *$'\n'* && "$REF" != *$'\r'* ]] || fail 'ref must be one line'
[[ "$TARGET_DIR" != *$'\n'* && "$TARGET_DIR" != *$'\r'* ]] || fail 'target must be one line'

safe_directory() {
  local input="$1" current=/ part
  local -a components
  [[ "$input" == /* ]] || input="$(pwd -P)/$input"
  IFS=/ read -r -a components <<< "$input"
  for part in "${components[@]}"; do
    case "$part" in ''|.) continue;; ..) current="$(dirname "$current")"; continue;; esac
    current="${current%/}/$part"
    [[ ! -L "$current" ]] || fail "symlink directory refused: $current"
    [[ ! -e "$current" || -d "$current" ]] || fail "not a directory: $current"
  done
  printf '%s' "$current"
}
validate_package() {
  local file
  for file in SKILL.md scripts/spec-init.sh; do
    [[ -f "$1/$file" && ! -L "$1/$file" ]] || fail "incomplete skill package: $1/$file"
  done
}
TARGET_DIR="$(safe_directory "$TARGET_DIR")"
if [[ -e "$TARGET_DIR" ]]; then
  [[ "$FORCE" -eq 1 ]] || fail "target already exists: $TARGET_DIR (use --force to replace it)"
  validate_package "$TARGET_DIR"
fi

DOWNLOAD=""
STAGE=""
OLD_MOVED=0
cleanup() {
  local result=$?
  if [[ "$OLD_MOVED" -eq 1 ]]; then
    if [[ ! -e "$TARGET_DIR" && ! -L "$TARGET_DIR" ]] && mv "$STAGE/previous" "$TARGET_DIR"; then
      OLD_MOVED=0
    else
      printf 'Recovery needed: restore %s to %s\n' "$STAGE/previous" "$TARGET_DIR" >&2
      result=1
    fi
  fi
  if [[ -n "$STAGE" && "$OLD_MOVED" -eq 0 ]]; then rm -rf -- "$STAGE"; fi
  if [[ -n "$DOWNLOAD" ]]; then rm -rf -- "$DOWNLOAD"; fi
  trap - EXIT
  exit "$result"
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM
if [[ -n "${SPEC_INIT_INSTALL_SOURCE:-}" ]]; then
  SOURCE_DIR="$SPEC_INIT_INSTALL_SOURCE/skills/spec-init"
else
  command -v curl >/dev/null 2>&1 || fail 'curl is required'
  command -v tar >/dev/null 2>&1 || fail 'tar is required'
  DOWNLOAD="$(mktemp -d "${TMPDIR:-/tmp}/spec-init-download.XXXXXX")"
  curl -fsSL --connect-timeout 15 --max-time 120 --retry 2 --retry-delay 2 --retry-max-time 180 \
    "https://codeload.github.com/legeling/spec-init/tar.gz/${REF}" -o "$DOWNLOAD/source.tar.gz"
  tar -xzf "$DOWNLOAD/source.tar.gz" -C "$DOWNLOAD"
  set -- "$DOWNLOAD"/*/skills/spec-init
  [[ -d "$1" ]] || fail 'downloaded archive does not contain skills/spec-init'
  SOURCE_DIR="$1"
fi
validate_package "$SOURCE_DIR"
SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd -P)"
[[ "$TARGET_DIR" != / && "$TARGET_DIR" != "$SOURCE_DIR" && "$TARGET_DIR" != "$SOURCE_DIR/"* && "$SOURCE_DIR" != "$TARGET_DIR/"* ]] || fail 'installation source and destination must not overlap'
mkdir -p "$(dirname "$TARGET_DIR")"
STAGE="$(mktemp -d "$(dirname "$TARGET_DIR")/.spec-init-install-XXXXXX")"
cp -R "$SOURCE_DIR" "$STAGE/package"
validate_package "$STAGE/package"
chmod +x "$STAGE/package/scripts/spec-init.sh"
if [[ -e "$TARGET_DIR" || -L "$TARGET_DIR" ]]; then
  [[ "$FORCE" -eq 1 ]] || fail "target appeared during installation: $TARGET_DIR"
  safe_directory "$TARGET_DIR" >/dev/null
  validate_package "$TARGET_DIR"
  mv "$TARGET_DIR" "$STAGE/previous"
  OLD_MOVED=1
fi
mv "$STAGE/package" "$TARGET_DIR"
OLD_MOVED=0
printf 'Installed spec-init to: %s\n' "$TARGET_DIR"
printf '%s\n' 'Use $spec-init (Codex/project) or /spec-init (Claude Code/OpenCode).'
