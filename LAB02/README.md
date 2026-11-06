# LAB02 — Character Devices and Filesystems

This directory currently holds a historical sensor-driver snapshot and evidence
that overlaps `ASSIGNMENT02`. The incremental character-driver curriculum is
under [`../LA02_20LESSON`](../LA02_20LESSON/README.md).

Covered there: module/Kbuild basics, read/write counts, buffer limits, procfs,
sysfs, mutexes, offsets, EOF, and ioctl. MTD/JFFS2 evidence exists only in the
reference repository and is **not implemented or verified here**.

Do not load these modules into the Windows host or an arbitrary Linux runner.
Build against the intended guest kernel and test inside a disposable VM/QEMU
guest. The duplicate source remains pending provenance-safe consolidation.
