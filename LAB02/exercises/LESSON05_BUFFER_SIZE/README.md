# Lesson 05 - Buffer Size Sysfs Attribute

## Goal

Expose the current number of data bytes stored in the device buffer through the
read-only file `/sys/class/lab2/lab2/buffer_size`.

## Changes

- Implements `buffer_size_show()` with `sysfs_emit()`.
- Returns `buffer_len`, excluding the trailing NUL byte.
- Registers the attribute with `DEVICE_ATTR_RO`, so userspace cannot modify the
  value.
- Adds the attribute to the device's existing sysfs group.

## Build

```bash
make
```

## Runtime test

```bash
sudo ./test.sh
```

The script verifies an empty initial value, writes nine bytes without a newline,
then checks that sysfs reports `9`.

Test output:

```text
PASS: buffer_size changed from 0 to 9
```

Run this on Linux as root with kernel headers matching the running kernel.
