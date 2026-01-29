---
description: 从原始数据到论文初稿的完整分析流程
---

# 数据到论文工作流

## 触发方式

当用户说:
- `/data-to-paper`
- "完整分析流程"
- "从数据开始做分析"

## 执行步骤

### 阶段 1: 数据探索

1. 加载数据
```r
library(tidyverse)
data_raw <- read_excel("01_data/raw_data.xlsx")
```

2. 数据概览
```r
glimpse(data_raw)
skim(data_raw)
```

3. 缺失值检查
```r
data_raw |> summarise(across(everything(), ~sum(is.na(.x))))
```

### 阶段 2: 数据清洗

1. 变量选择与重命名
2. 类型转换
3. 缺失值处理
4. 异常值处理
5. 保存清洗后数据

```r
save(data_neat, file = "06_results/00_data_neat.RData")
```

### 阶段 3: 描述性分析

1. 生成 Table 1 (基线表)
```r
library(gtsummary)
tbl_summary(data, by = group) |> add_p()
```

2. 导出表格
```r
as_gt() |> gtsave("03_tables/01_Table1.docx")
```

### 阶段 4: 主分析

根据研究类型选择:
- **队列研究**: Cox 回归 → HR
- **病例对照**: 逻辑回归 → OR
- **横断面**: 相关/回归分析

导出:
- 结果表格 → `03_tables/`
- 图表 → `04_figures/`

### 阶段 5: 敏感性分析

1. 亚组分析
2. 调整不同协变量
3. 敏感性分析森林图

### 阶段 6: 可视化

1. 森林图 (OR/HR)
2. 生存曲线 (KM)
3. 其他必要图表

**导出规范**:
```r
ggsave("04_figures/Fig1.png", dpi = 300, device = ragg::agg_png)
ggsave("04_figures/Fig1.pdf", device = cairo_pdf)
```

### 阶段 7: 文档更新

更新结果汇总:
1. `07_paper/0_result_summaries.md` (论文用)
2. `05_reports/0_report_summaries.md` (汇报用)

### 阶段 8: 论文初稿

根据结果生成论文方法和结果部分初稿。

## 完成清单

- [ ] 数据清洗完成，保存 RData
- [ ] Table 1 生成并导出
- [ ] 主分析完成
- [ ] 敏感性分析完成
- [ ] 图表导出 (PNG + PDF)
- [ ] 结果汇总更新
- [ ] 清理临时文件
