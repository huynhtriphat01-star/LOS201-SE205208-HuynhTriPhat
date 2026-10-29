#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

size_file=/sys/class/lab2/lab2/last_write_size
printf 'clear' | sudo tee /dev/lab2 >/dev/null
before=$(< "$size_file")
[[ "$before" -eq 0 ]]

printf '1234567' | sudo tee /dev/lab2 >/dev/null
after=$(< "$size_file")
if [[ "$after" -ne 7 ]]; then
    printf 'FAIL: expected last_write_size 7, got %s\n' "$after" >&2
    exit 1
fi

echo 'PASS: last_write_size changed from 0 to 7'
