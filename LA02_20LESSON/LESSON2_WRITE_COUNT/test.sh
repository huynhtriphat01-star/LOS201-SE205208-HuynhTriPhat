#!/usr/bin/env bash
set -euo pipefail

proc_file=/proc/lab2_info

read_count() {
    awk -F ': *' '$1 == "write_count" { print $2 }' "$proc_file"
}

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
test -r "$proc_file"
before=$(read_count)
test -n "$before"

printf 'hello LAB02' | sudo tee /dev/lab2 >/dev/null
after=$(read_count)

if (( after != before + 1 )); then
    printf 'FAIL: expected write_count=%d, got %d\n' "$((before + 1))" "$after" >&2
    exit 1
fi

echo 'PASS: write_count increased by 1'
