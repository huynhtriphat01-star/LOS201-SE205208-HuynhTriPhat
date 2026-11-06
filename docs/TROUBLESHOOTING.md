# Troubleshooting

| Failure | Cause | Action |
|---|---|---|
| `No such file or directory: .../build` | missing kernel headers/tree | set `KDIR` to the target kernel build tree |
| `Exec format error` on `insmod` | wrong architecture or vermagic | compare `file`, `modinfo`, target `uname -r` |
| `Unknown symbol` | config/dependency mismatch | inspect `dmesg`, `modinfo`, `Module.symvers` |
| QEMU has no console | wrong UART argument | use `-nographic` and `console=ttyAMA0` |
| `No working init found` | bad init or dynamic loader absent | check `/init` mode, shebang, libraries |
| `mq_open: Invalid argument` | queue limit too small | inspect `/proc/sys/fs/mqueue/*` in the guest |
| `Operation not permitted` for FIFO | missing privilege | run with normal scheduling or grant only required capability |
| repeated reads return EOF | file offset reached end | reopen or seek only when driver supports it |
| sensor returns `EAGAIN` | minimum interval not elapsed | wait, poll, or use configured interval |

Read kernel failures from `dmesg`. Record the first decisive error, command,
environment, and exit code. Do not hide a build failure with stale binaries.
