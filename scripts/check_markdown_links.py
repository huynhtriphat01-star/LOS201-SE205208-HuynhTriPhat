#!/usr/bin/env python3
"""Check local Markdown link targets without network access."""

from __future__ import annotations

import argparse
import re
import tempfile
from pathlib import Path
from urllib.parse import unquote

LINK = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")


def local_target(raw: str) -> str | None:
    target = raw.strip().split(maxsplit=1)[0].strip("<>")
    if not target or target.startswith(("#", "http://", "https://", "mailto:")):
        return None
    return unquote(target.split("#", 1)[0])


def broken_links(root: Path) -> list[str]:
    failures: list[str] = []
    for document in sorted(root.rglob("*.md")):
        text = document.read_text(encoding="utf-8")
        for match in LINK.finditer(text):
            target = local_target(match.group(1))
            if target is None:
                continue
            resolved = (document.parent / target).resolve()
            if not resolved.exists():
                failures.append(f"{document.relative_to(root)}: {target}")
    return failures


def self_test() -> None:
    with tempfile.TemporaryDirectory() as directory:
        root = Path(directory)
        (root / "ok.md").write_text("[self](ok.md)\n[web](https://example.com)\n", encoding="utf-8")
        assert broken_links(root) == []
        (root / "bad.md").write_text("[missing](no.md)\n", encoding="utf-8")
        assert len(broken_links(root)) == 1


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", default=".")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        self_test()
        print("self-test: PASS")
        return 0
    root = Path(args.root).resolve()
    failures = broken_links(root)
    if failures:
        print("broken local Markdown links:")
        print("\n".join(failures))
        return 1
    print("local Markdown links: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
