#!/usr/bin/env bash
# PreToolUse(Write|Edit|MultiEdit)：拦截对 01_data/rawdata 原始数据的修改（CLAUDE.md 红线）。
source "$(dirname "$0")/_resolve_path.sh"
case "$fn" in
  */01_data/rawdata/*|*/rawdata/*)
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"01_data/rawdata 是只读原始数据，禁止修改（CLAUDE.md 红线）。如确需变更请改派生数据或先与用户确认。"}}\n'
    ;;
esac
exit 0
