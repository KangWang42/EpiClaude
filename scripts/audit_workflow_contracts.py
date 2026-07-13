#!/usr/bin/env python3
"""Audit cross-skill workflow contracts that are easy to regress."""

from __future__ import annotations

import hashlib
import json
import os
import string
import subprocess
import sys
import tempfile
from pathlib import Path

from config_core import (
    LEGACY_HOOK_MANIFEST,
    LEGACY_INSTALL_MANIFEST,
    LEGACY_SKILL_MANIFEST,
)
from sync_user_configs import (
    HOOK_DEFINITIONS,
    MANAGED_HOOK_SCRIPTS,
    REGISTERED_HOOK_SCRIPTS,
    SKILL_MANIFEST,
    hook_command,
    mirror_tree,
    sync_hook_config,
    sync_skills,
)


ROOT = Path(__file__).resolve().parents[1]
LINE_BUDGET = 200


def read(relative: str) -> str:
    return (ROOT / relative).read_text(encoding="utf-8")


def snapshot_tree(root: Path) -> dict[str, str]:
    return {
        path.relative_to(root).as_posix(): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in root.rglob("*")
        if path.is_file()
    }


def run_epiagentkit(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, str(ROOT / "scripts/epiagentkit.py"), *args],
        cwd=ROOT,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
    )


def run_hook_script(
    script: Path,
    cwd: Path,
    payload: str = "{}",
    environment: dict[str, str] | None = None,
) -> subprocess.CompletedProcess[str]:
    env = os.environ.copy()
    if environment:
        env.update(environment)
    if os.name == "nt":
        wrapper = ROOT / "hooks" / "run_hook.cmd"
        command: str | list[str] = (
            f'cmd.exe /d /s /c call "{wrapper}" "{script}" "claude"'
        )
    else:
        command = ["bash", str(script)]
        env["EPIAGENTKIT_HOOK_CLIENT"] = "claude"
    return subprocess.run(
        command,
        cwd=cwd,
        input=payload,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        env=env,
    )


