# Exercise 12 - Concurrency-safe open counter

## Requirement

Make the cumulative successful-open counter safe when several processes open the
device at the same time. `atomic_long_inc()` updates the value only after per-file
state allocation succeeds, and readers use `atomic_long_read()`.

`open_count` is cumulative rather than the number of descriptors currently open;
therefore `release()` does not decrement it and `reset_stats` does not alter it.

## Build

```bash
make
bash -n test.sh
grep -n 'atomic_long_.*open_count' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script starts 64 concurrent processes that each open `/dev/lab2`, then verifies
that `/proc/lab2_info` increased by exactly 64.

Expected result: `PASS: open_count increased by 64`.

Runtime loading requires root privileges and a compatible kernel. Compilation and
script syntax checks are not runtime execution.
