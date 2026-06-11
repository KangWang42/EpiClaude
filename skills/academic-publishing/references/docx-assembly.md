# Word Assembly reference (python-docx)

> 把 `07_paper/sections*/` 的 md 拼成格式规范的 .docx。**禁用 `pandoc -o`**（中文字体字号、三线表、
> 首行缩进、真上下标控制不到位）。拼装脚本写进项目 `02_code/`，属一次性文档脚本 → 跑完归
> `09_backup/<日期>_scripts_oneoff/`，不进编号流水线、不留无编号脚本在 02_code。

## 1 md → Word 标记映射

| Markdown | Word 样式 | 说明 |
|----------|-----------|------|
| `# 一级标题` | Heading 1 | 论文主标题 / 主章节 |
| `## 二级标题` | Heading 2 | 各节（1 引言、2 方法…） |
| `### 三级标题` | Heading 3 | 各小节（2.1…） |
| 无标记段落 | Normal | 正文，自动首行缩进 |
| `**粗体**` | Bold run | 强调 / 摘要标签 |
| `| a | b |` 表格 | 三线表 | 见 §3 |
| `![cap](path)` | 内联图片 + 居中图注 | 图注在图下方 |
| `$$LaTeX$$` | OMML 公式 | 见 §4 |
| `~i~` / `^2^` | 真下标 / 真上标 | 见 §4 |
| `> 注：xxx` | 表注样式 | 表格脚注 |

段落分隔用空行（`\n\n`），脚本按空行拆分，每段一个 `doc.add_paragraph()`。Heading 手动构建样式
（不要直接 `add_heading()`，样式不可控）。

## 2 字体字号（中文稿）

按 `chinese-paper.md` §3.1 字体字号表逐段构造。关键实现：双字体——
```
run.font.name = 'Times New Roman'                       # 西文/数字
run._element.rPr.rFonts.set(qn('w:eastAsia'), '宋体')   # 中文
```
段落格式：首行缩进 2 字符（约 21pt）、1.5 倍行距、两端对齐。参考文献：悬挂缩进
（`first_line_indent=-21pt`、`left_indent=21pt`）。

英文稿：journal 通常只要求 double-spaced、行号、Times/Arial 12pt、单字体；多数情况直接交 `docx`
技能产出干净 Word 即可，无需国标级排版。投稿系统多自带排版，作者稿"干净可读"优先于"美观"。

## 3 三线表

表头上下两条 `single` 边线，其余所有边线设 `nil`；末行底线再加一条 single。规格：顶线 1.5pt、
栏目线 0.5pt、底线 1.5pt。表题作为正文段落放表上方；表注放表下方。表格内文字号小五(9pt)。

## 4 公式与上下标

- 公式：`$$...$$` → OMML XML 嵌入。简单公式可用多 run 段落（斜体变量名 + 真上下标）兜底；复杂公式走
  OMML 映射表。**禁止**输出 `RPF_(i)`、`²⁹` 这类 fallback 字符串。
- 上下标：`<w:vertAlign w:val="subscript"/>` / `superscript`，不要直接塞 Unicode 下标字符（ᵢ ⱼ ₚ ²⁹）。

## 5 拼装前 / 后验证

拼装前：sections 文件齐全；各部件自检全过；摘要数字 = 结果数字 = `0_result_summaries.md` 数字。
拼装后：.docx 成功生成；段落分离正确（非一大块）；标题层级正确（可自动生成目录）；字体字号符合规范；
公式可见非乱码；三线表线条正确；图片显示、图注在位。

## 6 Windows 注意

- python 脚本含 emoji 的 `print` 在 GBK 控制台会 `UnicodeEncodeError` → 运行用 `PYTHONUTF8=1`，或脚本里
  不打印 emoji。
- 中文字体（宋体/黑体/楷体_GB2312）需系统已安装；缺字体时 Word 回退会破版，先确认字体可用。
