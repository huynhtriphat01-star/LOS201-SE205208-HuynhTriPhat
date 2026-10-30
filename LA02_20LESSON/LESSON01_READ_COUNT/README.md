# Exercise 01 - Read Counter

## Requirement

Count every call to `read()` on `/dev/lab2` and expose the counter through the
read-only sysfs file `/sys/class/lab2/lab2/read_count`.

## Implementation

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

Expected final output:

```text
PASS: read_count increased by 2
```

Runtime testing requires root privileges and kernel headers matching the
running kernel. A successful build alone does not prove that module loading or
the sysfs interface works on the target board.
