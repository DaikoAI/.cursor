#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${CURSOR_CONFIG_REPO_URL:-https://github.com/DaikoAI/.cursor.git}"
BRANCH="${CURSOR_CONFIG_BRANCH:-main}"
PREFIX="${CURSOR_CONFIG_PREFIX:-.cursor}"
MANIFEST_FILE_NAME="${CURSOR_CONFIG_MANIFEST:-.daiko-cursor-config.manifest}"

TMP_DIR=""

cleanup_tmp_dir() {
  if [[ -n "${TMP_DIR:-}" && -d "${TMP_DIR:-}" ]]; then
    rm -rf -- "$TMP_DIR"
  fi
}

# Always clean up the temp dir on exit (success, error, ctrl-c).
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
  - This keeps your extra files under the target directory.
  - Previously managed files are removed before syncing so deletions upstream are applied.
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

  TMP_DIR="$(mktemp -d)"

  echo "Fetching cursor configuration..." >&2
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMP_DIR" >/dev/null 2>&1

  mkdir -p "$PREFIX"

  # Remove previously managed files so deletions upstream are reflected.
  if [[ -f "$manifest_path" ]]; then
    while IFS= read -r rel_path; do
      [[ -z "$rel_path" ]] && continue
      rm -rf -- "$PREFIX/$rel_path"
    done < "$manifest_path"
  fi

  echo "Syncing into $PREFIX/..." >&2
  git -C "$TMP_DIR" archive --format=tar HEAD | tar -x -C "$PREFIX"

  # Write new manifest from tracked files.
  git -C "$TMP_DIR" ls-files > "$manifest_path"

  echo "Done." >&2
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Next: review changes, then run: git add \"$PREFIX\" && git commit" >&2
  fi
}

main() {
  local cmd
  cmd="${1:-install}"

  if [[ "$cmd" == "-h" || "$cmd" == "--help" ]]; then
    print_usage
    exit 0
  fi

  if [[ "$cmd" != "install" && "$cmd" != "update" ]]; then
    echo "Error: unknown command '$cmd'" >&2
    print_usage >&2
    exit 1
  fi

  if is_submodule_target; then
    echo "Error: '$PREFIX' is configured as a git submodule in this repository." >&2
    echo "Hint: run: git submodule update --remote --merge $PREFIX" >&2
    exit 1
  fi

  sync_now
}

main "$@"
