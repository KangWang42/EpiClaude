#!/usr/bin/env bash
# PostToolUse(Write|Edit|MultiEdit)：扫文本文件里的 emoji 与 AI 痕迹字样，命中反馈给 Claude（exit 2）。
# 放过 ✅（BACKLOG 约定状态标记）；跳过 .claude/ 下的 skill/配置文件（它们合法地讨论这些字样）。
source "$(dirname "$0")/_resolve_path.sh"
case "$fn" in
  */.claude/*) exit 0 ;;            # 不扫 skill/配置自身
esac
case "$fn" in
  *.md|*.R|*.r|*.txt|*.csv|*.yaml|*.yml|*.py)
    ai=$(grep -nE 'AI辅助|AI_assisted|AI-assisted|机辅|机器辅助|待人工复核|AI ?生成|机辅待核' "$f" 2>/dev/null)
    em=$(grep -nP '[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}\x{2B00}-\x{2BFF}\x{2190}-\x{21FF}]' "$f" 2>/dev/null | grep -vF '✅')
    if [ -n "$ai" ] || [ -n "$em" ]; then
      echo "检测到 AI 痕迹 / emoji（工作产物需清除，✅ 状态标记除外）于 $f：" >&2
      [ -n "$ai" ] && echo "[AI痕迹] $ai" >&2
      [ -n "$em" ] && echo "[emoji] $em" >&2
      exit 2
    fi
    ;;
esac
exit 0
