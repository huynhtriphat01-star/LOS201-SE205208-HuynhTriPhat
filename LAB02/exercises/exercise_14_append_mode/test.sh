#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

printf 'clear' | sudo tee /dev/lab2 >/dev/null
printf 'hello ' | sudo tee /dev/lab2 >/dev/null
printf 'LAB02' | sudo tee /dev/lab2 >/dev/null
actual=$(sudo dd if=/dev/lab2 bs=1 count=11 status=none)

if [[ "$actual" != 'hello LAB02' ]]; then
    printf 'FAIL: expected appended value, got %q\n' "$actual" >&2
    exit 1
fi

echo 'PASS: separate writes were appended'
