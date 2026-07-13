#!/usr/bin/env python3
"""Return project-scoped files whose content changed after a silent baseline."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import uuid
from pathlib import Path
from typing import Any, Callable


STATE_SCHEMA = 2


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(chunk)
    return value.hexdigest()


def discover(project: Path, roots: list[str], extensions: set[str]) -> dict[str, Path]:
    files: dict[str, Path] = {}
    for raw_root in roots:
        root = (project / raw_root).resolve(strict=False)
        if not root.is_dir():
            continue
        for path in sorted(root.rglob("*")):
            if path.is_file() and path.suffix.casefold() in extensions:
                relative = path.resolve(strict=False).relative_to(project).as_posix()
                files[relative] = path
    return files


def load_previous(state_path: Path) -> tuple[dict[str, Any], bool]:
    if not state_path.is_file():
        return {}, True
    try:
        payload = json.loads(state_path.read_text(encoding="utf-8"))
        files = payload.get("files")
    except (OSError, json.JSONDecodeError, AttributeError):
        return {}, True
    if not isinstance(files, dict):
        return {}, True
    return files, False


def update_fingerprints(
    files: dict[str, Path],
    previous: dict[str, Any],
    baseline: bool,
    hasher: Callable[[Path], str] = digest,
) -> tuple[dict[str, dict[str, Any]], list[str]]:
    current: dict[str, dict[str, Any]] = {}
    changed: list[str] = []
    for relative, path in files.items():
        stat = path.stat()
        old = previous.get(relative)
        if (
            isinstance(old, dict)
            and old.get("size") == stat.st_size
            and old.get("mtime_ns") == stat.st_mtime_ns
            and isinstance(old.get("sha256"), str)
        ):
            fingerprint = old["sha256"]
        else:
            fingerprint = hasher(path)
            old_fingerprint = old if isinstance(old, str) else old.get("sha256") if isinstance(old, dict) else None
            if not baseline and old_fingerprint != fingerprint:
                changed.append(relative)
        current[relative] = {
            "size": stat.st_size,
            "mtime_ns": stat.st_mtime_ns,
            "sha256": fingerprint,
        }
    return current, changed


def write_state(state_path: Path, project: Path, files: dict[str, dict[str, Any]]) -> None:
    state_path.parent.mkdir(parents=True, exist_ok=True)
    temporary = state_path.with_name(f".{state_path.name}.{uuid.uuid4().hex}.tmp")
    temporary.write_text(
        json.dumps(
            {"schema": STATE_SCHEMA, "project": str(project), "files": files},
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    os.replace(temporary, state_path)


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
    project_key = hashlib.sha256(str(project).casefold().encode("utf-8")).hexdigest()[:16]
    state_path = state_home / f".{args.kind}_{project_key}.json"
    extensions = {value.casefold() for value in args.extension}
    files = discover(project, args.root, extensions)
    previous, baseline = load_previous(state_path)
    current, changed = update_fingerprints(files, previous, baseline)
    write_state(state_path, project, current)
    for relative in changed:
        print(relative)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
