# Lesson 16 - Configurable maximum size

## Goal

Add a read/write `max_size` sysfs attribute that controls the total usable buffer
size. Valid values are 1 through 1023 bytes, leaving one byte for the terminating
NUL. Zero, malformed values, and values at or above the 1024-byte allocation are
rejected with `EINVAL`.

The writer and sysfs reader use `READ_ONCE()` and updates use `WRITE_ONCE()` so the
scalar setting is accessed safely across concurrent contexts.

## Build

```bash
make
bash -n test.sh
grep -n 'DEVICE_ATTR_RW(max_size)' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script sets the limit to 10 bytes, confirms a 16-byte write is shortened to 10,
checks the stored data, and verifies that boundary values 0 and 1024 are rejected.

Test output: `PASS: max_size limits writes and rejects invalid values`.

Run this on Linux as root with Python 3 and matching kernel headers.
