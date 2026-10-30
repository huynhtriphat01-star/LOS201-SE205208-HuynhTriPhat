#!/usr/bin/env bash
set -euo pipefail
sudo insmod ./lab2_driver.ko
trap 'sudo rmmod lab2_driver 2>/dev/null || true' EXIT

sudo bash <<'EOF'
set -euo pipefail
a='AAAAAAAAAAAAAAAA'
b='BBBBBBBBBBBBBBBB'
printf '%s' "$a" > /dev/lab2

(
    for ((i = 0; i < 200; i++)); do
        if ((i % 2)); then printf '%s' "$a" > /dev/lab2
        else printf '%s' "$b" > /dev/lab2
        fi
    done
) &
writer=$!

for ((i = 0; i < 200; i++)); do
    value=$(dd if=/dev/lab2 bs=16 count=1 status=none)
    if [[ "$value" != "$a" && "$value" != "$b" ]]; then
        printf 'FAIL: observed incomplete payload %q\n' "$value" >&2
        wait "$writer" || true
        exit 1
    fi
done
wait "$writer"
EOF

echo 'PASS: concurrent reads returned complete payloads'
