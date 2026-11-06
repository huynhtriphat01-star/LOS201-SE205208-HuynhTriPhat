# LOS201 Embedded Linux Portfolio

**Author:** Huynh Tri Phat (`SE205208`)<br>
**Course:** LOS201 — Embedded Linux Systems

This repository collects boot-flow notes, Linux character drivers, debugging
experiments, and a threaded sensor-monitoring assignment. It targets Linux on
ARMv7-A (`vexpress-a9`) while keeping safe userspace checks runnable on a Linux
host. Historical logs and binaries are evidence, not proof that current source
still builds.

## Scope and status

| Area | Topics | Current status |
|---|---|---|
| [LAB01](LAB01/README.md) | kernel, U-Boot, BusyBox, initramfs, DTB, QEMU | Documented scaffold; build and boot not rerun |
| [LAB02](LAB02/README.md) | character drivers and filesystem work | Partial; duplicate sensor snapshot needs consolidation |
| [20 lessons](LA02_20LESSON/README.md) | incremental driver APIs | 20 exercises present; kernel execution not rerun |
| [LAB03](LAB03/README.md) | GDB, Valgrind, strace, perf, cyclictest | Sources and historical evidence present |
| [ASSIGNMENT01](ASSIGNMENT01/README.md) | ioctl and misc drivers | Source present; ARM build not rerun |
| [ASSIGNMENT02](ASSIGNMENT02/README.md) | sensor pipeline, threads, IPC | Substantial source and tests; build not rerun here |

The verified coverage matrix is in
[`docs/audit/COVERAGE_MATRIX.md`](docs/audit/COVERAGE_MATRIX.md). Missing work
is marked incomplete instead of inferred from the reference repository.

## Architecture

```mermaid
flowchart LR
    Boot[U-Boot] --> Kernel[Linux kernel + DTB]
    Kernel --> Init[BusyBox initramfs]
    Driver[Kernel sensor/character driver] --> Dev[/dev interface]
    Dev --> Sensor[Sensor thread]
    Sensor --> Buffer[Circular buffer]
    Buffer --> Processor[Processor thread]
    Processor --> Alert[POSIX queue: alerts]
    Processor --> Logger[POSIX queue: logs]
```

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for boot, driver, ioctl,
thread, ownership, and shutdown details.

## Environment

Use a Linux VM or dedicated QEMU development machine. Do not load training
modules into a production host kernel. Required tools and version capture are
documented in [`docs/ENVIRONMENT_SETUP.md`](docs/ENVIRONMENT_SETUP.md).

Typical packages on Debian/Ubuntu:

```bash
sudo apt update
sudo apt install build-essential git python3 shellcheck \
  qemu-system-arm gcc-arm-linux-gnueabihf gdb-multiarch \
  valgrind strace linux-perf rt-tests
```

Kernel module builds also require a compatible kernel source tree or headers.

## Quick start

Run non-privileged repository checks first:

```bash
./scripts/verify.sh
```

Build the Assignment 02 host application and tests:

```bash
make -C ASSIGNMENT02/app host tests
make -C ASSIGNMENT02/app test
./ASSIGNMENT02/app/bin/sms_app_x86 --mock --duration 5
```

Cross-build a module only after setting the kernel tree explicitly:

```bash
make -C ASSIGNMENT01/task1_ioctl \
  KDIR=/opt/linux-5.15 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
```

Commands, execution environments, and expected outputs are separated in
[`docs/BUILD_AND_RUN.md`](docs/BUILD_AND_RUN.md). Test classifications appear
in [`docs/TESTING.md`](docs/TESTING.md).

## Navigation

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — system design and diagrams.
- [`docs/ENVIRONMENT_SETUP.md`](docs/ENVIRONMENT_SETUP.md) — dependencies and version capture.
- [`docs/BUILD_AND_RUN.md`](docs/BUILD_AND_RUN.md) — host, ARM, QEMU, and module commands.
- [`docs/TESTING.md`](docs/TESTING.md) — safe test layers and result policy.
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) — common build and boot failures.
- [`docs/LEARNING_GUIDE.md`](docs/LEARNING_GUIDE.md) — interview-oriented learning path.
- [`docs/PROVENANCE.md`](docs/PROVENANCE.md) — source and evidence boundaries.
- [`docs/audit/REPOSITORY_COMPARISON.md`](docs/audit/REPOSITORY_COMPARISON.md) — checked-commit comparison.
- [`docs/audit/TECHNICAL_DEBT.md`](docs/audit/TECHNICAL_DEBT.md) — ranked defects and gates.
- [`docs/FINAL_VALIDATION_REPORT.md`](docs/FINAL_VALIDATION_REPORT.md) — current validation record.

## Known limitations

- This Windows machine has no WSL, GCC, Make, QEMU, ShellCheck, or Valgrind.
- Kernel modules and QEMU images were not rebuilt or booted during this upgrade.
- Committed binaries, `.ko` files, initramfs archives, and logs are historical.
- `LAB02` overlaps with `ASSIGNMENT02`; it remains unchanged pending provenance review.
- Exercises 21 and 22 are not implemented. No authoritative course specification was available.

## References

- [Linux kernel documentation](https://docs.kernel.org/)
- [QEMU ARM system emulator](https://www.qemu.org/docs/master/system/target-arm.html)
- [BusyBox documentation](https://busybox.net/downloads/BusyBox.html)
- [U-Boot documentation](https://docs.u-boot.org/)

## Provenance and project status

The comparison repository is used only as a coverage signal. Exact Git blob
matches are recorded without unsupported authorship claims. See
[`docs/PROVENANCE.md`](docs/PROVENANCE.md).

**Assessment: PARTIAL.** Navigation and reproducibility guidance are improved,
but Linux compilation, module testing, and QEMU boot remain blocked here.
