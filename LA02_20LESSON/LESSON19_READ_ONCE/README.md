# Exercise 19 - Read once per data generation

## Requirement

Give each open file descriptor read-once semantics. Per-file state records the data
generation being read and whether that generation has been fully consumed. After a
complete read, further reads return EOF. A successful write increments the global
generation; the next read on the same descriptor detects the change, rewinds its
offset, and makes the new data available exactly once.

Partial reads remain supported: EOF is armed only after the descriptor reaches the
end of the current buffer.

## Build

```bash
make
bash -n test.sh
grep -n 'generation\|consumed' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The runtime test keeps one reader descriptor open, verifies EOF after consuming the
first payload, writes a second payload through another descriptor, and confirms
that the existing reader receives the new generation before returning EOF again.

Expected result: `PASS: each data generation is readable once per open file`.

Runtime loading requires root privileges, Python 3, and a compatible kernel.
Compilation and syntax checks alone do not count as a runtime pass.
