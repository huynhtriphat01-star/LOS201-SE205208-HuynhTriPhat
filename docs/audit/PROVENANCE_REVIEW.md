# Provenance Review

## Method

The audit compared `git ls-tree -r HEAD` blob IDs at the commits recorded in
`docs/PROVENANCE.md`. A blob ID identifies bytes, not a filename or author.

## Result

- Portfolio tracked files: 258.
- Reference tracked files: 132.
- Unique blob IDs present in both: 70.
- Expanded matching path pairs: 111.
- The prior observation of 79 matches was not reproduced.

Matches occur across Assignment 01, core Assignment 02 application files,
LAB03 source/binaries/logs, and generated artifacts. Empty files and repeated
identical perf outputs inflate path-pair counts.

## Interpretation

No authorship accusation follows from this result. Possible explanations
include shared starter material, collaboration, common generated output,
copying in either direction, or a third shared source. Git history, assignment
instructions, licenses, and participant statements are needed to distinguish
them.

## Required follow-up

1. Identify instructor-provided starter files.
2. Record jointly authored work and collaborators.
3. Attribute authorized reuse at file or directory level.
4. Avoid adding a broad license until third-party rights are known.
5. Preserve current files until the academic record is clarified.
