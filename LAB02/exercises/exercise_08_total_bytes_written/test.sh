#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

payload='hello LAB02!'
printf '%s' "$payload" | sudo tee /dev/lab2 >/dev/null
actual=$(sudo dd if=/dev/lab2 bs=1 count=${#payload} status=none)

if [[ "$actual" != "$payload" ]]; then
    printf 'FAIL: expected %q, got %q\n' "$payload" "$actual" >&2
    exit 1
fi

printf 'PASS: %d bytes written and read back successfully\n' "${#payload}"
