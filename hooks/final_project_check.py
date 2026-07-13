#!/usr/bin/env python3
"""Run deterministic project checks before analysis or deliverable sign-off."""

from __future__ import annotations

import argparse
import json
import math
import re
import subprocess
from collections import Counter
from pathlib import Path

from _path_guard import raw_roots


SCRIPT_PATTERN = re.compile(r"^(?P<number>\d{2})_.+\.(?:R|r|py)$")
TABLE_PATTERN = re.compile(r"^Table(?P<number>\d+)_.*\.xlsx$", re.IGNORECASE)
FIGURE_PATTERN = re.compile(
    r"^Fig(?P<number>\d+)_.*\.(?:png|pdf|svg)$", re.IGNORECASE
)
OLD_NAME_PATTERN = re.compile(
    r"(?:^|[_.\-\s])(v\d+|new|final|latest|最新版|最终版|完善版|修改版)(?:$|[_.\-\s])",
    re.IGNORECASE,
)
LOG_PATTERN = re.compile(
    r"\b(error|warning|traceback|failed|nan)\b", re.IGNORECASE
)
SECRET_KEY_PATTERN = re.compile(
    r"""(?ix)
    ["']?(api[_-]?key|access[_-]?token|refresh[_-]?token|secret|
    password|passwd|credential|authorization)["']?\s*[:=]\s*
    ["']?([A-Za-z0-9_./+=:-]{8,})
    """
)
TOKEN_PATTERN = re.compile(r"(?<![A-Za-z0-9])[A-Za-z0-9_./+=-]{32,}(?![A-Za-z0-9])")
TEXT_SUFFIXES = {
    ".cfg",
    ".conf",
    ".env",
    ".ini",
    ".json",
    ".md",
    ".py",
    ".r",
    ".sh",
    ".toml",
    ".txt",
    ".yaml",
    ".yml",
}


def finding(
    findings: list[dict[str, str]],
    level: str,
    check: str,
    path: Path | None = None,
    key: str | None = None,
) -> None:
    item = {"level": level, "check": check}
    if path is not None:
        item["path"] = str(path)
    if key is not None:
        item["key"] = key
    findings.append(item)


def relative(path: Path, project: Path) -> Path:
    try:
        return path.resolve(strict=False).relative_to(project)
    except ValueError:
        return path.resolve(strict=False)


def inside(path: Path, roots: list[Path]) -> bool:
    resolved = path.resolve(strict=False)
    return any(resolved == root or root in resolved.parents for root in roots)


