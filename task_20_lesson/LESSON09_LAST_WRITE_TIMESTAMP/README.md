# Lesson 09 - Last successful write timestamp

## Goal

Record the wall-clock time of the last successful write and expose it through
`/proc/lab2_info`. This lesson can be built separately.

## Changes

- `ktime_get_real_seconds()` records Unix time only after `copy_from_user()` succeeds.
- `/proc/lab2_info` reports the value as `last_write_timestamp`.
- The initial value is `0`, meaning no successful write has occurred yet.

## Build

```bash
make
bash -n test.sh
grep -n 'last_write_timestamp' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script loads the module, writes a payload, reads `/proc/lab2_info`, and checks
that `last_write_timestamp` is a positive Unix timestamp.

Test output: `PASS: last_write_timestamp=<value>`.

Run this on Linux as root with kernel headers matching the running kernel.
