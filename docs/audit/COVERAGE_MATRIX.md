# Coverage Matrix

| Topic | Evidence | Status | Verification gate |
|---|---|---|---|
| Boot flow and kernel parameters | `LAB01/README.md` | DOCUMENTED | boot to BusyBox shell |
| Kernel/U-Boot/BusyBox builds | build outline | INCOMPLETE | pinned commits and successful builds |
| Device Tree | LAB01 explanation | DOCUMENTED | boot with recorded DTB |
| Character registration and Kbuild | lessons, Assignment 01 | PRESENT | module build in matching guest |
| read/write/release/offset/EOF | lessons, Assignment 01 | PRESENT | guest integration tests |
| user-copy validation | driver sources | PRESENT | review and negative tests |
| procfs/sysfs | lessons, Assignment 01/02 | PRESENT | guest integration tests |
| mutexes and counters | lessons and assignments | PRESENT | concurrency tests |
| ioctl ABI | lesson 20, Assignment 01/02 | PRESENT | 32/64-bit compatibility review |
| MTD/JFFS2 | no portfolio implementation | INCOMPLETE | authoritative requirement plus guest test |
| GDB/Valgrind/strace/perf | LAB03 sources/logs | HISTORICAL | rebuild and rerun current commit |
| cyclictest/latency | LAB03 logs | HISTORICAL | controlled rerun with metadata |
| Assignment 01 | sources and logs | PRESENT | fresh ARM build and QEMU test |
| Assignment 02 pipeline | source and tests | PRESENT | fresh Linux build, tests, sanitizer |
| Exercise 21 min/max | absent | INCOMPLETE | independent specification and tests |
| Exercise 22 userspace ring interaction | absent | INCOMPLETE | independent specification and tests |

`PRESENT` means source exists. It does not mean the current commit passed runtime
validation. `HISTORICAL` means evidence exists but was not regenerated.
