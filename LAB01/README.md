# LAB01 — Embedded Linux Boot

This lab documents a reproducible `vexpress-a9` boot pipeline. It does not
contain copied reference binaries or configs. Builds remain **NOT RUN** until
the required Linux environment and pinned source versions are available.

## Boot flow

```mermaid
flowchart LR
    QEMU --> UBoot[U-Boot]
    UBoot --> Kernel[zImage]
    UBoot --> DTB[vexpress-v2p-ca9.dtb]
    Kernel --> Initramfs[BusyBox initramfs]
    Initramfs --> Init[/init]
    Init --> Shell[/bin/sh]
```

## Inputs

Set paths and versions explicitly. Do not rely on personal home directories.

```bash
export LAB01_WORK="$PWD/work/lab01"
export KERNEL_SRC="$LAB01_WORK/linux"
export UBOOT_SRC="$LAB01_WORK/u-boot"
export BUSYBOX_SRC="$LAB01_WORK/busybox"
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
```

Record exact commits:

```bash
git -C "$KERNEL_SRC" rev-parse HEAD
git -C "$UBOOT_SRC" rev-parse HEAD
git -C "$BUSYBOX_SRC" rev-parse HEAD
qemu-system-arm --version
"${CROSS_COMPILE}gcc" --version
```

## Build outline

```bash
make -C "$KERNEL_SRC" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" vexpress_defconfig
make -C "$KERNEL_SRC" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" -j"$(nproc)" zImage dtbs
make -C "$UBOOT_SRC" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" vexpress_ca9x4_defconfig
make -C "$UBOOT_SRC" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" -j"$(nproc)"
make -C "$BUSYBOX_SRC" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" defconfig
make -C "$BUSYBOX_SRC" ARCH="$ARCH" CROSS_COMPILE="$CROSS_COMPILE" -j"$(nproc)"
```

Create the root filesystem, add `/init`, install BusyBox, then archive it with
`find . -print0 | cpio --null -ov --format=newc | gzip -9`. Keep device nodes
and permissions under review. `scripts/boot-linux-qemu.sh` validates required
artifacts before launching QEMU.

## Kernel command line

`console=ttyAMA0 rdinit=/init` sends output to the emulated PL011 UART and
starts the initramfs entry point. Add `panic=-1` only during diagnosis.

## Failure diagnosis

| Symptom | Likely cause | Check |
|---|---|---|
| No serial output | wrong console or machine | `-M vexpress-a9`, `console=ttyAMA0` |
| `VFS: Unable to mount root fs` | missing/bad initramfs | archive format, `-initrd`, kernel config |
| `No working init found` | missing `/init` or loader | executable bit, shebang, static linking |
| `Invalid magic number` | wrong U-Boot image command | image format and load address |
| DT probe failures | wrong DTB | DTB build target and QEMU machine |

## Verification gate

Capture full QEMU console output, exact commits, configs, and command line.
Success requires a BusyBox shell plus clean shutdown. No such run was made in
this upgrade.
