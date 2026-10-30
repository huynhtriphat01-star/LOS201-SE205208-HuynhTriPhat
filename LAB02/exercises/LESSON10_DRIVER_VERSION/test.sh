#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

version=$(< /sys/class/lab2/lab2/version)
if [[ "$version" != '1.0' ]]; then
    printf 'FAIL: expected version 1.0, got %q\n' "$version" >&2
    exit 1
fi

printf 'PASS: version=%s\n' "$version"
