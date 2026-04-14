#!/usr/bin/env python3
"""Validate YAML frontmatter schema for epiphany-prompt module files.

Required keys per spec: name, stage_id, input_dependencies, output_files,
scale_variants, kb_sources, activation, return_contract.
Usage: validate-frontmatter.py <path-to-module.md> [...]
Exit 0 if all files pass; 1 otherwise.
"""
from __future__ import annotations

import sys
import re
from pathlib import Path

REQUIRED_KEYS = {
    "name", "stage_id", "input_dependencies", "output_files",
    "scale_variants", "kb_sources", "activation", "return_contract",
}
VALID_STAGE_IDS = {
    "M12", "M3", "M4", "M5", "M4M5",
    "MSPEC12", "MSPEC3", "MSPEC4M5",
    "MPLAN12", "MPLAN3", "MPLAN4M5",
}

def extract_frontmatter(text: str) -> str | None:
    m = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
    return m.group(1) if m else None

def parse_top_level_keys(block: str) -> set[str]:
    # Top-level key lines only — ignore indented sub-keys and list items.
    keys = set()
    for line in block.splitlines():
        if line and not line.startswith((" ", "\t", "-", "#")):
            if ":" in line:
                keys.add(line.split(":", 1)[0].strip())
    return keys

def parse_stage_id(block: str) -> str | None:
    for line in block.splitlines():
        if line.startswith("stage_id:"):
            return line.split(":", 1)[1].strip()
    return None

def validate(path: Path) -> list[str]:
    errors: list[str] = []
    try:
        text = path.read_text()
    except FileNotFoundError:
        return [f"{path}: file not found"]
    except OSError as e:
        return [f"{path}: unreadable ({e.strerror})"]
    fm = extract_frontmatter(text)
    if fm is None:
        return [f"{path}: missing YAML frontmatter (no leading --- block)"]
    keys = parse_top_level_keys(fm)
    missing = REQUIRED_KEYS - keys
    if missing:
        errors.append(f"{path}: missing keys {sorted(missing)}")
    stage_id = parse_stage_id(fm)
    if stage_id and stage_id not in VALID_STAGE_IDS:
        errors.append(f"{path}: invalid stage_id '{stage_id}' (must be one of {sorted(VALID_STAGE_IDS)})")
    return errors

def main() -> int:
    if len(sys.argv) < 2:
        print("usage: validate-frontmatter.py <module.md> [...]", file=sys.stderr)
        return 2
    all_errors: list[str] = []
    for arg in sys.argv[1:]:
        all_errors.extend(validate(Path(arg)))
    if all_errors:
        for e in all_errors:
            print(e, file=sys.stderr)
        return 1
    print(f"OK: {len(sys.argv) - 1} file(s) passed frontmatter validation")
    return 0

if __name__ == "__main__":
    sys.exit(main())
