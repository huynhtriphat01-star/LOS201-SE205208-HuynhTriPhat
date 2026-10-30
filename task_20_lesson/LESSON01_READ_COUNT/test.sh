#!/usr/bin/env bash
set -euo pipefail

sysfs=/sys/class/lab2/lab2/read_count

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
test -r "$sysfs"
printf 'hello LAB02' | sudo tee /dev/lab2 >/dev/null

before=$(<"$sysfs")
cat /dev/lab2 >/dev/null
cat /dev/lab2 >/dev/null
after=$(<"$sysfs")

if (( after != before + 2 )); then
    printf 'FAIL: expected read_count=%d, got %d\n' "$((before + 2))" "$after" >&2
    exit 1
fi

echo 'PASS: read_count increased by 2'
