# ASSIGNMENT01 — ioctl and Misc Devices

`task1_ioctl` implements a character device with read/write, procfs, sysfs, and
four ioctl operations. `task2_misc` demonstrates misc-device registration.

Build for the intended ARM guest:

```bash
make -C task1_ioctl KDIR=/opt/linux-5.15 \
  ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
make -C task2_misc KDIR=/opt/linux-5.15 \
  ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
```

Run `test_asgn1.sh` and `test_counter.sh` only in a disposable guest after
reviewing their privileged commands. Current `.ko`, executable, initramfs, and
logs are historical and were not regenerated during this upgrade.
