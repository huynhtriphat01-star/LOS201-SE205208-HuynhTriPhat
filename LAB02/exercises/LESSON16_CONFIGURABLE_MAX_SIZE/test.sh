#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

max_file=/sys/class/lab2/lab2/max_size
printf '10\n' | sudo tee "$max_file" >/dev/null
[[ $(< "$max_file") -eq 10 ]]
printf 'clear' | sudo tee /dev/lab2 >/dev/null

printf '1\n' | sudo tee "$max_file" >/dev/null
printf 'x' | sudo tee /dev/lab2 >/dev/null
printf 'clear\n' | sudo tee /dev/lab2 >/dev/null
[[ $(< /sys/class/lab2/lab2/buffer_size) -eq 0 ]]
printf '10\n' | sudo tee "$max_file" >/dev/null

sudo python3 <<'PY'
import os

payload = b'0123456789abcdef'
fd = os.open('/dev/lab2', os.O_WRONLY)
try:
    written = os.write(fd, payload)
finally:
    os.close(fd)
if written != 10:
    raise SystemExit(f'expected short write of 10, got {written}')

fd = os.open('/dev/lab2', os.O_RDONLY)
try:
    actual = os.read(fd, 32)
finally:
    os.close(fd)
if actual != payload[:10]:
    raise SystemExit(f'unexpected buffer contents: {actual!r}')
PY

for invalid in 0 1024; do
    if printf '%s\n' "$invalid" | sudo tee "$max_file" >/dev/null 2>&1; then
        printf 'FAIL: invalid max_size %s was accepted\n' "$invalid" >&2
        exit 1
    fi
done

echo 'PASS: max_size limits writes and rejects invalid values'
