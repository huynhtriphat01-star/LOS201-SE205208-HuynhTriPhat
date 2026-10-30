# Lesson 13 - Protect reads with a mutex

## Goal

Protect the shared buffer and its length while reading. `lab2_read()` acquires
`buffer_lock` interruptibly before examining the buffer, and all paths after a
successful lock leave through a common `out` label that releases it. Writers use
the same mutex, preventing readers from seeing a partially updated buffer.

## Build

```bash
make
bash -n test.sh
grep -n 'mutex_.*buffer_lock' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The runtime script alternates two fixed-size payloads while repeatedly opening and
reading the device. Every read must equal one complete payload; a torn or partial
value fails the test.

Test output: `PASS: concurrent reads returned complete payloads`.

Run this on Linux as root with kernel headers matching the running kernel.
