# Technical Debt

| Severity | Path | Evidence | Recommended fix | Verification |
|---|---|---|---|---|
| High | repository-wide | no fresh Linux build in this environment | run Linux validation matrix | all commands record exit codes |
| High | `LAB02`, `ASSIGNMENT02` | duplicated snapshots and evidence | choose canonical source after provenance review | hash inventory and link audit |
| High | LAB03/assignments | tracked binaries and `.ko` may be stale | archive with manifest or rebuild policy | reproduce from clean checkout |
| High | provenance | 70 byte-identical blobs with reference | obtain course collaboration/attribution record | signed review or documented source |
| Medium | `ASSIGNMENT02/app` | queue saturation and shutdown need stress evidence | add bounded stress test on Linux | sanitizer plus forced-full queues |
| Medium | drivers | no compatible-kernel compilation result | build against pinned Linux source | zero compiler errors/warnings |
| Medium | LAB02 | MTD/JFFS2 missing | implement only if syllabus requires it | QEMU mount/read/write/unmount log |
| Medium | lessons | scripts load modules with `sudo` | keep out of CI; require isolated guest | manual guest-only run |
| Medium | all logs | many lack source/tool metadata | add evidence manifest format | reviewer reproduces result |
| Low | backups | committed `.bak*` files create ambiguity | archive after ownership review | canonical source documented |
| Low | naming | lesson directory was renamed to `TASK_20_LESSON` | keep links synchronized | all links pass |

No tracked evidence was deleted. Deletion would require a provenance decision
and a recoverable archive plan.
