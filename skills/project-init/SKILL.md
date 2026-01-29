---
name: project-init
description: |
  标准化卫生统计研究项目初始化技能。一键创建七层目录结构、模板文件、Git配置。
  触发场景：(1) 用户说"创建项目"、"初始化"、"新建项目"；(2) 需要标准研究项目结构；(3) 开始新的数据分析任务。
---

# 项目初始化技能

## 执行流程

### 1. 询问信息

```
请提供：
1. 项目名称 (英文_snake_case): 
2. 研究类型: [1]队列 [2]病例对照 [3]横断面 [4]干预
```

### 2. 创建结构

在 R 中运行初始化脚本：

```r
source("path/to/skills/project-init/scripts/init_project.R")
init_project("my_project", type = 1)  # 1=队列 2=病例对照 3=横断面 4=干预
```

```
{project}/
├── 01_data/          # 只读
├── 02_code/
├── 03_tables/
├── 04_figures/
├── 05_reports/
├── 06_results/
├── 07_paper/
└── 09_backup/
```

### 3. 生成模板

| 文件 | 内容 |
|------|------|
| `CLAUDE.md` | 继承全局规则 |
| `README.md` | 项目说明模板 |
| `01_data/README.md` | 数据字典模板 |
| `02_code/01_data_cleaning.R` | 清洗脚本模板 |
| `07_paper/0_result_summaries.md` | 结果汇总模板 |
| `.gitignore` | 忽略数据和临时文件 |

### 4. 确认输出

```
✅ 项目 [{name}] 创建成功!

下一步:
1. 放入原始数据 → 01_data/
2. 填写数据说明 → 01_data/README.md
3. 开始清洗 → 02_code/01_data_cleaning.R
```
