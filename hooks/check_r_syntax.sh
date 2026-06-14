#!/usr/bin/env bash
# PostToolUse(Write|Edit|MultiEdit)：对 .R 文件做语法 parse 检查，出错即反馈给 Claude（exit 2）。
source "$(dirname "$0")/_resolve_path.sh"
case "$fn" in
  *.R|*.r)
    out=$(Rscript -e 'invisible(parse(commandArgs(TRUE)[1]))' "$f" 2>&1) || {
      echo "R 语法检查未过 ($f)：" >&2
      echo "$out" >&2
      exit 2
    }
    ;;
esac
exit 0
