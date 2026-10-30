# Exercise 15 - Handle `clear\n` exactly

## Requirement

Accept both `clear` and the shell-friendly `clear\n` as commands that empty the
device buffer. Matching is length-aware: strings such as `clearance` or
`clear\nextra` remain ordinary payloads instead of accidentally clearing data.

## Build

```bash
make
bash -n test.sh
grep -n 'is_clear_command' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script verifies the five-byte and newline-terminated forms, then confirms that
a longer string beginning with `clear\n` is stored as data.

Expected result: `PASS: exact clear commands accepted and prefix preserved`.

Runtime loading requires root privileges and a compatible kernel. Compilation and
script syntax checks alone do not count as a runtime pass.
