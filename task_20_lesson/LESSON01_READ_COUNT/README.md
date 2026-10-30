# Lesson 01 - Read Counter

## Goal

Count every call to `read()` on `/dev/lab2` and expose the counter through the
read-only sysfs file `/sys/class/lab2/lab2/read_count`.

## Changes

- Stores the counter in `atomic_long_t read_count`.
- Increments it at the beginning of `lab2_read()` so EOF reads are counted too.
- Registers `DEVICE_ATTR_RO(read_count)` in the device attribute group.

Atomic storage keeps simultaneous readers from losing increments.

## Build

```bash
make
```

## Runtime test

```bash
sudo ./test.sh
```

The script writes sample data, reads the device twice, and verifies that the
sysfs counter increased by exactly two. It always unloads the module on exit.

Test output:

```text
PASS: read_count increased by 2
```

Run this on Linux as root with kernel headers matching the running kernel.
