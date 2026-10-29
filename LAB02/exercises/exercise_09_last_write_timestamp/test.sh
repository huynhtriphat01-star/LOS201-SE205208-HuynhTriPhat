#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

printf 'timestamp test' | sudo tee /dev/lab2 >/dev/null
timestamp=$(awk '/^last_write_timestamp:/ { print $2 }' /proc/lab2_info)

if [[ ! "$timestamp" =~ ^[0-9]+$ ]] || (( timestamp <= 0 )); then
    printf 'FAIL: invalid last_write_timestamp: %q\n' "$timestamp" >&2
    exit 1
fi

printf 'PASS: last_write_timestamp=%s\n' "$timestamp"
