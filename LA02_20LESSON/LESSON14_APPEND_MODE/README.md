# Lesson 14 - Append mode

## Goal

Change normal writes from replacement to append behavior. While holding
`buffer_lock`, the driver chooses the current `buffer_len` as the destination
offset, copies only the remaining capacity, updates the terminator, and returns a
short write when the payload does not fully fit. A write to a full buffer returns
`ENOSPC`.

The earlier `clear` command remains available to start a new append sequence.

## Build

```bash
make
bash -n test.sh
grep -n 'offset = buffer_len' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The runtime script clears the device, writes `hello ` and `LAB02` separately, then
verifies that a fresh read returns `hello LAB02`.

Test output: `PASS: separate writes were appended`.

Run this on Linux as root with kernel headers matching the running kernel.
