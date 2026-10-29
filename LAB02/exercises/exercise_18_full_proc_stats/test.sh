#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

payload='proc-stats'
printf '%s' "$payload" | sudo tee /dev/lab2 >/dev/null
sudo dd if=/dev/lab2 of=/dev/null bs=1 count=${#payload} status=none
info=$(< /proc/lab2_info)

for key in device open_count buffer_len write_count last_write_timestamp \
           read_count total_bytes_read total_bytes_written last_write_size status; do
    grep -q "^${key}:" <<<"$info" || {
        printf 'FAIL: missing procfs key %s\n' "$key" >&2
        exit 1
    }
done

grep -q "^buffer_len: ${#payload}$" <<<"$info"
grep -q "^last_write_size: ${#payload}$" <<<"$info"
grep -q '^status: DATA$' <<<"$info"
timestamp=$(awk '/^last_write_timestamp:/ { print $2 }' <<<"$info")
[[ "$timestamp" =~ ^[0-9]+$ && "$timestamp" -gt 0 ]]

printf 'clear' | sudo tee /dev/lab2 >/dev/null
grep -q '^status: EMPTY$' /proc/lab2_info

echo 'PASS: procfs exposes complete statistics and status'
