#!/usr/bin/env bash
set -euo pipefail

sysfs=/sys/class/lab2/lab2/buffer_size

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
test -r "$sysfs"
before=$(<"$sysfs")
if (( before != 0 )); then
    printf 'FAIL: expected initial buffer_size=0, got %d\n' "$before" >&2
    exit 1
fi

printf '123456789' | sudo tee /dev/lab2 >/dev/null
after=$(<"$sysfs")
if (( after != 9 )); then
    printf 'FAIL: expected buffer_size=9, got %d\n' "$after" >&2
    exit 1
fi

echo 'PASS: buffer_size changed from 0 to 9'
