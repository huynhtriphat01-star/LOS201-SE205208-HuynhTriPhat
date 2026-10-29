#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

printf 'reset test' | sudo tee /dev/lab2 >/dev/null
sudo dd if=/dev/lab2 of=/dev/null bs=1 count=10 status=none

before_read=$(< /sys/class/lab2/lab2/read_count)
before_write=$(awk '/^write_count:/ { print $2 }' /proc/lab2_info)
[[ "$before_read" -gt 0 && "$before_write" -gt 0 ]]

printf 'reset\n' | sudo tee /sys/class/lab2/lab2/reset_stats >/dev/null
after_read=$(< /sys/class/lab2/lab2/read_count)
after_write=$(awk '/^write_count:/ { print $2 }' /proc/lab2_info)
[[ "$after_read" -eq 0 && "$after_write" -eq 0 ]]

if printf 'invalid\n' | sudo tee /sys/class/lab2/lab2/reset_stats >/dev/null 2>&1; then
    echo 'FAIL: invalid reset command was accepted' >&2
    exit 1
fi

echo 'PASS: statistics reset and invalid command rejected'
