#!/usr/bin/env bash
set -euo pipefail

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
printf 'ABCDEF' | sudo tee /dev/lab2 >/dev/null
actual=$(sudo dd if=/dev/lab2 bs=6 count=1 status=none)

if [[ $actual != ABCDEF ]]; then
    printf 'FAIL: expected ABCDEF, got %s\n' "$actual" >&2
    exit 1
fi

echo 'PASS: read returned the complete 6-byte payload'
