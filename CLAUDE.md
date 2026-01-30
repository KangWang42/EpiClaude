---
description: 'EpiClaude - 流行病学 R 编程规范'
applyTo: '**/*.R, **/*.Rmd'
---

# 🔬 EpiClaude 规范 (精简版)

> ⚠️ **本文件为 AI 强制规则，每次操作前必须遵守！**

---

## 🚨 核心规则 (必读!)

### 📁 文件命名规范 (强制!)

| 目录 | 命名格式 | 示例 |
|------|----------|------|
| `02_code/` | `NN_描述.R` | `01_data_cleaning.R`, `02_main_analysis.R` |
| `04_figures/` | `FigN_描述.png/pdf` | `Fig1_KM_curve.png` |
| `03_tables/` | `TableN_描述.xlsx` | `Table1_baseline.xlsx` |

> **🚫 禁止**: `test.R`, `temp.R`, `final.R`, 无编号脚本

### 📝 强制日志更新

每次操作后 **必须** 更新:
1. `SESSION_LOG.md` - 添加一行: `| 时间 | 操作 | 文件 | 结果 |`
2. `DECISIONS.md` - 有方法选择时记录

> ⚠️ **不更新日志 = 任务未完成!**

---

## 🚫 绝对禁止

| 禁止 | 替代 |
|------|------|
| `print()`/`cat()` | 直接返回对象 |
| `for` 循环 | `purrr::map_*()` |
| 绝对路径 | `"01_data/file.csv"` |
| 修改 `rawdata/` | 输出到 `01_data/` |
| 根目录放文件 | 放入对应子目录 |
| 无编号 R 脚本 | `01_xxx.R, 02_xxx.R` |

---

## 📁 目录结构

```
项目/
├── CLAUDE.md, SESSION_LOG.md, DECISIONS.md
├── 01_data/rawdata/ (🔒只读) + 清洗数据
├── 02_code/         (NN_xxx.R 格式)
├── 04_figures/      (唯一图库)
├── 07_paper/        (仅文稿，无图片)
└── 09_backup/       (回收站)
```

---

## ✅ 每次操作检查清单

**创建文件前:**
- [ ] R 脚本 → `02_code/NN_描述.R`
- [ ] 图片 → `04_figures/`
- [ ] 表格 → `03_tables/`

**操作完成后:**
- [ ] 更新 `SESSION_LOG.md`
- [ ] 清理根目录临时文件
- [ ] 方法变更 → 更新 `DECISIONS.md`

---

## 📊 技术栈

```r
library(tidyverse)  # 数据处理
library(gtsummary)  # Table 1
library(ggsci)      # 配色: scale_fill_lancet()
library(ragg)       # 中文图导出
```

---

## 🎨 图表导出

```r
ggsave("04_figures/Fig1.png", p, dpi=300, width=8, height=6, device=ragg::agg_png)
ggsave("04_figures/Fig1.pdf", p, width=8, height=6, device=cairo_pdf)
```

---

## 🔁 记忆锚点 (每次操作前回顾)

> **三件事不能忘:**
> 1. 📁 R 脚本必须放 `02_code/NN_xxx.R`
> 2. 📝 操作后必须更新 `SESSION_LOG.md`
> 3. 🧹 根目录不能有临时文件

---

## 🛠️ 可用技能 (自动调用)

> **⚠️ 执行以下任务时，必须先读取对应 SKILL.md！**

| 触发词 | 技能 | 说明 |
|--------|------|------|
| "创建项目"/"初始化" | `/project-init` | 创建标准七层目录 |
| "写论文"/"生成论文" | `/paper-writing` | 生成 6000+ 字完整论文 |
| R 统计分析/回归/生存 | `/r-biostats` | 核心统计分析规范 |
| "去AI味"/"润色" | `/humanizer-zh` | 去除 AI 生成痕迹 |

**使用方法:**
1. 识别用户需求匹配上述触发词
2. 读取对应 skill 的 SKILL.md
3. 按 SKILL.md 中的流程执行

