#!/usr/bin/env bash
set -euo pipefail

proc_file=/proc/lab2_info

buffer_length() {
    awk -F ': *' '$1 == "buffer_len" { print $2 }' "$proc_file"
}

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
test -r "$proc_file"
printf 'sample data' | sudo tee /dev/lab2 >/dev/null
before=$(buffer_length)
test -n "$before"
(( before > 0 ))

printf 'clear' | sudo tee /dev/lab2 >/dev/null
after=$(buffer_length)

if (( after != 0 )); then
    printf 'FAIL: expected buffer_len=0, got %d\n' "$after" >&2
    exit 1
fi

echo 'PASS: clear command emptied the buffer'
