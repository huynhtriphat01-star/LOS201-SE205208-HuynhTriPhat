# Testing

Use four result labels: **PASS**, **FAIL**, **NOT RUN**, and **BLOCKED**. A log
without command, environment, source SHA, and exit status is historical
evidence, not a current PASS.

| Layer | Command | Current result |
|---|---|---|
| Python link checker self-test | `python scripts/check_markdown_links.py --self-test` | PASS on Windows, 2026-11-06 |
| Local Markdown links | `python scripts/check_markdown_links.py .` | Pending final run |
| Bash syntax | `bash -n` through `scripts/verify.sh` | Pending final run |
| ShellCheck | `shellcheck ...` | BLOCKED: tool absent |
| Assignment 02 host build | `make -C ASSIGNMENT02/app host tests` | BLOCKED: GCC/Make absent |
| Assignment 02 unit tests | `make -C ASSIGNMENT02/app test` | BLOCKED: Linux/GCC/Make absent |
| ARM userspace build | `make -C ASSIGNMENT02/app arm` | BLOCKED: cross-compiler absent |
| Kernel modules | module Makefiles with matching `KDIR` | BLOCKED: Linux kernel tree/toolchain absent |
| QEMU boot | `LAB01/scripts/boot-linux-qemu.sh` | BLOCKED: QEMU and artifacts absent |
| Module integration | reviewed guest-only scripts | NOT RUN; privileged and isolated guest required |

## Assignment 02 test intent

- `test_sensor`: CSV validation and mock producer behavior.
- `test_processor`: thresholds, rolling average, thread/buffer drain.
- `test_alert`: queue reception, alarm counters, log forwarding.
- `test_logger`: periodic flush and rotation.

Run sanitizers where supported:

```bash
make -C ASSIGNMENT02/app clean
make -C ASSIGNMENT02/app host tests \
  CFLAGS='-std=c11 -O1 -g -Wall -Wextra -Werror -pthread -fsanitize=address,undefined' \
  LDLIBS='-pthread -lrt -lm -fsanitize=address,undefined'
make -C ASSIGNMENT02/app test
```

Do not infer real-time guarantees from one `cyclictest` run. Report load,
scheduler, privileges, CPU affinity, sample count, and full latency histogram.
