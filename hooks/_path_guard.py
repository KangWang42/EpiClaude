#!/usr/bin/env python3
"""Resolve edit targets and declared raw roots without parsing arbitrary shell code."""

from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path


RAW_ROOTS_FILE = ".epiagentkit-raw-roots"
PATCH_PATH = re.compile(r"^\*\*\* (?:Add|Update|Delete) File: (.+)$", re.MULTILINE)


def canonical(path: str, project: Path) -> Path:
    value = Path(path.strip().replace("\\", "/")).expanduser()
    if not value.is_absolute():
        value = project / value
    return value.resolve(strict=False)


def edit_paths(payload: str) -> list[str]:
    paths: list[str] = []
    explicit = os.environ.get("CLAUDE_TOOL_FILE_PATH", "")
    paths.extend(line for line in explicit.splitlines() if line.strip())
    try:
        data = json.loads(payload or "{}")
    except json.JSONDecodeError:
        data = {}
    if not isinstance(data, dict):
        data = {}
    tool_input = data.get("tool_input") or {}
    tool_response = data.get("tool_response") or {}
    if not isinstance(tool_input, dict):
        tool_input = {}
    if not isinstance(tool_response, dict):
        tool_response = {}
    direct = tool_input.get("file_path") or tool_response.get("filePath")
    if direct:
        paths.append(str(direct))
    command = str(tool_input.get("command") or "")
    paths.extend(PATCH_PATH.findall(command))
    return list(dict.fromkeys(paths))


def raw_roots(project: Path) -> list[Path]:
    roots = [canonical("01_data/rawdata", project)]
    config = project / RAW_ROOTS_FILE
    if config.is_file():
        for line in config.read_text(encoding="utf-8-sig").splitlines():
            value = line.strip()
            if value and not value.startswith("#"):
                roots.append(canonical(value, project))
    return list(dict.fromkeys(roots))


def inside(path: Path, root: Path) -> bool:
    return path == root or root in path.parents


def main() -> int:
    project = Path(
        os.environ.get("EPIAGENTKIT_PROJECT_ROOT", Path.cwd())
    ).expanduser().resolve(strict=False)
    payload = sys.stdin.read()
    targets = [canonical(path, project) for path in edit_paths(payload)]
    protected = raw_roots(project)
    for target in targets:
        if any(inside(target, root) for root in protected):
            print(target)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
