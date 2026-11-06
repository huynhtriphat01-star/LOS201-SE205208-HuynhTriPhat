# Provenance

## Compared repositories

- Portfolio: `huynhtriphat01-star/LOS201-SE205208-HuynhTriPhat`, commit
  `34ee14911f0ebc1b1bbfa7bf2b01e9f60975e767` at audit start.
- Reference: `hoangtrkhanh/LOS201_Lab`, commit
  `ba33e2ed71ea6b20a7de67f400f7e3ceff8181b3`, read only.

The reference was used to find topics and compare Git object identities. It is
not treated as authoritative, licensed for copying, or proof of authorship.

## Exact matches

The audit found **70 unique matching blob IDs**. Path-to-path expansion creates
111 pairs because repeated empty files and repeated identical logs produce a
Cartesian match. Earlier “79 matching blobs” was not reproduced at these
commits. Exact matches concentrate in Assignment 01, Assignment 02, LAB03,
compiled artifacts, and logs. See `docs/audit/PROVENANCE_REVIEW.md`.

An identical blob proves identical bytes only. It does not prove who created
the file, when it was shared, whether work was collaborative, or whether reuse
was authorized. Those questions require course records and author testimony.

## Repository-local duplication

`LAB02` contains a second snapshot of many `ASSIGNMENT02` driver, log, and
output files. It is retained to avoid deleting academic evidence. A future
cleanup should choose one canonical source and move historical evidence to a
documented archive with hashes.

## Generated evidence

Committed `.ko`, executables, initramfs archives, perf data, images, and logs
are historical. Their producing environment is often incomplete. New reports
must record command, source SHA, tool versions, exit code, and raw output.
