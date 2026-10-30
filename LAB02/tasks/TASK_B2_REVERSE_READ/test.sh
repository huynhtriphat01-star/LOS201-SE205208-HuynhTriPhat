#!/usr/bin/env bash
set -euo pipefail

module=lab2_driver
device=/dev/lab2
attribute=/sys/class/lab2_class/lab2/reverse_read

cleanup() {
    if lsmod | awk '{print $1}' | grep -qx "$module"; then
        rmmod "$module"
    fi
}
trap cleanup EXIT

insmod "./${module}.ko"
printf 'abc' > "$device"

printf '1\n' > "$attribute"
test "$(cat "$device")" = 'cba'

printf '0\n' > "$attribute"
test "$(cat "$device")" = 'abc'

if printf '2\n' > "$attribute" 2>/dev/null; then
    echo 'FAIL: reverse_read accepted value 2' >&2
    exit 1
fi

rmmod "$module"
trap - EXIT

if dmesg | tail -n 100 | grep -E 'BUG:|Oops:|WARNING:|lab2.*(error|failed)'; then
    echo 'FAIL: kernel log contains an error' >&2
    exit 1
fi

echo 'PASS: Task B2 reverse_read=0/1, invalid value rejected'
