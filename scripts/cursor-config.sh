#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${CURSOR_CONFIG_REPO_URL:-https://github.com/DaikoAI/.cursor.git}"
BRANCH="${CURSOR_CONFIG_BRANCH:-main}"
PREFIX="${CURSOR_CONFIG_PREFIX:-.cursor}"
MANIFEST_FILE_NAME="${CURSOR_CONFIG_MANIFEST:-.daiko-cursor-config.manifest}"

# Only sync these directories (exclude README, package.json, scripts, etc.)
SYNC_DIRS=("commands" "rules")

TMP_DIR=""

# ANSI color codes
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
GREEN="\033[32m"
BLUE="\033[34m"
CYAN="\033[36m"
YELLOW="\033[33m"
RED="\033[31m"
MAGENTA="\033[35m"

cleanup_tmp_dir() {
  if [[ -n "${TMP_DIR:-}" && -d "${TMP_DIR:-}" ]]; then
    rm -rf -- "$TMP_DIR"
  fi
}

trap cleanup_tmp_dir EXIT

print_usage() {
  cat <<'EOF'
Usage:
  cursor-config.sh [install|update]

Environment variables:
  CURSOR_CONFIG_REPO_URL   (default: https://github.com/DaikoAI/.cursor.git)
  CURSOR_CONFIG_BRANCH     (default: main)
  CURSOR_CONFIG_PREFIX     (default: .cursor)
  CURSOR_CONFIG_MANIFEST   (default: .daiko-cursor-config.manifest)

Notes:
  - install/update behave the same (sync latest).
  - Only syncs: commands/, rules/
  - Previously managed files are removed before syncing so deletions upstream are applied.
  - Your project-specific additions under .cursor/ are preserved.
EOF
}

print_daiko_banner() {
  cat <<'EOF'

    ██████╗  █████╗ ██╗██╗  ██╗ ██████╗
    ██╔══██╗██╔══██╗██║██║ ██╔╝██╔═══██╗
    ██║  ██║███████║██║█████╔╝ ██║   ██║
    ██║  ██║██╔══██║██║██╔═██╗ ██║   ██║
    ██████╔╝██║  ██║██║██║  ██╗╚██████╔╝
    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝

EOF
}

is_submodule_target() {
  if [[ ! -f .gitmodules ]]; then
    return 1
  fi

  while IFS= read -r line; do
    local value
    value="${line#* }"
    if [[ "$value" == "$PREFIX" ]]; then
      return 0
    fi
  done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null || true)

  return 1
}

sync_now() {
  local manifest_path
  manifest_path="$PREFIX/$MANIFEST_FILE_NAME"

  echo -e "${CYAN}${BOLD}→${RESET} ${BOLD}Fetching cursor configuration...${RESET}" >&2

  TMP_DIR="$(mktemp -d)"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMP_DIR" >/dev/null 2>&1

  mkdir -p "$PREFIX"

  # Remove previously managed files so deletions upstream are reflected.
  if [[ -f "$manifest_path" ]]; then
    echo -e "${BLUE}${BOLD}→${RESET} ${DIM}Cleaning up old files...${RESET}" >&2
    while IFS= read -r rel_path; do
      [[ -z "$rel_path" ]] && continue

      # Only remove files that belong to our managed directories
      local should_remove=false
      for dir in "${SYNC_DIRS[@]}"; do
        if [[ "$rel_path" == "$dir"* ]]; then
          should_remove=true
          break
        fi
      done

      if [[ "$should_remove" == true ]]; then
        rm -rf -- "$PREFIX/$rel_path"
      fi
    done < "$manifest_path"
  fi

  echo -e "${CYAN}${BOLD}→${RESET} ${BOLD}Syncing into ${PREFIX}/...${RESET}" >&2

  local added=0
  local updated=0
  local removed=0

  # Sync only specified directories
  for dir in "${SYNC_DIRS[@]}"; do
    if [[ -d "$TMP_DIR/$dir" ]]; then
      echo -e "  ${MAGENTA}•${RESET} ${DIM}$dir/${RESET}" >&2

      # Copy directory contents
      mkdir -p "$PREFIX/$dir"
      cp -R "$TMP_DIR/$dir/"* "$PREFIX/$dir/" 2>/dev/null || true

      # Count files
      local count
      count=$(find "$TMP_DIR/$dir" -type f | wc -l | tr -d ' ')
      added=$((added + count))
    fi
  done

  # Write new manifest (only for managed directories)
  : > "$manifest_path"
  for dir in "${SYNC_DIRS[@]}"; do
    if [[ -d "$TMP_DIR/$dir" ]]; then
      git -C "$TMP_DIR" ls-files "$dir" >> "$manifest_path"
    fi
  done

  echo "" >&2
  echo -e "${GREEN}${BOLD}✓${RESET} ${BOLD}Sync completed!${RESET}" >&2
  echo -e "${DIM}  Synced ${added} file(s)${RESET}" >&2

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "" >&2
    echo -e "${YELLOW}${BOLD}→${RESET} ${DIM}Next steps:${RESET}" >&2
    echo -e "  ${DIM}git add \"$PREFIX\" && git commit -m \"chore: sync cursor config\"${RESET}" >&2
  fi

  echo "" >&2
  echo -e "${MAGENTA}${BOLD}" >&2
  print_daiko_banner >&2
  echo -e "${RESET}" >&2
}

main() {
  local cmd
  cmd="${1:-install}"

  if [[ "$cmd" == "-h" || "$cmd" == "--help" ]]; then
    print_usage
    exit 0
  fi

  if [[ "$cmd" != "install" && "$cmd" != "update" ]]; then
    echo -e "${RED}${BOLD}✗${RESET} Error: unknown command '$cmd'" >&2
    echo "" >&2
    print_usage >&2
    exit 1
  fi

  if is_submodule_target; then
    echo -e "${RED}${BOLD}✗${RESET} Error: '$PREFIX' is configured as a git submodule in this repository." >&2
    echo -e "${YELLOW}${BOLD}→${RESET} ${DIM}Hint: run: git submodule update --remote --merge $PREFIX${RESET}" >&2
    exit 1
  fi

  sync_now
}

main "$@"
