#!/usr/bin/env bash
set -euo pipefail

sysfs=/sys/class/lab2/lab2/status

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
test -r "$sysfs"
before=$(<"$sysfs")
if [[ $before != EMPTY ]]; then
    printf 'FAIL: expected initial status EMPTY, got %s\n' "$before" >&2
    exit 1
fi

printf 'X' | sudo tee /dev/lab2 >/dev/null
after=$(<"$sysfs")
if [[ $after != DATA ]]; then
    printf 'FAIL: expected status DATA, got %s\n' "$after" >&2
    exit 1
fi

echo 'PASS: status changed from EMPTY to DATA'
