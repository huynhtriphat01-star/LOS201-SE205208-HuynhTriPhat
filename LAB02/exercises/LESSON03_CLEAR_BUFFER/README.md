# Lesson 03 - Clear the Device Buffer

## Goal

Treat the exact five-byte write command `clear` as a control operation that
zeros `device_buffer` and sets `buffer_len` to zero. Other input remains normal
device data.

## Changes

- Copies userspace input into a temporary, NUL-terminated kernel buffer.
- Compares both the command length and bytes, avoiding prefix matches such as
  `clearance`.
- Clears the buffer while holding `buffer_lock`.
- Counts the accepted command as a successful write.

Exercise 15 later extends the command parser to accept the newline produced by
`echo clear`.

## Build

```bash
make
```

## Runtime test

```bash
sudo ./test.sh
```

The script stores sample data, confirms a non-zero `buffer_len`, writes the
exact command with `printf` (no newline), then verifies `buffer_len` is zero.

Test output:

```text
PASS: clear command emptied the buffer
```

Run this on Linux as root with kernel headers matching the running kernel.
