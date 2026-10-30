# Lesson 06 - Buffer Status Sysfs Attribute

## Goal

Expose `/sys/class/lab2/lab2/status` as `EMPTY` when no bytes are stored and
`DATA` when the device buffer contains data.

## Changes

- Implements a read-only `status_show()` callback.
- Derives the state directly from `buffer_len`, avoiding a duplicate flag that
  could become inconsistent.
- Uses `sysfs_emit()` and includes the conventional trailing newline.
- Registers the attribute in the device's sysfs group.

## Build

```bash
make
```

## Runtime test

```bash
sudo ./test.sh
```

The script checks that a newly loaded module reports `EMPTY`, writes one byte,
then verifies the value changes to `DATA`.

Test output:

```text
PASS: status changed from EMPTY to DATA
```

Run this on Linux as root with kernel headers matching the running kernel.