def git_raw_check(project: Path, roots: list[Path], findings: list[dict[str, str]]) -> None:
    probe = subprocess.run(
        ["git", "-C", str(project), "rev-parse", "--is-inside-work-tree"],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )
    if probe.returncode:
        finding(findings, "WARN", "rawdata.git_unavailable")
        return
    for root in roots:
        rel = relative(root, project)
        if rel.is_absolute():
            finding(findings, "WARN", "rawdata.outside_project", rel)
            continue
        status = subprocess.run(
            [
                "git",
                "-C",
                str(project),
                "status",
                "--porcelain",
                "--untracked-files=all",
                "--",
                rel.as_posix(),
            ],
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        if status.returncode:
            finding(findings, "ERROR", "rawdata.git_status_failed", rel)
        elif status.stdout.strip():
            for line in status.stdout.splitlines():
                changed = line[3:].strip() if len(line) > 3 else rel.as_posix()
                finding(
                    findings,
                    "ERROR",
                    "rawdata.worktree_modified",
                    Path(changed),
                )


def sequence_check(
    directory: Path,
    pattern: re.Pattern[str],
    check: str,
    findings: list[dict[str, str]],
) -> None:
    if not directory.is_dir():
        return
    numbers: list[int] = []
    seen: Counter[int] = Counter()
    for path in directory.iterdir():
        if not path.is_file():
            continue
        match = pattern.match(path.name)
        if match:
            number = int(match.group("number"))
            numbers.append(number)
            seen[number] += 1
    if numbers:
        expected = list(range(1, max(numbers) + 1))
        if sorted(set(numbers)) != expected:
            finding(findings, "ERROR", f"{check}.numbering_gap", directory)
        for number, count in seen.items():
            if count > 1:
                finding(
                    findings,
                    "ERROR",
                    f"{check}.duplicate_number",
                    directory,
                    str(number),
                )


def code_check(project: Path, findings: list[dict[str, str]]) -> None:
    directory = project / "02_code"
    sequence_check(directory, SCRIPT_PATTERN, "code", findings)
    if not directory.is_dir():
        return
    exemptions = {"config.R", "conventions.R", "run_pipeline.R", "run_pipeline.py"}
    numbered = 0
    for path in directory.iterdir():
        if not path.is_file() or path.suffix.casefold() not in {".r", ".py"}:
            continue
        if SCRIPT_PATTERN.match(path.name):
            numbered += 1
        elif path.name not in exemptions:
            finding(findings, "ERROR", "code.unnumbered_script", relative(path, project))
    if numbered > 10:
        finding(findings, "ERROR", "code.too_many_numbered_scripts", directory, str(numbered))


def active_files(project: Path, raw: list[Path]):
    excluded_names = {".git", "__pycache__"}
    for path in project.rglob("*"):
        if not path.is_file():
            continue
        rel = relative(path, project)
        if any(part in excluded_names for part in rel.parts) or "09_backup" in rel.parts:
            continue
        if inside(path, raw):
            continue
        yield path, rel


def old_names_check(project: Path, raw: list[Path], findings: list[dict[str, str]]) -> None:
    for _path, rel in active_files(project, raw):
        if any(OLD_NAME_PATTERN.search(part) for part in rel.parts):
            finding(findings, "ERROR", "naming.legacy_version", rel)


def result_sync_check(project: Path, findings: list[dict[str, str]]) -> None:
    paper = project / "07_paper"
    if not paper.is_dir():
        return
    source = paper / "results.yaml"
    summary = paper / "0_result_summaries.md"
    if not source.is_file():
        finding(findings, "ERROR", "results.source_missing", relative(source, project))
        return
    if not summary.is_file():
        finding(findings, "ERROR", "results.summary_missing", relative(summary, project))
    elif summary.stat().st_mtime_ns < source.stat().st_mtime_ns:
        finding(findings, "ERROR", "results.summary_stale", relative(summary, project))
    outputs = [
        path
        for directory in (project / "03_tables", project / "04_figures")
        if directory.is_dir()
        for path in directory.rglob("*")
        if path.is_file()
    ]
    if outputs and max(path.stat().st_mtime_ns for path in outputs) > source.stat().st_mtime_ns:
        finding(findings, "ERROR", "results.source_older_than_outputs", relative(source, project))


def log_check(project: Path, raw: list[Path], findings: list[dict[str, str]]) -> None:
    for path, rel in active_files(project, raw):
        if path.suffix.casefold() not in {".err", ".log", ".out"}:
            continue
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        for line_number, line in enumerate(text.splitlines(), start=1):
            match = LOG_PATTERN.search(line)
            if match:
                finding(
                    findings,
                    "ERROR",
                    "logs.abnormal_term",
                    rel,
                    f"{match.group(1).casefold()}@{line_number}",
                )


def entropy(value: str) -> float:
    counts = Counter(value)
    length = len(value)
    return -sum((count / length) * math.log2(count / length) for count in counts.values())


def secret_check(project: Path, raw: list[Path], findings: list[dict[str, str]]) -> None:
    reported: set[tuple[Path, str]] = set()
    for path, rel in active_files(project, raw):
        if path.suffix.casefold() not in TEXT_SUFFIXES or path.stat().st_size > 2_000_000:
            continue
        text = path.read_text(encoding="utf-8-sig", errors="replace")
        for line_number, line in enumerate(text.splitlines(), start=1):
            for match in SECRET_KEY_PATTERN.finditer(line):
                label = match.group(1)
                marker = (rel, f"{label}@{line_number}")
                if marker not in reported:
                    finding(
                        findings,
                        "ERROR",
                        "secrets.named_credential",
                        rel,
                        marker[1],
                    )
                    reported.add(marker)
            for match in TOKEN_PATTERN.finditer(line):
                value = match.group(0)
                if len(set(value)) >= 8 and entropy(value) >= 4.0:
                    marker = (rel, f"high_entropy_candidate@{line_number}")
                    if marker not in reported:
                        finding(
                            findings,
                            "ERROR",
                            "secrets.high_entropy",
                            rel,
                            marker[1],
                        )
                        reported.add(marker)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("project", nargs="?", type=Path, default=Path.cwd())
    parser.add_argument("--json", action="store_true", dest="as_json")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    project = args.project.expanduser().resolve(strict=False)
    findings: list[dict[str, str]] = []
    protected = raw_roots(project)

    git_raw_check(project, protected, findings)
    code_check(project, findings)
    sequence_check(project / "03_tables", TABLE_PATTERN, "tables", findings)
    sequence_check(project / "04_figures", FIGURE_PATTERN, "figures", findings)
    old_names_check(project, protected, findings)
    result_sync_check(project, findings)
    log_check(project, protected, findings)
    secret_check(project, protected, findings)

    errors = [item for item in findings if item["level"] == "ERROR"]
    if args.as_json:
        print(
            json.dumps(
                {"ok": not errors, "project": str(project), "findings": findings},
                ensure_ascii=False,
                indent=2,
            )
        )
    else:
        for item in findings:
            detail = item.get("path", "")
            if item.get("key"):
                detail = f"{detail} [{item['key']}]".strip()
            print(f"[{item['level']}] {item['check']}: {detail}".rstrip())
        print(
            f"Final project check {'passed' if not errors else 'failed'}: "
            f"{len(errors)} error(s), "
            f"{sum(item['level'] == 'WARN' for item in findings)} warning(s)"
        )
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
