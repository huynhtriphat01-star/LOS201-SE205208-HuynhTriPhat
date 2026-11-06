#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

python3 scripts/check_markdown_links.py .

mapfile -d '' shell_files < <(find . -path ./.git -prune -o -type f -name '*.sh' -print0)
for file in "${shell_files[@]}"; do
    bash -n "$file"
done
printf 'bash syntax: PASS (%d files)\n' "${#shell_files[@]}"

if command -v shellcheck >/dev/null 2>&1; then
    shellcheck "${shell_files[@]}"
    printf 'ShellCheck: PASS\n'
else
    printf 'ShellCheck: BLOCKED (not installed)\n'
fi
