# 由各 hook source：把目标文件路径解析到 $f（env 优先，无 jq 时用 python 读 stdin JSON）。
f="${CLAUDE_TOOL_FILE_PATH:-}"
if [ -z "$f" ]; then
  f=$(python -c 'import sys,json
try:
    d=json.load(sys.stdin)
except Exception:
    d={}
ti=d.get("tool_input") or {}
tr=d.get("tool_response") or {}
print(ti.get("file_path") or tr.get("filePath") or "")' 2>/dev/null)
fi
fn="${f//\\//}"   # 反斜杠归一为正斜杠，便于匹配
