# Lesson 11 - Reset statistics through sysfs

## Goal

Add a write-only `reset_stats` sysfs control. Writing the exact command `reset`
clears the read/write counters and cumulative byte totals. Invalid commands return
`EINVAL`. The live `open_count` is intentionally not reset because it represents
current device state, not historical statistics.

## Interface

```bash
echo reset | sudo tee /sys/class/lab2/lab2/reset_stats
```

## Build

```bash
make
bash -n test.sh
grep -n 'DEVICE_ATTR_WO(reset_stats)' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script first creates non-zero read/write counters, writes `reset`, and verifies
that the exposed counters return to zero. It also checks that an invalid command is
rejected.

Test output: `PASS: statistics reset and invalid command rejected`.

Run this on Linux as root with kernel headers matching the running kernel.
