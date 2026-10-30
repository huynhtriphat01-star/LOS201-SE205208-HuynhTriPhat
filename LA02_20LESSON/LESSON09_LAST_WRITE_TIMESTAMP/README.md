# Exercise 09 - Last successful write timestamp

## Requirement

Record the wall-clock time of the last successful write and expose it through
`/proc/lab2_info`. This directory is a complete, independently buildable LAB02
driver snapshot.

## Implementation

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

Expected result: `PASS: last_write_timestamp=<value>`.

Runtime loading requires root privileges and a kernel compatible with the built
module. A successful build is not reported as a runtime pass unless this script is
actually executed.
