# Lesson 17 - Last write size in sysfs

## Goal

Expose the number of payload bytes accepted by the most recent successful normal
write through the read-only `last_write_size` sysfs attribute. The value reflects
short writes, and a successful clear command resets it to zero. `READ_ONCE` and
`WRITE_ONCE` make the lockless sysfs read well-defined while writes update it under
the buffer mutex.

## Build

```bash
make
bash -n test.sh
grep -n 'last_write_size' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script checks the initial value after clearing, writes a seven-byte payload,
and verifies that the attribute changes to `7`.

Test output: `PASS: last_write_size changed from 0 to 7`.

Run this on Linux as root with kernel headers matching the running kernel.
