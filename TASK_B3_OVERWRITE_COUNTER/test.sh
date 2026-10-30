#!/usr/bin/env bash
set -euo pipefail

module=lab2_driver
device=/dev/lab2
attribute=/sys/class/lab2_class/lab2/overwrite_count

cleanup() {
    if lsmod | awk '{print $1}' | grep -qx "$module"; then
        rmmod "$module"
    fi
}
trap cleanup EXIT

insmod "./${module}.ko"
printf 'first\n' > "$device"
printf 'second\n' > "$device"
printf 'third\n' > "$device"

test "$(cat "$attribute")" = '2'
grep -Eq '^Overwrites[[:space:]]*: 2$' /proc/lab2_info

rmmod "$module"
trap - EXIT

if dmesg | tail -n 100 | grep -E 'BUG:|Oops:|WARNING:|lab2.*(error|failed)'; then
    echo 'FAIL: kernel log contains an error' >&2
    exit 1
fi

echo 'PASS: Task B3 overwrite_count is 2 in sysfs and procfs'
