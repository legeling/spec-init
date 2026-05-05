#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  spec-init.sh [target_dir] [--here] [--name NAME] [--type TYPE] [--force]

Examples:
  spec-init.sh my-app
  spec-init.sh ./demo-service --type api
  spec-init.sh --here --name "Demo Project" --type web
EOF
}

escape_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'
}

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_ROOT="$SKILL_ROOT/assets/templates/project"

TARGET_DIR=""
PROJECT_NAME=""
PROJECT_TYPE="app"
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --here)
      TARGET_DIR="."
      shift
      ;;
    --name)
      PROJECT_NAME="${2:-}"
      shift 2
      ;;
    --name=*)
      PROJECT_NAME="${1#*=}"
      shift
      ;;
    --type)
      PROJECT_TYPE="${2:-}"
      shift 2
      ;;
    --type=*)
      PROJECT_TYPE="${1#*=}"
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$1"
        shift
      else
        printf 'Unexpected argument: %s\n\n' "$1" >&2
        usage >&2
        exit 1
      fi
      ;;
  esac
done

if [[ -z "$TARGET_DIR" ]]; then
  TARGET_DIR="."
fi

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd -- "$TARGET_DIR" && pwd)"

if [[ -z "$PROJECT_NAME" ]]; then
  PROJECT_NAME="$(basename "$TARGET_DIR")"
fi

TODAY="$(date +%F)"

render_template() {
  local source_path="$1"
  local destination_path="$2"

  if [[ -e "$destination_path" && "$FORCE" -ne 1 ]]; then
    printf 'skip  %s (already exists)\n' "$destination_path"
    return
  fi

  mkdir -p "$(dirname "$destination_path")"

  sed \
    -e "s/__PROJECT_NAME__/$(escape_replacement "$PROJECT_NAME")/g" \
    -e "s/__PROJECT_TYPE__/$(escape_replacement "$PROJECT_TYPE")/g" \
    -e "s/__DATE__/$(escape_replacement "$TODAY")/g" \
    "$source_path" > "$destination_path"

  printf 'write %s\n' "$destination_path"
}

ensure_placeholder_file() {
  local file_path="$1"

  if [[ -e "$file_path" ]]; then
    return
  fi

  mkdir -p "$(dirname "$file_path")"
  : > "$file_path"
  printf 'write %s\n' "$file_path"
}

mkdir -p \
  "$TARGET_DIR/docs/adr" \
  "$TARGET_DIR/src" \
  "$TARGET_DIR/tests" \
  "$TARGET_DIR/scripts"

ensure_placeholder_file "$TARGET_DIR/src/.gitkeep"
ensure_placeholder_file "$TARGET_DIR/tests/.gitkeep"
ensure_placeholder_file "$TARGET_DIR/scripts/.gitkeep"

render_template "$TEMPLATE_ROOT/README.md.tmpl" "$TARGET_DIR/README.md"
render_template "$TEMPLATE_ROOT/AGENTS.md.tmpl" "$TARGET_DIR/AGENTS.md"
render_template "$TEMPLATE_ROOT/docs/00-project-intake.md.tmpl" "$TARGET_DIR/docs/00-project-intake.md"
render_template "$TEMPLATE_ROOT/docs/01-requirements.md.tmpl" "$TARGET_DIR/docs/01-requirements.md"
render_template "$TEMPLATE_ROOT/docs/02-design.md.tmpl" "$TARGET_DIR/docs/02-design.md"
render_template "$TEMPLATE_ROOT/docs/03-implementation-plan.md.tmpl" "$TARGET_DIR/docs/03-implementation-plan.md"
render_template "$TEMPLATE_ROOT/docs/04-tdd-plan.md.tmpl" "$TARGET_DIR/docs/04-tdd-plan.md"
render_template "$TEMPLATE_ROOT/docs/05-task-breakdown.md.tmpl" "$TARGET_DIR/docs/05-task-breakdown.md"
render_template "$TEMPLATE_ROOT/docs/adr/0000-record-template.md.tmpl" "$TARGET_DIR/docs/adr/0000-record-template.md"

printf '\nInitialized project scaffold in: %s\n' "$TARGET_DIR"
printf 'Project name: %s\n' "$PROJECT_NAME"
printf 'Project type: %s\n\n' "$PROJECT_TYPE"

printf 'Recommended next steps:\n'
printf '1. Fill docs/00-project-intake.md\n'
printf '2. Convert it into docs/01-requirements.md\n'
printf '3. Complete docs/02-design.md before coding\n'
printf '4. Build docs/04-tdd-plan.md before major implementation\n'
printf '5. Break the first milestone into docs/05-task-breakdown.md\n'
