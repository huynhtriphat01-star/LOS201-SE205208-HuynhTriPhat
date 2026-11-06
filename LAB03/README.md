# LAB03 — Debugging and Performance

This lab contains small userspace targets and historical output from GDB,
Valgrind, strace, perf, and cyclictest-style latency experiments.

| Tool | Demonstrates | Interpretation limit |
|---|---|---|
| GDB | control flow, variables, crash location | one observed execution |
| Valgrind | invalid access and reachable/lost memory | depends on executed paths |
| strace | process/system-call boundary | not internal application logic |
| perf | sampled CPU events and hotspots | affected by permissions and workload |
| cyclictest | observed scheduling latency | not a hard real-time guarantee |

Rebuild sources on Linux before reproducing results. Treat committed binaries
and logs as historical. Record tool versions, command lines, exit status,
machine load, scheduler policy, and raw output for new evidence.
