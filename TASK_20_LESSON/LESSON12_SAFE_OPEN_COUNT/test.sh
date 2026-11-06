#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

before=$(awk '/^open_count:/ { print $2 }' /proc/lab2_info)
workers=64

for ((i = 0; i < workers; i++)); do
    (exec 3</dev/lab2) &
done
wait

after=$(awk '/^open_count:/ { print $2 }' /proc/lab2_info)
delta=$((after - before))
if ((delta != workers)); then
    printf 'FAIL: expected open_count delta %d, got %d\n' "$workers" "$delta" >&2
    exit 1
fi

printf 'PASS: open_count increased by %d\n' "$delta"
