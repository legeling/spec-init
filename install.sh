#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  install.sh [--host HOST] [--dir PATH] [--force] [--ref REF]

Installs the spec-init skill.

Options:
  --host HOST   project | codex | claude | opencode (default: project)
  --dir PATH    install to an explicit directory
  --force       replace an existing installation
  --ref REF     git ref to download from GitHub (default: main)
  -h, --help    show this help message

Examples:
  curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/legeling/spec-init/main/install.sh | bash -s -- --host claude
EOF
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

HOST="project"
TARGET_DIR=""
FORCE=0
REF="main"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      HOST="${2:-}"
      shift 2
      ;;
    --host=*)
      HOST="${1#*=}"
      shift
      ;;
    --dir)
      TARGET_DIR="${2:-}"
      shift 2
      ;;
    --dir=*)
      TARGET_DIR="${1#*=}"
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --ref)
      REF="${2:-}"
      shift 2
      ;;
    --ref=*)
      REF="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unexpected argument: $1"
      ;;
  esac
done

if [[ -z "$HOST" ]]; then
  fail "--host requires a value"
fi

resolve_target_dir() {
  case "$1" in
    project|codex)
      printf '%s/.agents/skills/spec-init' "$PWD"
      ;;
    claude)
      printf '%s/.claude/skills/spec-init' "$HOME"
      ;;
    opencode)
      printf '%s/.config/opencode/skills/spec-init' "$HOME"
      ;;
    *)
      fail "unsupported host: $1. Supported hosts: project, codex, claude, opencode"
      ;;
  esac
}

if [[ -n "$TARGET_DIR" ]]; then
  TARGET_DIR="$(python3 - <<'PY' "$TARGET_DIR"
import os
import sys
print(os.path.abspath(sys.argv[1]))
PY
)"
else
  TARGET_DIR="$(resolve_target_dir "$HOST")"
fi

SOURCE_ROOT="${SPEC_INIT_INSTALL_SOURCE:-}"

TMP_ROOT=""
cleanup() {
  if [[ -n "$TMP_ROOT" && -d "$TMP_ROOT" ]]; then
    rm -rf "$TMP_ROOT"
  fi
}

trap cleanup EXIT

if [[ -n "$SOURCE_ROOT" ]]; then
  SOURCE_DIR="$SOURCE_ROOT/skills/spec-init"
else
  command -v curl >/dev/null 2>&1 || fail "curl is required"
  command -v tar >/dev/null 2>&1 || fail "tar is required"

  TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/spec-init-install.XXXXXX")"
  ARCHIVE_PATH="$TMP_ROOT/spec-init.tar.gz"
  ARCHIVE_URL="https://codeload.github.com/legeling/spec-init/tar.gz/${REF}"

  curl -fsSL "$ARCHIVE_URL" -o "$ARCHIVE_PATH"
  tar -xzf "$ARCHIVE_PATH" -C "$TMP_ROOT"

  set -- "$TMP_ROOT"/*/skills/spec-init
  [[ -d "$1" ]] || fail "downloaded archive does not contain skills/spec-init"
  SOURCE_DIR="$1"
fi

[[ -d "$SOURCE_DIR" ]] || fail "skill source not found: $SOURCE_DIR"

if [[ -e "$TARGET_DIR" ]]; then
  if [[ "$FORCE" -ne 1 ]]; then
    fail "target already exists: $TARGET_DIR (use --force to replace it)"
  fi

  rm -rf "$TARGET_DIR"
fi

mkdir -p "$(dirname "$TARGET_DIR")"
cp -R "$SOURCE_DIR" "$TARGET_DIR"

if [[ -f "$TARGET_DIR/scripts/spec-init.sh" ]]; then
  chmod +x "$TARGET_DIR/scripts/spec-init.sh"
fi

printf 'Installed spec-init to: %s\n' "$TARGET_DIR"
printf '%s\n' 'Next step:'
printf '%s\n' '- Codex / project-local: use $spec-init or the skill picker'
printf '%s\n' '- Claude Code / OpenCode: use /spec-init after the host reloads skills if needed'
