#!/usr/bin/env python3
"""Synchronize EpiClaude-owned rules, skills, and hook scripts to user homes."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import stat
from pathlib import Path


SKILL_MANIFEST = ".epiclaude-managed-skills.json"
HOOK_MANIFEST = ".epiclaude-managed-hooks.json"
CODEX_EXCLUDES = {"skill-creator"}


def remove_readonly(func, path: str, _exc_info) -> None:
    """Retry removal after clearing a Windows read-only attribute."""
    os.chmod(path, stat.S_IWRITE)
    func(path)


def same_path(left: Path, right: Path) -> bool:
    return left.expanduser().resolve() == right.expanduser().resolve()


def safe_remove(path: Path, parent: Path, dry_run: bool) -> None:
    resolved = path.expanduser().resolve()
    root = parent.expanduser().resolve()
    if resolved.parent != root:
        raise RuntimeError(f"Refusing to remove path outside target root: {resolved}")
    print(f"REMOVE {resolved}")
    if not dry_run:
        shutil.rmtree(resolved, onerror=remove_readonly)


def read_manifest(path: Path) -> set[str]:
    if not path.exists():
        return set()
    data = json.loads(path.read_text(encoding="utf-8"))
    return set(data.get("managed", []))


def write_manifest(path: Path, values: list[str], dry_run: bool) -> None:
    print(f"WRITE  {path}")
    if not dry_run:
        path.write_text(
            json.dumps({"managed": values}, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )


def sync_file(source: Path, target: Path, dry_run: bool) -> None:
    if same_path(source, target):
        print(f"SOURCE {source} (already active)")
        return
    print(f"COPY   {source} -> {target}")
    if not dry_run:
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, target)


def source_skills(root: Path, exclude: set[str]) -> dict[str, Path]:
    result: dict[str, Path] = {}
    for item in sorted((root / "skills").iterdir()):
        if item.is_dir() and item.name not in exclude and (item / "SKILL.md").is_file():
            result[item.name] = item
    return result


def sync_skills(
    root: Path,
    target: Path,
    exclude: set[str],
    dry_run: bool,
    prune_codex_bundled: bool = False,
    codex_home: Path | None = None,
) -> None:
    source = root / "skills"
    if same_path(source, target):
        print(f"SOURCE {source} (already active)")
        return
    if not dry_run:
        target.mkdir(parents=True, exist_ok=True)

    skills = source_skills(root, exclude)
    manifest = target / SKILL_MANIFEST
    previous = read_manifest(manifest)
    for stale in sorted(previous - set(skills)):
        stale_path = target / stale
        if stale_path.is_dir():
            safe_remove(stale_path, target, dry_run)

    for name, skill in skills.items():
        destination = target / name
        if destination.exists():
            safe_remove(destination, target, dry_run)
        print(f"COPY   {skill} -> {destination}")
        if not dry_run:
            shutil.copytree(skill, destination)

    if prune_codex_bundled and codex_home is not None:
        for name in sorted(exclude):
            duplicate = target / name
            bundled = codex_home / "skills" / ".system" / name / "SKILL.md"
            if duplicate.is_dir() and bundled.is_file():
                safe_remove(duplicate, target, dry_run)

    write_manifest(manifest, sorted(skills), dry_run)


def sync_hooks(source: Path, target: Path, dry_run: bool) -> None:
    if same_path(source, target):
        print(f"SOURCE {source} (already active)")
        return
    if not dry_run:
        target.mkdir(parents=True, exist_ok=True)

    files = {
        item.name: item
        for item in source.iterdir()
        if item.is_file() and item.name not in {HOOK_MANIFEST}
    }
    manifest = target / HOOK_MANIFEST
    previous = read_manifest(manifest)
    for stale in sorted(previous - set(files)):
        stale_path = target / stale
        if stale_path.is_file():
            print(f"REMOVE {stale_path}")
            if not dry_run:
                stale_path.unlink()
    for name, item in files.items():
        sync_file(item, target / name, dry_run)
    write_manifest(manifest, sorted(files), dry_run)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", choices=("all", "claude", "codex"), default="all")
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--home", type=Path, default=Path.home(), help="User home; useful for tests")
    parser.add_argument("--claude-home", type=Path)
    parser.add_argument("--codex-home", type=Path)
    parser.add_argument("--codex-skills-dir", type=Path)
    parser.add_argument("--skip-hooks", action="store_true")
    parser.add_argument("--prune-codex-bundled", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    root = args.repo_root.expanduser().resolve()
    home = args.home.expanduser().resolve()
    claude_home = (args.claude_home or home / ".claude").expanduser().resolve()
    codex_home = (args.codex_home or home / ".codex").expanduser().resolve()
    codex_skills = (
        args.codex_skills_dir or home / ".agents" / "skills"
    ).expanduser().resolve()

    required = (root / "CLAUDE.md", root / "skills", root / "hooks")
    if not all(path.exists() for path in required):
        raise FileNotFoundError(f"Not an EpiClaude repository: {root}")

    if args.target in {"all", "claude"}:
        print("\n[Claude Code]")
        sync_file(root / "CLAUDE.md", claude_home / "CLAUDE.md", args.dry_run)
        sync_skills(root, claude_home / "skills", set(), args.dry_run)
        if not args.skip_hooks:
            sync_hooks(root / "hooks", claude_home / "hooks", args.dry_run)

    if args.target in {"all", "codex"}:
        print("\n[Codex]")
        sync_file(root / "CLAUDE.md", codex_home / "AGENTS.md", args.dry_run)
        sync_skills(
            root,
            codex_skills,
            CODEX_EXCLUDES,
            args.dry_run,
            prune_codex_bundled=args.prune_codex_bundled,
            codex_home=codex_home,
        )
        if not args.skip_hooks:
            sync_hooks(root / "hooks", codex_home / "hooks", args.dry_run)

    print("\nSync complete. Restart the client if changed skills are not visible.")


if __name__ == "__main__":
    main()
