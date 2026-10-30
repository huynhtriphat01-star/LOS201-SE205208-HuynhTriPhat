# Lesson 20 - ioctl buffer controls

## Goal

Add a shared ioctl ABI and a user-space verification program:

- `LAB2_GET_BUFFER_LEN` copies the current buffer length to a fixed-width `__u32`.
- `LAB2_CLEAR_BUFFER` clears the buffer, resets `last_write_size`, and publishes a
  new data generation.
- Unknown commands return `ENOTTY`; interrupted lock acquisition returns
  `ERESTARTSYS`.

This version keeps the earlier LAB02 features and uses the same
`lab2_ioctl.h` definitions in kernel and user space to prevent ABI drift.

## Build

```bash
make
bash -n test.sh
```

`make` builds both `lab2_driver.ko` and `ioctl_test` with warnings treated as errors
for the user-space program.

## Test

```bash
sudo ./test.sh
```

The script loads the module and runs `ioctl_test`, which clears the device, writes a
known payload, verifies its reported length, clears it through ioctl, and verifies
that the length becomes zero.

Test output: `PASS: GET_BUFFER_LEN and CLEAR_BUFFER work`.

Run this on Linux as root with kernel headers matching the running kernel.
