# Lesson 15 - Handle `clear\n` exactly

## Goal

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

Test output: `PASS: exact clear commands accepted and prefix preserved`.

Run this on Linux as root with kernel headers matching the running kernel.
