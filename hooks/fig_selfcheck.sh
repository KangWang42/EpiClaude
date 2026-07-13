#!/usr/bin/env bash
# PostToolUse(Bash)：按项目隔离的内容指纹检测 04_figures/ 新生成或修改的图。
# 逐元素自检清单，要求主模型用当前平台的视觉检查工具打开图并逐条判断。hook 不做视觉判断，
# 只负责"逮住出图事件 + 强制自检"，判断交给视觉能力强的主模型。
hook_dir=$(cd "$(dirname "$0")" && pwd)
new=$(python "$hook_dir/_file_state.py" \
  --kind figures --root 04_figures --extension .png --extension .pdf)

if [ -n "$new" ]; then
  notice=$({
    echo "检测到新生成/修改的图，按 publication-figures §12ter 逐项自检（先使用当前平台的视觉检查工具打开 PNG/PDF，逐条判；任一不过即回代码层修改并重出）："
    printf '%s' "$new" | sed '/^$/d;s/^/  · /'
    echo "① 图例/标签/注释不遮挡任何数据（线/点/柱/误差棒）；遮挡即不合格"
    echo "② 比例尺寸合适，无大片空边、无元素被裁切（轴/标题/图例/刻度完整）"
    echo "③ 每个元素清晰可读（嵌入尺寸下字号够大）"
    echo "④ 数值可溯源不硬编码、与 results.yaml 一致；无统计假象（全同值/恒 ±0.707 等）"
    echo "⑤ 图型匹配数据、与同篇其它图 theme/配色/布局一致、多结局不漏"
  })
  if [ "${EPIAGENTKIT_PLAIN_NOTICE:-${EPICLAUDE_PLAIN_NOTICE:-0}}" = "1" ]; then
    printf '%s\n' "$notice"
  else
    printf '%s\n' "$notice" | python "$(dirname "$0")/_emit_notice.py"
  fi
  exit $?
fi
exit 0
