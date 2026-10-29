# Exercise 08 - Total bytes written

## Requirement

Track the cumulative number of bytes successfully copied into the driver.
This directory is a complete, independently buildable LAB02 driver snapshot.

## Implementation

- `total_bytes_written` is an `atomic_long_t`, so concurrent writers can update it safely.
- The counter increases only after `copy_from_user()` succeeds.
- The increment uses the accepted write length, so rejected or truncated input is not over-counted.
- The statistic is kept internally at this stage and is exposed with the other counters in Exercise 18.

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
it is not part of a user-visible interface until Exercise 18.

Expected result: `PASS: 12 bytes written and read back successfully`.

Runtime loading requires root privileges and a kernel compatible with the built
module. A successful `make` validates compilation only; it does not imply that the
runtime script was executed.
