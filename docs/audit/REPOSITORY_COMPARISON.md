# Repository Comparison

## Fixed baseline

| Repository | Commit | Tracked files | Main top-level areas |
|---|---|---:|---|
| Portfolio | `34ee14911f0ebc1b1bbfa7bf2b01e9f60975e767` | 258 | Assignment 01/02, LAB02/03, 20 lessons |
| Reference | `ba33e2ed71ea6b20a7de67f400f7e3ceff8181b3` | 132 | lab01/02/03, asgn01/02, 22 review files |

Counts use `git ls-files`; they exclude `.git` and untracked files.

## Material differences

| Area | Portfolio | Reference | Decision |
|---|---|---|---|
| LAB01 | absent at baseline | configs, outputs, logs, boot script | add independent documentation and launcher; do not copy artifacts |
| LAB02 | 20 documented incremental lessons plus duplicate sensor snapshot | one driver, init scripts, MTD/JFFS2 logs | keep lessons; mark MTD/JFFS2 incomplete |
| Exercises 21–22 | absent | two standalone C files | do not copy; wait for authoritative specification |
| LAB03 | sources, binaries, extensive logs | substantially matching evidence | document evidence limits and provenance |
| Assignment 01 | enhanced driver source plus historical outputs | overlapping structure and blobs | keep; expose configurable build inputs |
| Assignment 02 | source, tests, backups, logs | core source and tests overlap | keep functioning code; document exact matches |
| Documentation | root overview plus lesson READMEs | minimal root README | add navigation, architecture, build, test, provenance docs |

## File types

Portfolio totals include 86 `.txt`, 42 `.c`, 22 `.sh`, 22 `.md`, 11 `.h`,
four `.ko`, four `.gz`, many backup files, executables, and perf data. Reference
totals include 43 `.c`, 40 `.txt`, nine `.h`, six `.sh`, three `.ko`, four
`.gz`, three configs, one DTB, and two Markdown files.

## Conclusions

The portfolio has more instructional documentation and local history, but it
lacked LAB01 and cross-cutting reproducibility guidance. The reference exposes
coverage gaps but also shares many byte-identical files. It cannot serve as an
unquestioned correctness or authorship authority.
