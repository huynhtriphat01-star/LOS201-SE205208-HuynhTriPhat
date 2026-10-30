# Exercise 07 - Total Bytes Read

## Requirement

Maintain a cumulative `total_bytes_read` statistic containing the number of
payload bytes successfully copied to userspace by `lab2_read()`.

## Implementation

- Stores the total in an `atomic_long_t` to avoid lost updates from concurrent
  readers.
- Adds `to_copy` only after `copy_to_user()` succeeds.
- Does not count EOF reads or failed copies.
- Keeps the statistic internal in this exercise; Exercise 18 later exposes it
  through `/proc/lab2_info`.

## Build and static verification

```bash
make
grep -n 'atomic_long_add(to_copy, &total_bytes_read)' lab2_driver.c
```

## Runtime smoke test

```bash
sudo ./test.sh
```

The script writes and reads a known six-byte payload, proving that the
successful read path used to update the statistic remains functional.

Expected final output:

```text
PASS: read returned the complete 6-byte payload
```

The counter is not exported in Exercise 07, so its numeric runtime value cannot
be observed through the public interfaces yet. Do not interpret this smoke test
as direct runtime verification of the internal counter.
