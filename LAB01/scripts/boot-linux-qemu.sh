#!/usr/bin/env bash
set -euo pipefail

: "${KERNEL_IMAGE:?set KERNEL_IMAGE to zImage}"
: "${DTB_IMAGE:?set DTB_IMAGE to vexpress-v2p-ca9.dtb}"
: "${INITRAMFS_IMAGE:?set INITRAMFS_IMAGE to initramfs.cpio.gz}"

for artifact in "$KERNEL_IMAGE" "$DTB_IMAGE" "$INITRAMFS_IMAGE"; do
    [[ -r "$artifact" ]] || { printf 'missing artifact: %s\n' "$artifact" >&2; exit 1; }
done

exec qemu-system-arm \
    -M vexpress-a9 \
    -m 512M \
    -nographic \
    -kernel "$KERNEL_IMAGE" \
    -dtb "$DTB_IMAGE" \
    -initrd "$INITRAMFS_IMAGE" \
    -append 'console=ttyAMA0 rdinit=/init'
