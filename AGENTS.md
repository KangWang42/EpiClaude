# Repository Guidelines

## Project Structure & Module Organization

This repository packages Claude Code guidance for epidemiology and biostatistics workflows. `CLAUDE.md` contains the cross-task rules loaded for every session, while `README.md` documents installation and the overall architecture. Each directory under `skills/` is a self-contained capability: keep its required `SKILL.md` concise, place detailed guidance in `references/`, deterministic utilities in `scripts/`, and templates or media in `assets/`. Shared Claude Code enforcement scripts live in `hooks/`. Do not commit runtime state, credentials, caches, histories, or local settings from the repository root; the allowlist-style `.gitignore` intentionally excludes them.

## Build, Test, and Development Commands

There is no unified build or test runner. Validate the component you changed:

```bash
python skills/skill-creator/scripts/quick_validate.py skills/<skill-name>
bash -n hooks/*.sh
python -m py_compile path/to/changed_script.py
Rscript -e 'parse(file="path/to/changed_script.R")'
```

The skill validator checks required metadata and structure. The remaining commands perform syntax checks for hooks, Python utilities, and R scripts. Run an affected script with representative inputs when behavior changes; syntax-only validation is insufficient for functional changes.

## Coding Style & Naming Conventions

Use UTF-8 Markdown, short imperative instructions, and descriptive headings. Skill directories use lowercase kebab-case, such as `academic-publishing/`; every skill entry point is named `SKILL.md` and begins with YAML front matter containing at least `name` and `description`. Use four spaces in Python, two spaces in R, and portable Bash with `#!/usr/bin/env bash`. Keep shell files LF-only as enforced by `.gitattributes`. Prefer relative paths and keep reusable logic in `scripts/` instead of embedding large code blocks in documentation.

## Testing Guidelines

The repository currently has no central coverage target or dedicated test tree. Treat validators, syntax checks, and focused execution as the required test set. For bug fixes, reproduce the failing case before the change and record the exact verification command in the pull request. Never use private research data as a fixture.

## Commit & Pull Request Guidelines

Follow the existing Conventional Commit pattern: `feat(scope): summary`, `fix(scope): summary`, `docs(scope): summary`, or `refactor(scope): summary`. Keep each commit focused. Pull requests should explain the problem, identify affected skills or hooks, list verification commands, and call out compatibility or migration effects. Link relevant issues and include screenshots only for generated visual or document output.

## Agent-Specific Instructions

Read `CLAUDE.md` before modifying domain workflows. Preserve raw data, never guess analytical definitions, and do not alter unrelated local changes. Update references and executable helpers together when a workflow contract changes.
