#!/usr/bin/env python3
"""Return project-scoped files whose content fingerprint has not been seen."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import uuid
from pathlib import Path


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(chunk)
    return value.hexdigest()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--kind", required=True)
    parser.add_argument("--root", action="append", required=True)
    parser.add_argument("--extension", action="append", required=True)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    project = Path(
        os.environ.get("EPIAGENTKIT_PROJECT_ROOT", Path.cwd())
    ).expanduser().resolve(strict=False)
    state_home = Path(
        os.environ.get(
            "EPIAGENTKIT_STATE_HOME",
            os.environ.get("EPICLAUDE_STATE_HOME", Path.home() / ".epiagentkit"),
        )
    ).expanduser()
    state_home.mkdir(parents=True, exist_ok=True)
    project_key = hashlib.sha256(str(project).casefold().encode("utf-8")).hexdigest()[:16]
    state_path = state_home / f".{args.kind}_{project_key}.json"
    extensions = {value.casefold() for value in args.extension}

    current: dict[str, str] = {}
    for raw_root in args.root:
        root = (project / raw_root).resolve(strict=False)
        if not root.is_dir():
            continue
        for path in sorted(root.rglob("*")):
            if path.is_file() and path.suffix.casefold() in extensions:
                relative = path.resolve(strict=False).relative_to(project).as_posix()
                current[relative] = digest(path)

    try:
        previous = json.loads(state_path.read_text(encoding="utf-8")).get("files", {})
    except (OSError, json.JSONDecodeError, AttributeError):
        previous = {}
    changed = [
        relative
        for relative, fingerprint in current.items()
        if previous.get(relative) != fingerprint
    ]

    temporary = state_path.with_name(f".{state_path.name}.{uuid.uuid4().hex}.tmp")
    temporary.write_text(
        json.dumps(
            {"project": str(project), "files": current},
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    os.replace(temporary, state_path)
    for relative in changed:
        print(relative)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
