---
name: r-biostats
description: |
  R 语言流行病学与生物统计分析核心技能。专为医学研究生、临床数据分析、真实世界数据(RWD)研究设计。
  触发场景：(1) 用户进行任何 R 统计分析；(2) 需要描述统计、回归、生存分析、中介效应、Meta分析；(3) 需要数据清洗或可视化；(4) R 代码错误调试；(5) 生成出版级图表或统计表格。
---

# R 流行病学与生物统计核心技能

## 核心原则

> **奥卡姆剃刀**: 如无必要，勿增实体。**决策后立即清理！**

### 禁止

- `print()`, `cat()` → 直接返回对象
- `for` 循环 → `purrr::map_*()` 或 `across()`
- 绝对路径 → 相对路径 `"01_data/file.csv"`
- `scale_fill_manual()` → `ggsci::scale_fill_lancet()`
- 修改 `01_data/` 原始数据

### 必须

- 中文注释关键步骤
- 代码执行验证
- 双格式导出 (PNG 300dpi + PDF)
- 更新 `07_paper/0_result_summaries.md`
- 命名规范 `lower_snake_case`

---

## 技术栈

```r
library(tidyverse)   # 数据处理
library(tidymodels)  # 建模框架
library(gtsummary)   # 表格输出
library(broom)       # 结果整理
library(ggsci)       # 科学配色
library(ragg)        # 中文图片导出
```

---

## 分析类型速查

根据分析需求加载对应参考文件：

| 分析类型 | 参考文件 | 关键包 |
|----------|----------|--------|
| 描述统计/Table 1 | [descriptive.md](references/descriptive.md) | gtsummary |
| 回归分析 (线性/逻辑/Poisson) | [regression.md](references/regression.md) | tidymodels, broom |
| 生存分析 (KM/Cox) | [survival.md](references/survival.md) | survival, survminer |
| 中介/调节效应 | [mediation.md](references/mediation.md) | mediation, lavaan |
| Meta 分析 | [meta.md](references/meta.md) | meta, metafor |
| 可视化规范 | [visualization.md](references/visualization.md) | ggplot2, ggsci |

---

## 项目结构

```
project/
├── 01_data/      # 原始数据 (只读)
├── 02_code/      # R 脚本
├── 03_tables/    # 输出表格
├── 04_figures/   # 输出图片
├── 05_reports/   # 汇报文档
├── 06_results/   # RData 对象
└── 07_paper/     # 论文终稿
```

---

## 标准工作流

1. **探查**: 检查变量类型、缺失值、分布
2. **清洗**: 处理缺失、编码分类变量
3. **描述**: 生成 Table 1
4. **分析**: 执行主分析 (参考对应 references/)
5. **敏感性**: 验证结果稳健性
6. **可视化**: 参考 [visualization.md](references/visualization.md)
7. **文档**: 更新 `0_result_summaries.md`

---

## 导出规范

```r
# PNG (中文)
ggsave("04_figures/Fig1.png", plot, dpi = 300, device = ragg::agg_png)

# PDF
ggsave("04_figures/Fig1.pdf", plot, device = cairo_pdf)
```

---

## 结果汇总模板

完成分析后更新 `07_paper/0_result_summaries.md`：

```markdown
## [分析名称]

### 样本
- N = XXX

### 主要结果
| 变量 | 效应值 | 95% CI | P |
|------|--------|--------|---|

### 结论
[一句话结论]
```
