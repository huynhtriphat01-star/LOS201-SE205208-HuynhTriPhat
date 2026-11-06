# Build and Run

## Safe repository checks

```bash
./scripts/verify.sh
```

This checks local Markdown targets and Bash syntax. ShellCheck runs when
installed. It never loads a module.

## Assignment 02 userspace

```bash
make -C ASSIGNMENT02/app clean host tests
make -C ASSIGNMENT02/app test
./ASSIGNMENT02/app/bin/sms_app_x86 --mock --duration 5
```

The mock source is safe on a Linux host. The real source expects
`/dev/sms_sensor` and POSIX message queues.

Cross-build:

```bash
make -C ASSIGNMENT02/app arm ARM_CC=arm-linux-gnueabihf-gcc
```

## Kernel modules

Use a matching target kernel tree:

```bash
make -C ASSIGNMENT01/task1_ioctl \
  KDIR=/opt/linux-5.15 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
make -C ASSIGNMENT02/driver \
  KDIR=/opt/linux-5.15 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- arm
```

Copy modules into an isolated guest. Review scripts before running privileged
commands. Confirm `modinfo`, `uname -r`, and vermagic before `insmod`.

## QEMU boot

Build artifacts as described in `LAB01/README.md`, then run:

```bash
KERNEL_IMAGE=/path/to/zImage \
DTB_IMAGE=/path/to/vexpress-v2p-ca9.dtb \
INITRAMFS_IMAGE=/path/to/initramfs.cpio.gz \
./LAB01/scripts/boot-linux-qemu.sh
```

Exit QEMU with its monitor escape sequence. Save the complete console plus the
exact command, source SHAs, and configs.
