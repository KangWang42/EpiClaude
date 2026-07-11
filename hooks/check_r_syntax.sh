#!/usr/bin/env bash
# PostToolUse(Edit|Write|apply_patch)：对 .R 文件做语法 parse 检查，出错即反馈给 agent（exit 2）。
source "$(dirname "$0")/_resolve_path.sh"
while IFS= read -r f; do
  case "$f" in
    *.R|*.r)
      [ -f "$f" ] || continue
      out=$(Rscript -e 'p<-commandArgs(TRUE)[1]; invisible(parse(text=readLines(p,warn=FALSE,encoding="UTF-8"),srcfile=p))' "$f" 2>&1) || {
        echo "R 语法检查未过 ($f)：" >&2
        echo "$out" >&2
        exit 2
      }
      ;;
  esac
done <<< "$files"
exit 0
