# Exercise 04 - Limit Writes to 128 Bytes

## Requirement

Limit a single `write()` system call to at most 128 bytes instead of accepting
up to the full device-buffer capacity.

## Implementation

- Selects a 128-byte write limit for this exercise.
- Copies at most that limit from userspace.
- Returns the number of bytes actually accepted, preserving normal partial-write
  semantics.
- Keeps the final NUL terminator outside the reported payload length.

## Build

```bash
make
```

## Runtime test

```bash
sudo ./test.sh
```

The script performs exactly one 256-byte `write()` using Python's `os.write()`.
It verifies that the syscall returns 128 and procfs reports `buffer_len: 128`.

Expected final output:

```text
PASS: a 256-byte write was limited to 128 bytes
```

Runtime testing requires root privileges and matching kernel headers. The module
build performed by `make` does not by itself validate device runtime behavior.
