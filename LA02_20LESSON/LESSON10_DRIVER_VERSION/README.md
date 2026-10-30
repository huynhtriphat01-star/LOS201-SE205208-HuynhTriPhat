# Exercise 10 - Driver version in sysfs

## Requirement

Add a read-only `version` attribute that returns `1.0` through the device's sysfs
group. This directory is a complete, independently buildable LAB02 driver snapshot.

## Interface

```text
/sys/class/lab2/lab2/version
```

The attribute is registered with `DEVICE_ATTR_RO`, so users can read it but cannot
change it.

## Build

```bash
make
bash -n test.sh
grep -n 'DEVICE_ATTR_RO(version)' lab2_driver.c
```

## Test

```bash
sudo ./test.sh
```

The script loads the module and asserts that reading the attribute returns exactly
`1.0`.

Expected result: `PASS: version=1.0`.

Runtime loading requires root privileges and a kernel compatible with the built
module. Compilation and script syntax checks do not count as a runtime pass.
