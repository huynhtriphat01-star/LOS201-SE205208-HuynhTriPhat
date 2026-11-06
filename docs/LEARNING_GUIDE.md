# Learning Guide

1. Start with `LAB01`: explain reset, bootloader, kernel, DTB, initramfs, and init.
2. Study lessons 1–10: read/write semantics, bounds, procfs, and sysfs.
3. Study lessons 11–20: synchronization, counters, EOF, and ioctl ABI.
4. Review Assignment 01: trace one ioctl from userspace to validation and errno.
5. Review Assignment 02: trace one sample through every thread and queue.
6. Use LAB03: prove one bug with GDB, one leak with Valgrind, and one syscall path with strace.

## Interview checks

- Explain why user pointers cannot be dereferenced in kernel code.
- Explain partial reads, `*ppos`, and EOF.
- Show reverse-order cleanup after partial initialization.
- Distinguish mutexes, atomics, and lock-free claims.
- Define ABI compatibility for ioctl payloads.
- Explain queue backpressure and deterministic shutdown.
- Separate average latency, worst observed latency, and hard deadlines.
- State why historical output cannot prove the current commit.

Exercises 21 and 22 remain a candidate milestone. Implement them only from an
authoritative course requirement or an independently designed specification.
