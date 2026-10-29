# Exercise 02 - Write Counter in Procfs

## Requirement

Count successful `write()` operations on `/dev/lab2` and report the value as
`write_count` in `/proc/lab2_info`.

## Implementation

- Stores the statistic in `atomic_long_t write_count`.
- Increments it only after the buffer update succeeds.
- Reads it with `atomic_long_read()` in the procfs `seq_file` callback.

Failed copies, interrupted mutex acquisition, and rejected writes do not change
the counter.

## Build

```bash
make
```

## Runtime test

```bash
sudo ./test.sh
```

The script reads the initial procfs value, performs one successful write, then
checks that the counter increased by exactly one.

Expected final output:

```text
PASS: write_count increased by 1
```

Runtime testing requires root privileges and headers matching the running
kernel. A successful build is not reported as a successful runtime test.
