# Exercise 13 - Protect reads with a mutex

## Requirement

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

Expected result: `PASS: concurrent reads returned complete payloads`.

Runtime loading requires root privileges and a kernel compatible with the module.
Compilation and syntax checks alone are not a runtime pass.
