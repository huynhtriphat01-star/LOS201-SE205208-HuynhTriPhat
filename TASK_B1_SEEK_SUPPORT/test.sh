#!/usr/bin/env bash
set -euo pipefail

sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

sudo python3 <<'PY'
import errno
import os

fd = os.open('/dev/lab2', os.O_RDWR)
try:
    assert os.write(fd, b'ABCDEFGH') == 8
    assert os.lseek(fd, 3, os.SEEK_SET) == 3
    assert os.read(fd, 2) == b'DE'
    assert os.lseek(fd, -2, os.SEEK_END) == 6
    assert os.read(fd, 2) == b'GH'

    assert os.lseek(fd, 2, os.SEEK_SET) == 2
    try:
        os.lseek(fd, 20, os.SEEK_SET)
    except OSError as exc:
        assert exc.errno == errno.EINVAL
    else:
        raise AssertionError('out-of-range seek unexpectedly succeeded')
    assert os.lseek(fd, 0, os.SEEK_CUR) == 2
finally:
    os.close(fd)
PY

sudo rmmod lab2_driver
trap - EXIT
if sudo dmesg | tail -40 | grep -E 'BUG:|Oops:|WARNING:|lab2.*error'; then
    echo 'FAIL: kernel reported an error' >&2
    exit 1
fi
echo 'PASS: TASK B1 seek support'
