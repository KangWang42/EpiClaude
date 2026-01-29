---
description: 'EpiAgent - 流行病学与卫生统计 R 编程规范'
applyTo: '**/*.R, **/*.r, **/*.Rmd, **/*.qmd'
---

# 🔬 EpiAgent 项目规范

> 流行病学与卫生统计 R 语言编程规范 - 适用于医学研究生、临床数据分析、真实世界数据研究

---

## ⚡ 快速参考

```
管道: |> (Native Pipe)         配色: scale_fill_lancet()
循环: map_*() (purrr)          字体: "SimSun" (PDF中文)
路径: "01_data/file.csv"       导出: ragg::agg_png + cairo_pdf
```

---

## 🚫 绝对禁止

| 禁止 | 原因 | 替代 |
|------|------|------|
| `print()` / `cat()` | 污染输出 | 直接返回对象 |
| `for` 循环 | 低效 | `purrr::map_*()` |
| 绝对路径 | 不可复现 | `"01_data/file.csv"` |
| 手动配色 | 不专业 | `ggsci::scale_fill_lancet()` |
| 修改 `01_data/` | 破坏原始数据 | 输出到其他目录 |

---

## ✅ 必须执行

### 每次操作

1. ✍️ 中文注释关键步骤
2. 🏃 生成代码后立即运行验证
3. 📊 图表双格式导出 (PNG 300dpi + PDF)
4. 📝 更新 `SESSION_LOG.md` 记录操作
5. 💾 保存代码到 `.R` 脚本

### 重要决策时

6. 🔄 记录到 `DECISIONS.md`
7. 📋 更新 `07_paper/0_result_summaries.md`

---

## 📝 工作流日志 (重要!)

### SESSION_LOG.md - 每次操作后更新

```markdown
| 2026-01-30 10:30 | 数据清洗 | 01_clean.R | ✅ 剔除缺失 123 例 |
```

### DECISIONS.md - 方法选择时记录

```markdown
### DEC-002: Cox vs 逻辑回归
**状态**: ✅ 采纳 Cox
**理由**: 有生存时间数据，Cox 更合适
```

### 方法比较格式

```markdown
| v1 | 完全病例 | HR=1.25 | 基准 |
| v2 | 多重插补 | HR=1.22 | ✅ 采用 |
```

### 回滚标记

```markdown
**状态**: ❌ 放弃
**理由**: 效果不佳，回退 v1
```

---

## 📁 项目结构

```
项目名/
├── CLAUDE.md           # 本文件
├── SESSION_LOG.md      # 会话日志
├── DECISIONS.md        # 决策日志
├── 01_data/            # 原始数据 (只读!)
├── 02_code/            # R 脚本 (01_*, 02_*, ...)
├── 03_tables/          # 输出表格
├── 04_figures/         # 输出图表 (PNG + PDF)
├── 05_reports/         # 汇报文档
├── 06_results/         # RData 对象
├── 07_paper/           # 论文 + 0_result_summaries.md
└── 09_backup/          # 备份
```

---

## 📦 技术栈

### 必须使用

```r
library(tidyverse)    # dplyr, tidyr, purrr, ggplot2
library(gtsummary)    # Table 1
library(broom)        # tidy(), glance()
library(ggsci)        # 配色
library(ragg)         # 中文图片导出
```

### 按需使用

```r
library(survival)     # 生存分析
library(survminer)    # KM 曲线
library(mediation)    # 中介效应
library(meta)         # Meta 分析
library(officer)      # Word 导出
```

### 禁止使用

```r
# plyr, reshape2, showtext
```

---

## 🎨 可视化规范

### 配色

```r
# 分类 ≤5 类
scale_fill_lancet()

# 分类 >5 类
scale_fill_npg()

# 连续变量
scale_fill_viridis_c()
```

### 中文导出

```r
# PNG (推荐)
ggsave("04_figures/Fig1.png", plot, dpi = 300, 
       width = 8, height = 6, device = ragg::agg_png)

# PDF
ggsave("04_figures/Fig1.pdf", plot, 
       width = 8, height = 6, device = cairo_pdf)
```

---

## 🔄 标准代码模式

### 数据处理

```r
data_neat <- data_raw |>
  select(id, age, sex, outcome) |>
  mutate(
    age_group = cut(age, breaks = c(0, 40, 60, Inf)),
    sex = factor(sex, labels = c("女", "男"))
  ) |>
  filter(!is.na(outcome))
```

### 回归分析

```r
model_fit <- logistic_reg() |>
  set_engine("glm") |>
  fit(outcome ~ age + sex, data = data_neat)

tidy(model_fit, conf.int = TRUE, exponentiate = TRUE)
```

### Table 1

```r
data_neat |>
  tbl_summary(
    by = group,
    include = c(age, sex, bmi),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    )
  ) |>
  add_p()
```

---

## 🧹 清理协议

### 触发条件

- 方法比选完成
- 敏感性分析确认主结果稳健
- 即将提交论文

### 执行

```r
# 删除淘汰方案产物
file.remove("04_figures/淘汰方案.png")

# 备份保留版本
file.copy("06_results/v1.RData", "09_backup/")
```

### 检查清单

- [ ] `03_tables/` 仅含最终表格
- [ ] `04_figures/` 仅含最终图表
- [ ] `SESSION_LOG.md` 已记录清理
- [ ] `0_result_summaries.md` 已更新

---

## 🧠 问题解决

### 复杂问题

1. **分解** → 识别子问题和决策点
2. **生成** → 每个决策点 2-3 个方案
3. **评估** → 统计严谨性 > 可解释性 > 效率
4. **决策** → 选最简方案，记录到 DECISIONS.md

### 闭环验证

```
写代码 → 跑代码 → 看结果 → 修错误 → 记日志
```

**严禁只写不跑！**

---

## 📋 命名规范

```r
# 变量
data_neat       # 数据框
model_cox       # 模型
plot_km         # 图表
table_base      # 表格

# 文件
01_data_cleaning.R
02_descriptive.R
03_main_analysis.R
```

---

## 🔗 相关文件

- `SESSION_LOG.md` - 操作记录
- `DECISIONS.md` - 决策记录
- `07_paper/0_result_summaries.md` - 结果汇总
