# Final Validation Report

**Date:** 2026-11-06 (Asia/Saigon)  
**Baseline:** `34ee14911f0ebc1b1bbfa7bf2b01e9f60975e767`  
**Branch:** `feat/los201-portfolio-upgrade`

## Baseline audit

The portfolio started with 258 tracked files, five major top-level study areas,
20 LAB02 lessons, no LAB01 directory, limited root documentation, committed
binaries/backups, and no fresh build capability on this Windows host.

The read-only reference has 132 files at
`ba33e2ed71ea6b20a7de67f400f7e3ceff8181b3`. Comparison found 70 unique
matching blob IDs, not the previously reported 79. See the audit documents for
method and interpretation.

## Changes

- Added independent LAB01 boot documentation and a guarded QEMU launcher.
- Replaced the root landing page with truthful navigation and status.
- Added architecture, environment, build, test, troubleshooting, learning, and provenance documents.
- Added main-area READMEs and four audit reports.
- Made kernel build paths, architecture, and cross-prefix configurable.
- Added Assignment 02 test build/run targets.
- Added a standard-library local Markdown link checker and safe verification script.
- Replaced four template author markers and one placeholder version string.
- Expanded `.gitignore` for future generated outputs without untracking evidence.

## Validation matrix

| Result | Command | Evidence |
|---|---|---|
| PASS | `python scripts/check_markdown_links.py --self-test` | self-test printed PASS |
| PASS | `python scripts/check_markdown_links.py .` | local links passed after report creation |
| PASS | `bash scripts/verify.sh` | local links and Bash syntax passed; ShellCheck blocked |
| PASS | `git diff --check` | no whitespace errors after correction |
| BLOCKED | `make -C ASSIGNMENT02/app host tests` | GCC and Make absent |
| BLOCKED | kernel module builds | WSL/Linux, kernel tree, Make, and cross-compiler absent |
| BLOCKED | QEMU boot | QEMU and locally built artifacts absent |
| NOT RUN | privileged module tests | isolated Linux guest required |

## Defects fixed

- Removed hard-coded personal kernel-tree defaults from four Makefiles.
- Added missing Assignment 02 unit-test build and runner targets.
- Removed unresolved student-ID and author placeholders in active source.
- Added fail-fast artifact checks before QEMU launch.
- Added automated local-link and shell-syntax validation.

## Remaining defects

- No fresh Linux compilation, sanitizer run, kernel build, module load, or QEMU boot.
- `LAB02` and `ASSIGNMENT02` still contain overlapping historical snapshots.
- Tracked binaries, `.ko`, backups, archives, perf data, and logs remain.
- MTD/JFFS2 and exercises 21–22 remain incomplete.
- Exact-match provenance needs instructor/student records.
- GitHub rendering of Mermaid was not checked through a browser.

## Assessment

**PARTIAL.** Documentation, auditability, configuration, and safe validation
improved. Runtime acceptance cannot be granted without a Linux/QEMU toolchain
and provenance decisions.
