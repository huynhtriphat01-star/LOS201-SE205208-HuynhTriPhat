#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

sudo python3 <<'PY'
import os

device = '/dev/lab2'

def write(payload: bytes) -> None:
    fd = os.open(device, os.O_WRONLY)
    try:
        if os.write(fd, payload) != len(payload):
            raise SystemExit('unexpected short write')
    finally:
        os.close(fd)

write(b'clear')
write(b'first')
reader = os.open(device, os.O_RDONLY)
try:
    if os.read(reader, 32) != b'first':
        raise SystemExit('first generation mismatch')
    if os.read(reader, 32) != b'':
        raise SystemExit('expected EOF after first generation')

    write(b'second')
    if os.read(reader, 32) != b'firstsecond':
        raise SystemExit('new generation did not rewind existing reader')
    if os.read(reader, 32) != b'':
        raise SystemExit('expected EOF after second generation')
finally:
    os.close(reader)
PY

echo 'PASS: each data generation is readable once per open file'
