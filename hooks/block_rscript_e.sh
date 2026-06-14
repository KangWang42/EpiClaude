#!/usr/bin/env bash
# PreToolUse(Bash)：仅当命令是"多行 Rscript -e"时拦截（本环境多行 -e 会 segfault）。
# 绝大多数 bash 调用不含 Rscript → 立即零成本退出（不启 python），保证开销极小。
input=$(cat)
case "$input" in *Rscript*) ;; *) exit 0 ;; esac        # 不含 Rscript → 立即放行
# 仅含 Rscript 时才 JSON 解码取真实命令（拿真实换行判断是否多行）
cmd=$(printf '%s' "$input" | python -c 'import sys,json
try: d=json.load(sys.stdin)
except Exception: d={}
print((d.get("tool_input") or {}).get("command") or "")' 2>/dev/null)
case "$cmd" in *Rscript*-e*) ;; *) exit 0 ;; esac        # 无 -e → 放行
case "$cmd" in
  *$'\n'*)                                               # -e 且命令跨行 → 拦
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"本环境用 Rscript -e 传多行脚本会 segfault（非脚本本身问题）。请把脚本写成 .R 文件再用 Rscript 文件.R 运行；-e 仅用于一行小命令。"}}\n'
    ;;
esac
exit 0
