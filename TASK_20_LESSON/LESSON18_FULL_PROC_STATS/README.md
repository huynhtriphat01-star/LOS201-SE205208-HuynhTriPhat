# Lesson 18 - Complete procfs statistics

## Goal

Extend `/proc/lab2_info` into one diagnostic snapshot containing the device name,
open/read/write counts, buffer length, cumulative byte totals, last successful
write timestamp and size, plus `EMPTY` or `DATA` status.

The proc callback holds `buffer_lock` while formatting buffer-related fields so
`buffer_len`, `last_write_size`, and `status` describe the same instant. Counters
remain atomic. The timestamp is Unix time in seconds.

## Build

```bash
make
bash -n test.sh
grep -n 'total_bytes_written\|last_write_size\|status:' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The runtime script writes and reads a known payload, checks every required procfs
key and its relevant values, then clears the buffer and confirms that status changes
from `DATA` to `EMPTY`.

Test output: `PASS: procfs exposes complete statistics and status`.

Run this on Linux as root with kernel headers matching the running kernel.
