# Environment Setup

Use a Linux VM or dedicated development host. Windows alone cannot build or
run these POSIX and kernel exercises.

## Supported roles

| Environment | Purpose |
|---|---|
| Linux x86-64 | userspace builds, unit tests, static checks |
| ARM cross-toolchain | ARM userspace and kernel modules |
| QEMU `vexpress-a9` | isolated ARM boot and integration tests |
| Matching Linux source/headers | kernel module compilation |

Install the packages listed in the root README. Package names vary by release.
Do not assume `/lib/modules/$(uname -r)/build` can cross-build ARM modules.

## Capture versions

```bash
uname -a
git --version
gcc --version
arm-linux-gnueabihf-gcc --version
make --version
qemu-system-arm --version
shellcheck --version
valgrind --version
strace --version
perf --version
```

For source-built components, record `git rev-parse HEAD`. For module builds,
record kernel `VERSION`, `PATCHLEVEL`, local config, compiler, `ARCH`, and
`CROSS_COMPILE`. A `.ko` built for another kernel can fail vermagic checks.

## Safety

- Run repository checks and userspace tests without root.
- Load modules only in a disposable VM or QEMU guest.
- Review every `test.sh` before its `sudo insmod` call.
- Never treat old logs as results from current source.
