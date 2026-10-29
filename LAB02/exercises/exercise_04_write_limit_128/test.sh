#!/usr/bin/env bash
set -euo pipefail

proc_file=/proc/lab2_info

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

test -c /dev/lab2
test -r "$proc_file"
written=$(sudo python3 - <<'PY'
import os

fd = os.open("/dev/lab2", os.O_WRONLY)
try:
    print(os.write(fd, b"A" * 256))
finally:
    os.close(fd)
PY
)
buffer_len=$(awk -F ': *' '$1 == "buffer_len" { print $2 }' "$proc_file")

if (( written != 128 || buffer_len != 128 )); then
    printf 'FAIL: write returned %d and buffer_len is %d\n' "$written" "$buffer_len" >&2
    exit 1
fi

echo 'PASS: a 256-byte write was limited to 128 bytes'
