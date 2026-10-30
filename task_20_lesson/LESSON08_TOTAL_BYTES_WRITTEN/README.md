# Lesson 08 - Total bytes written

## Goal

Track the cumulative number of bytes successfully copied into the driver.
This lesson can be built separately.

## Changes

- `total_bytes_written` is an `atomic_long_t`, so concurrent writers can update it safely.
- The counter increases only after `copy_from_user()` succeeds.
- The increment uses the accepted write length, so rejected or truncated input is not over-counted.
- The statistic is kept internally at this stage and is exposed with the other counters in Lesson 18.

## Build

```bash
make
bash -n test.sh
grep -n 'total_bytes_written' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script loads the module, writes a known 12-byte payload, and verifies that the
device returns the same data. The counter itself is checked statically here because
it is not part of a user-visible interface until Lesson 18.

Test output: `PASS: 12 bytes written and read back successfully`.

Run this on Linux as root with kernel headers matching the running kernel.
