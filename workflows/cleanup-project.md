---
description: 清理项目结构，将非标准文件归档到回收站
---

# 🧹 Cleanup & Archive Project

此工作流用于将混乱的项目文件结构重构为标准的 EpiClaude 结构。

## 步骤 1: 扫描 (Scan)

请扫描项目根目录，识别以下"非标准"文件和文件夹：
- 常见的乱命名: `data/`, `analysis/`, `manuscript/`, `input/`, `output/`
- 散落在根目录的文件: `*.csv`, `*.xlsx`, `*.png`, `*.docx` (除了 `README.md` 等标准文件)
- 不规范的命名: `final_v2_revised.R`

## 步骤 2: 确认 (Confirm)

向用户展示扫描结果，并询问：
"检测到以下非标准文件。是否要将它们移动到 `09_backup/archived_[date]/`？"

## 步骤 3: 归档 (Archive)

如果用户同意：
1. 创建目录: `09_backup/archived_[YYYYMMDD]/`
2. **移动 (Move)** 所有非标准文件到该目录
3. **保留 (Keep)** 标准目录: `01_data` 至 `07_paper`, `.claude`, `.git`

## 步骤 4: 检查 (Correction)

检查标准目录是否为空。如果 `01_data` 是空的但刚才移走了 `data/`，询问用户：
"警告：`01_data` 为空。是否需要从刚才的备份中找回原始数据？"

## 步骤 5: 报告 (Report)

更新 `SESSION_LOG.md`：
```markdown
| date | Cleanup | - | ✅ 归档 15 个文件到 09_backup/archived_... |
```
