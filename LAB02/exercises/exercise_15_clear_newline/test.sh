#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

size_file=/sys/class/lab2/lab2/buffer_size

printf 'payload' | sudo tee /dev/lab2 >/dev/null
printf 'clear' | sudo tee /dev/lab2 >/dev/null
[[ $(< "$size_file") -eq 0 ]]

printf 'payload' | sudo tee /dev/lab2 >/dev/null
printf 'clear\n' | sudo tee /dev/lab2 >/dev/null
[[ $(< "$size_file") -eq 0 ]]

payload=$'clear\nextra'
printf '%s' "$payload" | sudo tee /dev/lab2 >/dev/null
actual=$(sudo dd if=/dev/lab2 bs=1 count=${#payload} status=none)
if [[ "$actual" != "$payload" ]]; then
    printf 'FAIL: longer clear-prefixed payload was not preserved\n' >&2
    exit 1
fi

echo 'PASS: exact clear commands accepted and prefix preserved'