def main() -> int:
    problems: list[str] = []

    if "Stop" in HOOK_DEFINITIONS:
        problems.append(
            "default hook config must not auto-continue from Stop; support is not "
            "verified consistently across both clients"
        )

    for relative in ("CLAUDE.md", "AGENTS.md"):
        count = len(read(relative).splitlines())
        if count > LINE_BUDGET:
            problems.append(f"{relative}: {count} lines exceeds {LINE_BUDGET}")

    validator = ROOT / "skills/skill-creator/scripts/quick_validate.py"
    skill_names = {
        item.name
        for item in (ROOT / "skills").iterdir()
        if item.is_dir() and (item / "SKILL.md").is_file()
    }
    for skill_dir in sorted((ROOT / "skills").iterdir()):
        if not skill_dir.is_dir() or not (skill_dir / "SKILL.md").exists():
            continue
        result = subprocess.run(
            [sys.executable, str(validator), str(skill_dir)],
            cwd=ROOT,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        if result.returncode:
            detail = (result.stdout + result.stderr).strip()
            problems.append(f"{skill_dir.name}: quick_validate failed: {detail}")

    routing_path = ROOT / "scripts/skill_routing_cases.json"
    try:
        routing_contract = json.loads(routing_path.read_text(encoding="utf-8"))
        cases = routing_contract.get("cases", [])
        if "do not simulate model semantic routing" not in routing_contract.get("scope", ""):
            problems.append("routing cases must state their metadata-only validation scope")
        if not cases:
            problems.append("routing cases are empty")
        for case in cases:
            identity = case.get("id", "<missing>")
            routed = {
                case.get("primary"),
                *case.get("companions", []),
                *case.get("excluded", []),
            }
            unknown = {name for name in routed if name and name not in skill_names}
            if not case.get("prompt") or not case.get("primary"):
                problems.append(f"routing case {identity}: missing prompt or primary skill")
            if unknown:
                problems.append(
                    f"routing case {identity}: unknown skills: {', '.join(sorted(unknown))}"
                )
            expected = {case.get("primary"), *case.get("companions", [])}
            overlap = expected & set(case.get("excluded", []))
            if overlap:
                problems.append(
                    f"routing case {identity}: expected and excluded overlap: "
                    + ", ".join(sorted(overlap))
                )
        if not any(case.get("companions") for case in cases):
            problems.append("routing cases lack multi-skill composition examples")
        if not any(case.get("excluded") for case in cases):
            problems.append("routing cases lack negative examples")
    except (OSError, json.JSONDecodeError, TypeError) as error:
        problems.append(f"routing cases could not be validated: {error}")

    required = {
        "CLAUDE.md": (
            "主流程 skill",
            "只负责实际文件操作，不取代内容主流程",
            "evidence-research",
            "唯一优先级",
            "凭证的完整内容",
        ),
        "skills/project-init/references/project-hygiene.md": (
            "编号脚本不超过 10 个",
            "registry 有序清单是编号唯一来源",
            "MANIFEST.md",
            "BACKLOG.md",
        ),
        "skills/evidence-research/SKILL.md": (
            "预注册检索协议",
            "跨领域可迁移性",
            "无法取得全文或无法核对关键结论时标记“未核验”",
            "文献只能说明合理范围或核查方向",
        ),
        "skills/evidence-research/references/evidence-matrix.md": (
            "来源标识",
            "核验状态",
            "当前项目映射",
        ),
        "skills/project-init/scripts/init_project.R": (
            '"PROTOCOL.md"',
            '"SAP.md"',
            '"09_backup/EXPERIMENTS.md"',
            '"09_backup/INDEX.md"',
            '"02_code/config.R"',
            '"02_code/conventions.R"',
            '"02_code/vendored"',
            '".epiagentkit-raw-roots"',
        ),
        "skills/r-biostats/SKILL.md": (
            "02_code/vendored/emit_summary.R",
            "02_code/vendored/fig_setup.R",
            "PROTOCOL.md",
            "SAP.md",
        ),
        "skills/biostat-principles/SKILL.md": (
            "09_backup/EXPERIMENTS.md",
            "PLAN.md",
            "FINDINGS.md",
            "规则冲突只使用全局",
        ),
        "skills/consulting-delivery/SKILL.md": (
            "09_backup/INDEX.md",
            "MANIFEST.md",
            "唯一当前交付包",
        ),
        "skills/consulting-delivery/scripts/consulting_scaffold.R": (
            'subdirs <- c("data", "code", "results", "tables", "figures")',
            'source("code/config.R"',
            "TABLE_REGISTRY <- character()",
        ),
        "scripts/sync_user_configs.py": (
            "def atomic_copy_file(",
            "def mirror_tree(",
            "def sync_hook_config(",
            'hooks_dir / "run_hook.cmd"',
            "mirror_tree(skill, destination)",
            "include: set[str] | None",
            "prune_stale: bool = True",
            "def update_install_manifest(",
        ),
        "scripts/config_core.py": (
            'PROJECT_NAME = "EpiAgentKit"',
            'INSTALL_MANIFEST = ".epiagentkit-install.json"',
            "def resolve_codex_skill_dirs(",
            'layout == "both"',
            "Installation-time bundle closure only",
            '"evidence-research"',
        ),
        "skills/project-init/SKILL.md": (
            "已有项目开始分析不触发本 skill",
        ),
        "skills/academic-publishing/SKILL.md": (
            "已有文本的局部润色、压缩与语气校准由 academic-humanizer 主导",
        ),
        "skills/docx/SKILL.md": (
            "only when Codex must actually",
            "file-operation companion",
        ),
        "skills/pptx/SKILL.md": (
            "only when Codex must actually",
            "file-operation companion",
        ),
        "skills/python-ecg-analysis/SKILL.md": (
            "只有确认 `--help` 会在业务逻辑前退出且不会写文件时",
            "无法证明入口的帮助调用无副作用时，不执行它",
        ),
        "scripts/configure_user.py": (
            "CODEX_COMPATIBILITY_WARNING,",
            '"doctor"',
            '"--skip-doctor"',
        ),
        "scripts/epiagentkit.py": (
            "def tree_matches(",
            "def run_doctor(",
            'command == "install"',
            'command == "sync"',
        ),
        "scripts/epiclaude.py": ("from epiagentkit import main",),
        "hooks/_emit_notice.py": (
            '"hookEventName": "PostToolUse"',
            '"additionalContext": message',
            '"systemMessage": message',
        ),
        "hooks/protect_rawdata.sh": (
            "_path_guard.py",
            "不解析任意 shell/Python/PowerShell 代码",
        ),
        "hooks/scan_ai_trace.sh": (
            "_scan_text.py",
            "科研符号 → ↔ ↑ ↓ ± × ≥ ≤ ℃ 允许",
        ),
        "hooks/fig_selfcheck.sh": (
            "_file_state.py",
            "--kind figures",
            '_emit_notice.py"',
        ),
        "hooks/check_results_rds.sh": (
            "_file_state.py",
            "--kind results_rds",
            '_emit_notice.py"',
        ),
        "hooks/_file_state.py": (
            "project_key = hashlib.sha256",
            "current[relative] = digest(path)",
        ),
        "hooks/final_project_check.py": (
            "rawdata.worktree_modified",
            "numbering_gap",
            "results.source_older_than_outputs",
            "logs.abnormal_term",
            "secrets.high_entropy",
        ),
        "hooks/post_edit_checks.sh": (
            'run_check "check_r_syntax.sh"',
            'run_check "scan_ai_trace.sh"',
        ),
        "hooks/post_bash_checks.sh": (
            'collect_notice "fig_selfcheck.sh"',
            'collect_notice "check_results_rds.sh"',
            '_emit_notice.py"',
        ),
        "skills/svg-diagrams/SKILL.md": (
            "序号与标题第一行垂直居中对齐",
            "包含关系图",
            "SVG XML 有效",
        ),
        "skills/sysu-ppt/scripts/sysu_toolkit.R": (
            'default = list(file = "template.pptx"',
            'public_health = list(file = "template-公卫学院.pptx"',
            ".svg_aspect <- function(path)",
            ".validate_meeting_deck <- function(ppt)",
            'genre = c("meeting", "formal")',
            "组会 PPT 禁止目录页",
            "组会 PPT 禁止章节分隔/过渡页",
        ),
    }
    for relative, fragments in required.items():
        body = read(relative)
        for fragment in fragments:
            if fragment not in body:
                problems.append(f"{relative}: missing workflow contract {fragment!r}")

    forbidden = {
        "skills/project-init/scripts/init_project.R": (
            'system2("git", c("add"',
            'c("commit", "-m"',
            "Table0_flowchart",
        ),
        "skills/r-biostats/SKILL.md": ('source("../skills/',),
        "skills/biostat-principles/SKILL.md": (
            "CLAUDE.md 的 CRITICAL 条款",
            "所有执行 skill 冲突时，本文件优先级更高",
        ),
        "skills/project-init/SKILL.md": (
            "开始新的数据分析任务",
        ),
        "skills/academic-publishing/SKILL.md": (
            "生成或润色任一部件",
        ),
        "skills/python-ecg-analysis/SKILL.md": (
            "对拟运行入口执行 `python <script> --help`",
        ),
        "skills/r-biostats/references/result-summary-schema.md": (
            'source("../skills/',
        ),
        "skills/consulting-delivery/scripts/consulting_scaffold.R": (
            '"06_results"',
        ),
        "skills/consulting-delivery/references/templates.md": (
            'write_xlsx(tbl, "tables/Table1',
        ),
        "skills/consulting-delivery/SKILL.md": (
            "每个新版本用新日期建新包",
            "旧包移 `09_backup/` 或保留原位",
        ),
        "scripts/sync_user_configs.py": (
            "safe_remove(destination, target, dry_run)",
            "shutil.copytree(skill, destination)",
        ),
        "hooks/fig_selfcheck.sh": ("-newermt",),
        "hooks/check_results_rds.sh": ("-newermt",),
        "scripts/configure_user.py": (
            "PRESETS = {",
            "DEPENDENCIES = {",
            "def csv_values(",
        ),
        "skills/sysu-ppt/references/figure_snippets.R": (
            "flow_box <- function",
            "make_decision <- function",
        ),
        "skills/sysu-ppt/references/deck_skeleton.R": (
            'ppt <- sysu_add_section(',
            'sysu_add_text(ppt, "目录"',
            'genre = "formal"',
        ),
    }
    for relative, fragments in forbidden.items():
        body = read(relative)
        for fragment in fragments:
            if fragment in body:
                problems.append(f"{relative}: forbidden workflow fragment {fragment!r}")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_sync_audit_") as directory:
        test_root = Path(directory)
        source = test_root / "source"
        target = test_root / "target"
        (source / "assets").mkdir(parents=True)
        (target / "assets").mkdir(parents=True)
        (source / "SKILL.md").write_text("new skill\n", encoding="utf-8")
        (source / "assets/template.pptx").write_bytes(b"new asset")
        (target / "SKILL.md").write_text("old skill\n", encoding="utf-8")
        old_asset = target / "assets/template.pptx"
        old_asset.write_bytes(b"old asset")
        old_asset.chmod(0o444)
        (target / "stale.txt").write_text("stale\n", encoding="utf-8")
        try:
            mirror_tree(source, target)
            if (target / "SKILL.md").read_text(encoding="utf-8") != "new skill\n":
                problems.append("sync mirror self-test: SKILL.md was not replaced")
            if old_asset.read_bytes() != b"new asset":
                problems.append("sync mirror self-test: read-only asset was not replaced")
            if (target / "stale.txt").exists():
                problems.append("sync mirror self-test: stale file was not removed")
            if list(target.rglob(".epi-*.tmp")):
                problems.append("sync mirror self-test: temporary files remain")
        except OSError as error:
            problems.append(f"sync mirror self-test failed: {error}")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_partial_sync_") as directory:
        test_root = Path(directory)
        repo = test_root / "repo"
        target = test_root / "target"
        for name in ("alpha", "beta"):
            skill = repo / "skills" / name
            skill.mkdir(parents=True)
            (skill / "SKILL.md").write_text(
                f"---\nname: {name}\ndescription: test\n---\n", encoding="utf-8"
            )
        target.mkdir(parents=True)
        (target / "alpha").mkdir()
        (target / "alpha" / "SKILL.md").write_text("existing\n", encoding="utf-8")
        (target / LEGACY_SKILL_MANIFEST).write_text(
            '{"managed": ["alpha"]}\n', encoding="utf-8"
        )
        try:
            sync_skills(
                repo,
                target,
                exclude=set(),
                dry_run=False,
                include={"beta"},
                prune_stale=False,
            )
            managed = set(
                json.loads(
                    (target / SKILL_MANIFEST).read_text(encoding="utf-8")
                )["managed"]
            )
            if managed != {"alpha", "beta"}:
                problems.append("partial sync self-test: managed manifest was not merged")
            if (target / LEGACY_SKILL_MANIFEST).exists():
                problems.append("partial sync self-test: legacy manifest was not migrated")
            if not (target / "alpha" / "SKILL.md").is_file():
                problems.append("partial sync self-test: existing managed skill was removed")
        except OSError as error:
            problems.append(f"partial sync self-test failed: {error}")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_hook_sync_") as directory:
        test_root = Path(directory)
        hooks_dir = test_root / ".claude" / "hooks"
        config_path = test_root / ".claude" / "settings.json"
        hooks_dir.mkdir(parents=True)
        original = {
            "model": "custom-model",
            "hooks": {
                "PostToolUse": [
                    {
                        "matcher": "Bash",
                        "hooks": [
                            {
                                "type": "command",
                                "command": "custom-quality-check",
                            },
                            {
                                "type": "command",
                                "command": "bash ~/.claude/hooks/fig_selfcheck.sh",
                            },
                        ],
                    }
                ]
            },
        }
        config_path.write_text(
            json.dumps(original, ensure_ascii=False), encoding="utf-8"
        )
        try:
            sync_hook_config(
                "claude", config_path, hooks_dir, dry_run=False, windows=True
            )
            first = json.loads(config_path.read_text(encoding="utf-8"))
            sync_hook_config(
                "claude", config_path, hooks_dir, dry_run=False, windows=True
            )
            second = json.loads(config_path.read_text(encoding="utf-8"))
            commands = [
                hook.get("command", "")
                for groups in second.get("hooks", {}).values()
                for group in groups
                if isinstance(group, dict)
                for hook in group.get("hooks", [])
                if isinstance(hook, dict)
            ]
            managed = [
                command
                for command in commands
                if any(name in command for name in MANAGED_HOOK_SCRIPTS)
            ]
            registered = [
                command
                for command in commands
                if any(name in command for name in REGISTERED_HOOK_SCRIPTS)
            ]
            legacy = MANAGED_HOOK_SCRIPTS - REGISTERED_HOOK_SCRIPTS
            if first != second:
                problems.append("hook sync self-test: repeated install is not idempotent")
            if second.get("model") != "custom-model" or "custom-quality-check" not in commands:
                problems.append("hook sync self-test: unrelated settings were not preserved")
            if len(managed) != len(REGISTERED_HOOK_SCRIPTS):
                problems.append("hook sync self-test: managed hook count is incorrect")
            if len(registered) != len(REGISTERED_HOOK_SCRIPTS):
                problems.append("hook sync self-test: registered hook count is incorrect")
            if any(any(name in command for name in legacy) for command in commands):
                problems.append("hook sync self-test: legacy checks remain separately registered")
            if any("run_hook.cmd" not in command for command in managed):
                problems.append("hook sync self-test: Windows hook bypasses run_hook.cmd")
            if any(not command.startswith("cmd.exe /d /s /c call ") for command in managed):
                problems.append("hook sync self-test: Windows hook is shell-dependent")
            if any('"claude"' not in command for command in managed):
                problems.append("hook sync self-test: client identity is not forwarded")
            if not config_path.with_name("settings.json.epiagentkit.bak").is_file():
                problems.append("hook sync self-test: config backup was not created")
            if not hook_command(hooks_dir, "fig_selfcheck.sh", windows=False).startswith(
                "EPIAGENTKIT_HOOK_CLIENT=claude bash "
            ):
                problems.append("hook sync self-test: POSIX command does not use bash")
        except (OSError, ValueError) as error:
            problems.append(f"hook sync self-test failed: {error}")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_install_audit_") as directory:
        home = Path(directory)
        (home / ".epiclaude").mkdir()
        (home / ".epiclaude/state").write_text("legacy\n", encoding="utf-8")
        for platform, config_name in ((".claude", "settings.json"), (".codex", "hooks.json")):
            platform_home = home / platform
            (platform_home / "hooks").mkdir(parents=True)
            config_path = platform_home / config_name
            config_path.write_text(
                json.dumps({"model": "personal-model"}), encoding="utf-8"
            )
            config_path.with_name(f"{config_name}.epiclaude.bak").write_text(
                "legacy backup\n", encoding="utf-8"
            )
            (platform_home / "hooks" / "custom.sh").write_text(
                "#!/usr/bin/env bash\n", encoding="utf-8"
            )
            (platform_home / LEGACY_INSTALL_MANIFEST).write_text(
                '{"components": [], "skills": [], "skill_dirs": []}\n',
                encoding="utf-8",
            )
            (platform_home / "hooks" / LEGACY_HOOK_MANIFEST).write_text(
                '{"managed": []}\n', encoding="utf-8"
            )

        compatibility = home / ".codex/skills"
        managed_duplicate = compatibility / "academic-humanizer"
        mirror_tree(ROOT / "skills/academic-humanizer", managed_duplicate)
        (compatibility / SKILL_MANIFEST).write_text(
            '{"managed": ["academic-humanizer"]}\n', encoding="utf-8"
        )
        personal_skill = compatibility / "personal-skill/SKILL.md"
        personal_skill.parent.mkdir(parents=True)
        personal_skill.write_text("personal skill\n", encoding="utf-8")
        system_skill = compatibility / ".system/system-skill/SKILL.md"
        system_skill.parent.mkdir(parents=True)
        system_skill.write_text("system skill\n", encoding="utf-8")

        install = [
            "install",
            "--target",
            "all",
            "--preset",
            "custom",
            "--skills",
            "academic-humanizer",
            "--with-rules",
            "--with-hooks",
            "--yes",
            "--home",
            str(home),
        ]

        before_dry_run = snapshot_tree(home)
        dry_run = run_epiagentkit([*install, "--dry-run"])
        if dry_run.returncode:
            problems.append(
                "Codex compatibility migration dry-run failed: "
                + (dry_run.stdout + dry_run.stderr).strip()
            )
        elif snapshot_tree(home) != before_dry_run:
            problems.append("Codex compatibility migration dry-run changed files")
        elif "MIGRATE Codex compatibility skills: academic-humanizer" not in dry_run.stdout:
            problems.append("Codex compatibility migration dry-run omitted the managed skill name")

        compatibility_mode = run_epiagentkit(
            [
                "sync",
                "--target",
                "codex",
                "--components",
                "skills",
                "--home",
                str(home),
                "--codex-layout",
                "both",
                "--dry-run",
            ]
        )
        if (
            compatibility_mode.returncode
            or "compatibility mode" not in compatibility_mode.stdout
        ):
            problems.append("Codex compatibility layout did not emit a warning")

        first = run_epiagentkit(install)
        if first.returncode:
            problems.append(
                "dual-platform install self-test failed: "
                + (first.stdout + first.stderr).strip()
            )
        else:
            expected_paths = (
                home / ".claude/CLAUDE.md",
                home / ".codex/AGENTS.md",
                home / ".claude/skills/academic-humanizer/SKILL.md",
                home / ".agents/skills/academic-humanizer/SKILL.md",
                home / ".claude/.epiagentkit-install.json",
                home / ".codex/.epiagentkit-install.json",
                home / ".epiagentkit/state",
                home / ".claude/settings.json.epiagentkit.bak",
                home / ".codex/hooks.json.epiagentkit.bak",
            )
            missing = [str(path) for path in expected_paths if not path.is_file()]
            if missing:
                problems.append(
                    "dual-platform install self-test: missing files: " + ", ".join(missing)
                )
            if managed_duplicate.exists() or (compatibility / SKILL_MANIFEST).exists():
                problems.append(
                    "Codex compatibility migration left a verified managed duplicate"
                )
            if not personal_skill.is_file() or not system_skill.is_file():
                problems.append(
                    "Codex compatibility migration removed unmanaged or .system content"
                )
            legacy = [
                path
                for platform in (home / ".claude", home / ".codex")
                for path in (
                    platform / LEGACY_INSTALL_MANIFEST,
                    platform / "hooks" / LEGACY_HOOK_MANIFEST,
                )
                if path.exists()
            ]
            legacy.extend(home.glob("*/**/*.epiclaude.bak"))
            if (home / ".epiclaude").exists():
                legacy.append(home / ".epiclaude")
            if legacy:
                problems.append(
                    "dual-platform install self-test: legacy manifests remain: "
                    + ", ".join(map(str, legacy))
                )

            for config_path in (home / ".claude/settings.json", home / ".codex/hooks.json"):
                config = json.loads(config_path.read_text(encoding="utf-8"))
                if config.get("model") != "personal-model":
                    problems.append(
                        f"dual-platform install self-test: personal config changed: {config_path}"
                    )

            before = snapshot_tree(home)
            second = run_epiagentkit(install)
            if second.returncode:
                problems.append(
                    "dual-platform reinstall self-test failed: "
                    + (second.stdout + second.stderr).strip()
                )
            elif snapshot_tree(home) != before:
                problems.append("dual-platform reinstall self-test: install is not idempotent")

            doctor = run_epiagentkit(
                [
                    "doctor",
                    "--target",
                    "all",
                    "--home",
                    str(home),
                    "--json",
                ]
            )
            try:
                doctor_payload = json.loads(doctor.stdout)
            except json.JSONDecodeError:
                doctor_payload = {}
            if doctor.returncode or not doctor_payload.get("ok"):
                problems.append(
                    "dual-platform doctor self-test failed: "
                    + (doctor.stdout + doctor.stderr).strip()
                )

            mirror_tree(
                ROOT / "skills/academic-humanizer",
                compatibility / "academic-humanizer",
            )
            duplicate_doctor = run_epiagentkit(
                ["doctor", "--target", "codex", "--home", str(home), "--json"]
            )
            try:
                duplicate_payload = json.loads(duplicate_doctor.stdout)
            except json.JSONDecodeError:
                duplicate_payload = {}
            duplicate_checks = duplicate_payload.get("checks", [])
            if duplicate_doctor.returncode != 1 or not any(
                check.get("item") == "codex.skills.duplicate_roots"
                and check.get("status") == "FAIL"
                for check in duplicate_checks
            ):
                problems.append("Codex duplicate-root doctor self-test did not fail")

    notice_helper = ROOT / "hooks" / "_emit_notice.py"
    for client, expected_key in (("claude", "hookSpecificOutput"), ("codex", "systemMessage")):
        environment = os.environ.copy()
        environment["EPIAGENTKIT_HOOK_CLIENT"] = client
        result = subprocess.run(
            [sys.executable, str(notice_helper)],
            input="quality reminder",
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
            env=environment,
        )
        try:
            payload = json.loads(result.stdout)
        except json.JSONDecodeError:
            payload = {}
        if result.returncode or expected_key not in payload:
            problems.append(f"hook notice self-test: invalid {client} success payload")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_raw_guard_") as directory:
        project = Path(directory) / "project"
        (project / "01_data/rawdata").mkdir(parents=True)
        (project / "外部原始数据").mkdir()
        (project / "folder/供应方 原始导出").mkdir(parents=True)
        (project / "06_results").mkdir()
        (project / ".epiagentkit-raw-roots").write_text(
            "外部原始数据\nfolder/供应方 原始导出\n", encoding="utf-8"
        )
        raw_hook = ROOT / "hooks" / "protect_rawdata.sh"

        def raw_payload(path: str) -> str:
            return json.dumps({"tool_input": {"file_path": path}}, ensure_ascii=False)

        protected_paths = (
            "01_data/rawdata/record.csv",
            r"01_data\rawdata\record.csv",
            "外部原始数据/record.csv",
            r"folder\供应方 原始导出\record.csv",
            "../project/外部原始数据/record.csv",
            (project / "folder/供应方 原始导出/record.csv").as_posix(),
        )
        for path in protected_paths:
            result = run_hook_script(raw_hook, project, raw_payload(path))
            try:
                decision = json.loads(result.stdout)["hookSpecificOutput"][
                    "permissionDecision"
                ]
            except (json.JSONDecodeError, KeyError, TypeError):
                decision = ""
            if result.returncode or decision != "deny":
                problems.append(f"raw guard self-test did not deny canonical path: {path}")

        patch_payload = json.dumps(
            {
                "tool_input": {
                    "command": "*** Begin Patch\n"
                    "*** Update File: 外部原始数据/record.csv\n"
                    "*** End Patch"
                }
            },
            ensure_ascii=False,
        )
        patch_result = run_hook_script(raw_hook, project, patch_payload)
        if '"permissionDecision":"deny"' not in patch_result.stdout:
            problems.append("raw guard self-test did not inspect apply_patch paths")

        for path in (
            "06_results/output.xlsx",
            "外部原始数据/../06_results/output.xlsx",
        ):
            result = run_hook_script(raw_hook, project, raw_payload(path))
            if result.returncode or result.stdout.strip() or result.stderr.strip():
                problems.append(f"raw guard self-test blocked derived path: {path}")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_text_scan_") as directory:
        project = Path(directory)
        allowed = project / "report.md"
        backlog = project / "BACKLOG.md"
        bad_emoji = project / "bad_emoji.md"
        bad_backlog = project / "bad_backlog.md"
        bad_trace = project / "bad_trace.md"
        allowed.write_text("A → B ↔ C ↑ ↓；1±2；2×3；x≥y≤z；37℃\n", encoding="utf-8")
        checkmark = chr(0x2705)
        backlog.write_text(
            "| 待完善内容 | 完善方式 | 重要性 | 状态 |\n"
            f"| 【分析】复核 | 人工 | 建议 | {checkmark} 2026-07-13 |\n",
            encoding="utf-8",
        )
        bad_emoji.write_text("status " + chr(0x1F600) + "\n", encoding="utf-8")
        bad_backlog.write_text(
            "| 待完善内容 | 完善方式 | 重要性 | 状态 |\n"
            f"| {checkmark} 错列 | 人工 | 建议 | 完成 |\n",
            encoding="utf-8",
        )
        bad_trace.write_text("AI" + "辅助\n", encoding="utf-8")
        scan_hook = ROOT / "hooks" / "scan_ai_trace.sh"
        for path in (allowed, backlog):
            result = run_hook_script(scan_hook, project, raw_payload(path.as_posix()))
            if result.returncode or result.stdout.strip() or result.stderr.strip():
                problems.append(f"text scan self-test rejected allowed symbols: {path.name}")
        for path in (bad_emoji, bad_backlog, bad_trace):
            result = run_hook_script(scan_hook, project, raw_payload(path.as_posix()))
            if result.returncode != 2:
                problems.append(f"text scan self-test allowed forbidden content: {path.name}")

    with tempfile.TemporaryDirectory(prefix="epiagentkit_hook_aggregate_") as directory:
        project = Path(directory) / "project"
        state = Path(directory) / "state"
        code = project / "02_code"
        figures = project / "04_figures"
        results = project / "06_results"
        code.mkdir(parents=True)
        figures.mkdir()
        results.mkdir()
        good_r = code / "01_good.R"
        bad_r = code / "02_bad.R"
        bad_text = project / "report.md"
        good_r.write_text("x <- 1\n", encoding="utf-8")
        bad_r.write_text("x <-\n", encoding="utf-8")
        bad_text.write_text("AI" + "辅助\n", encoding="utf-8")
        figure = figures / "Fig1_test.png"
        figure.write_bytes(b"png fixture")
        os.utime(figure, (1, 1))
        (results / "model.rds").write_bytes(b"rds fixture")

        edit_hook = ROOT / "hooks" / "post_edit_checks.sh"
        bash_hook = ROOT / "hooks" / "post_bash_checks.sh"

        def edit_payload(path: Path) -> str:
            return json.dumps({"tool_input": {"file_path": path.as_posix()}})

        good = run_hook_script(edit_hook, project, edit_payload(good_r))
        bad_syntax = run_hook_script(edit_hook, project, edit_payload(bad_r))
        bad_trace = run_hook_script(edit_hook, project, edit_payload(bad_text))
        if good.returncode or good.stdout.strip() or good.stderr.strip():
            problems.append("aggregate edit hook self-test: valid R file did not pass cleanly")
        if bad_syntax.returncode != 2 or "R 语法检查未过" not in bad_syntax.stderr:
            problems.append("aggregate edit hook self-test: R syntax failure was not preserved")
        if bad_trace.returncode != 2 or "生成过程痕迹" not in bad_trace.stderr:
            problems.append("aggregate edit hook self-test: text trace failure was not preserved")

        hook_env = {"EPIAGENTKIT_STATE_HOME": str(state)}
        combined = run_hook_script(bash_hook, project, environment=hook_env)
        repeated = run_hook_script(bash_hook, project, environment=hook_env)
        try:
            combined_payload = json.loads(combined.stdout)
            combined_message = combined_payload["hookSpecificOutput"]["additionalContext"]
        except (json.JSONDecodeError, KeyError, TypeError):
            combined_message = ""
        if (
            combined.returncode
            or "检测到新生成/修改的图" not in combined_message
            or "检测到 06_results/ 新写入 .rds" not in combined_message
        ):
            problems.append("aggregate Bash hook self-test: combined notice lost a check")
        if repeated.returncode or repeated.stdout.strip() or repeated.stderr.strip():
            problems.append("aggregate Bash hook self-test: repeated notice was not deduplicated")

        figure.write_bytes(b"changed png content")
        os.utime(figure, (1, 1))
        changed = run_hook_script(bash_hook, project, environment=hook_env)
        try:
            changed_message = json.loads(changed.stdout)["hookSpecificOutput"][
                "additionalContext"
            ]
        except (json.JSONDecodeError, KeyError, TypeError):
            changed_message = ""
        if changed.returncode or "Fig1_test.png" not in changed_message:
            problems.append(
                "aggregate Bash hook self-test: content fingerprint missed old-mtime change"
            )

        second_project = Path(directory) / "second_project"
        second_figure = second_project / "04_figures/Fig1_test.png"
        second_figure.parent.mkdir(parents=True)
        second_figure.write_bytes(b"png fixture")
        same_name = run_hook_script(bash_hook, second_project, environment=hook_env)
        same_name_repeat = run_hook_script(bash_hook, second_project, environment=hook_env)
        try:
            same_name_message = json.loads(same_name.stdout)["hookSpecificOutput"][
                "additionalContext"
            ]
        except (json.JSONDecodeError, KeyError, TypeError):
            same_name_message = ""
        if same_name.returncode or "Fig1_test.png" not in same_name_message:
            problems.append(
                "aggregate Bash hook self-test: project-scoped state collided on same Fig name"
            )
        if (
            same_name_repeat.returncode
            or same_name_repeat.stdout.strip()
            or same_name_repeat.stderr.strip()
        ):
            problems.append(
                "aggregate Bash hook self-test: second project notice was not deduplicated"
            )

    with tempfile.TemporaryDirectory(prefix="epiagentkit_final_check_") as directory:
        root = Path(directory)
        final_check = ROOT / "hooks" / "final_project_check.py"

        good = root / "good"
        (good / "02_code").mkdir(parents=True)
        (good / "03_tables").mkdir()
        (good / "04_figures").mkdir()
        (good / "07_paper").mkdir()
        (good / "02_code/01_clean.R").write_text("x <- 1\n", encoding="utf-8")
        table = good / "03_tables/Table1_baseline.xlsx"
        chart = good / "04_figures/Fig1_flow.png"
        source = good / "07_paper/results.yaml"
        summary = good / "07_paper/0_result_summaries.md"
        table.write_bytes(b"xlsx")
        chart.write_bytes(b"png")
        source.write_text("schema_version: 1\n", encoding="utf-8")
        summary.write_text("summary\n", encoding="utf-8")
        os.utime(table, (1, 1))
        os.utime(chart, (1, 1))
        os.utime(source, (2, 2))
        os.utime(summary, (3, 3))
        good_result = subprocess.run(
            [sys.executable, str(final_check), str(good), "--json"],
            cwd=ROOT,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        try:
            good_payload = json.loads(good_result.stdout)
        except json.JSONDecodeError:
            good_payload = {}
        if good_result.returncode or not good_payload.get("ok"):
            problems.append("final project check self-test rejected a valid fixture")

        bad = root / "bad"
        (bad / "01_data/rawdata").mkdir(parents=True)
        (bad / "02_code").mkdir()
        (bad / "03_tables").mkdir()
        (bad / "07_paper").mkdir()
        (bad / "01_data/rawdata/source.csv").write_text("id\n1\n", encoding="utf-8")
        (bad / "02_code/01_clean.R").write_text("x <- 1\n", encoding="utf-8")
        (bad / "02_code/03_model.R").write_text("x <- 2\n", encoding="utf-8")
        bad_table = bad / "03_tables/Table1_result.xlsx"
        bad_source = bad / "07_paper/results.yaml"
        bad_summary = bad / "07_paper/0_result_summaries.md"
        bad_table.write_bytes(b"xlsx")
        bad_source.write_text("schema_version: 1\n", encoding="utf-8")
        bad_summary.write_text("summary\n", encoding="utf-8")
        os.utime(bad_source, (1, 1))
        os.utime(bad_table, (2, 2))
        os.utime(bad_summary, (3, 3))
        (bad / "report_final.md").write_text("report\n", encoding="utf-8")
        (bad / "run.log").write_text("WARNING detected\n", encoding="utf-8")
        alphabet = string.ascii_letters + string.digits
        secret_value = "".join(alphabet[(index * 17) % len(alphabet)] for index in range(48))
        (bad / "config.toml").write_text(
            "api_key = \"" + secret_value + "\"\n", encoding="utf-8"
        )
        subprocess.run(
            ["git", "init", "-q"],
            cwd=bad,
            capture_output=True,
            check=True,
        )
        subprocess.run(
            ["git", "add", "01_data/rawdata/source.csv"],
            cwd=bad,
            capture_output=True,
            check=True,
        )
        bad_result = subprocess.run(
            [sys.executable, str(final_check), str(bad), "--json"],
            cwd=ROOT,
            capture_output=True,
            text=True,
            encoding="utf-8",
            errors="replace",
        )
        try:
            bad_payload = json.loads(bad_result.stdout)
        except json.JSONDecodeError:
            bad_payload = {}
        checks = {item.get("check") for item in bad_payload.get("findings", [])}
        required_checks = {
            "rawdata.worktree_modified",
            "code.numbering_gap",
            "naming.legacy_version",
            "results.source_older_than_outputs",
            "logs.abnormal_term",
            "secrets.named_credential",
            "secrets.high_entropy",
        }
        if bad_result.returncode != 1 or not required_checks <= checks:
            problems.append("final project check self-test missed a required failure class")
        if secret_value in bad_result.stdout or secret_value in bad_result.stderr:
            problems.append("final project check self-test exposed a credential value")

    for skill_dir in (ROOT / "skills").iterdir():
        if not skill_dir.is_dir():
            continue
        for directory in (item for item in skill_dir.rglob("*") if item.is_dir()):
            if directory.parent != skill_dir and directory.name == directory.parent.name:
                problems.append(
                    "skill path audit: redundant repeated directory lengthens Windows path: "
                    + str(directory.relative_to(ROOT))
                )

    cmd_bytes = (ROOT / "hooks" / "run_hook.cmd").read_bytes()
    if b"\r\n" not in cmd_bytes or b"\n" in cmd_bytes.replace(b"\r\n", b""):
        problems.append("hook path audit: run_hook.cmd must use CRLF line endings")

    if problems:
        print("Workflow contract audit failed:")
        for problem in problems:
            print(f"- {problem}")
        return 1

    print("Workflow contract audit passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
