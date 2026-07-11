# 由各 hook source：把目标文件路径解析到 $files（每行一个）与兼容变量 $f/$fn。
# Claude 编辑工具提供 file_path；Codex apply_patch 把补丁放在 tool_input.command。
files="${CLAUDE_TOOL_FILE_PATH:-}"
if [ -z "$files" ]; then
  files=$(python -c 'import sys,json,re
try:
    d=json.load(sys.stdin)
except Exception:
    d={}
ti=d.get("tool_input") or {}
tr=d.get("tool_response") or {}
paths=[]
direct=ti.get("file_path") or tr.get("filePath")
if direct:
    paths.append(str(direct))
command=ti.get("command") or ""
paths.extend(re.findall(r"^\*\*\* (?:Add|Update|Delete) File: (.+)$", command, re.M))
print("\n".join(dict.fromkeys(paths)))' 2>/dev/null)
fi
f=$(printf '%s\n' "$files" | sed -n '1p')
fn="${f//\\//}"   # 反斜杠归一为正斜杠，便于匹配
