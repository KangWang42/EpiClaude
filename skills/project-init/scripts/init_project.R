# ================================================
# 卫生统计研究项目初始化脚本
# 用法: source("init_project.R"); init_project("project_name", type = 1)
# ================================================

#' 初始化标准研究项目
#' @param name 项目名称 (英文 snake_case)
#' @param type 研究类型: 1=队列, 2=病例对照, 3=横断面, 4=干预
init_project <- function(name, type = 1) {
  
  study_types <- c(
    "队列研究 (Cohort)",
    "病例对照 (Case-Control)",
    "横断面 (Cross-Sectional)",
    "干预研究 (Intervention)"
  )
  
  dirs <- c(
    "01_data", "02_code", "03_tables", "04_figures",
    "05_reports", "06_results", "07_paper", "09_backup"
  )
  
  # 创建目录
  dir.create(name, showWarnings = FALSE)
  for (d in dirs) {
    dir.create(file.path(name, d), showWarnings = FALSE)
  }
  
  date <- format(Sys.Date(), "%Y-%m-%d")
  study <- study_types[type]
  
  # CLAUDE.md
  writeLines(c(
    "---",
    sprintf("description: '%s 项目 R 编程规范'", name),
    "applyTo: '**/*.R'",
    "---",
    "",
    sprintf("# %s", name),
    "",
    sprintf("- 研究类型: %s", study),
    sprintf("- 创建时间: %s", date),
    "",
    "继承全局规则。"
  ), file.path(name, "CLAUDE.md"))
  
  # README.md
  writeLines(c(
    sprintf("# %s", name),
    "",
    "## 研究目的",
    "<!-- 填写 -->",
    "",
    "## 分析计划",
    "1. 数据清洗",
    "2. 描述性分析",
    "3. 主分析",
    "4. 敏感性分析",
    "",
    "## 目录",
    "- `01_data/`: 原始数据 (只读)",
    "- `02_code/`: 分析代码",
    "- `07_paper/`: 论文终稿"
  ), file.path(name, "README.md"))
  
  # 01_data/README.md
  writeLines(c(
    "# 数据说明",
    "",
    "## 来源",
    "<!-- 填写 -->",
    "",
    "## 变量",
    "| 变量名 | 类型 | 说明 |",
    "|--------|------|------|"
  ), file.path(name, "01_data", "README.md"))
  
  # 02_code/01_data_cleaning.R
  writeLines(c(
    "# ================================================",
    sprintf("# 数据清洗脚本 - %s", name),
    sprintf("# 创建: %s", date),
    "# ================================================",
    "",
    "library(tidyverse)",
    "library(readxl)",
    "",
    "# 读取数据 ----",
    "# data_raw <- read_excel(\"01_data/xxx.xlsx\")",
    "",
    "# 数据概览 ----",
    "# glimpse(data_raw)",
    "",
    "# 清洗 ----",
    "# data_neat <- data_raw |>",
    "#   select() |>",
    "#   mutate()",
    "",
    "# 保存 ----",
    "# save(data_neat, file = \"06_results/00_data_neat.RData\")"
  ), file.path(name, "02_code", "01_data_cleaning.R"))
  
  # 07_paper/0_result_summaries.md
  writeLines(c(
    sprintf("# %s 结果汇总", name),
    "",
    sprintf("创建: %s", date),
    "",
    "## 描述性统计",
    "<!-- 待更新 -->",
    "",
    "## 主分析",
    "<!-- 待更新 -->"
  ), file.path(name, "07_paper", "0_result_summaries.md"))
  
  # SESSION_LOG.md (会话日志)
  writeLines(c(
    "# 📋 会话日志 (Session Log)",
    "",
    "> 每次 Claude 操作后自动更新",
    "",
    "## 最近操作",
    "",
    "| 时间 | 操作 | 文件 | 结果 |",
    "| ---- | ---- | ---- | ---- |",
    sprintf("| %s | 项目创建 | - | ✅ 初始化完成 |", date),
    "",
    "## 方法比较",
    "",
    "| 版本 | 方法 | 结果 | 备注 |",
    "| ---- | ---- | ---- | ---- |",
    "| v1 | _待记录_ | | 基准 |"
  ), file.path(name, "SESSION_LOG.md"))
  
  # DECISIONS.md (决策日志)
  writeLines(c(
    "# 🔄 决策日志 (Decisions Log)",
    "",
    "> 记录重要分析决策，便于回溯",
    "",
    "## 决策列表",
    "",
    "_按时间倒序_",
    "",
    "### DEC-001: [待记录]",
    "",
    sprintf("**日期**: %s", date),
    "**状态**: 🔄 待定",
    "",
    "**背景**: ",
    "",
    "**选项**:",
    "1. 方案A",
    "2. 方案B",
    "",
    "**决定**: _待填写_"
  ), file.path(name, "DECISIONS.md"))
  
  # .gitignore
  writeLines(c(
    "# 数据",
    "01_data/*.xlsx",
    "01_data/*.csv",
    "01_data/*.sav",
    "",
    "# R",
    ".Rhistory",
    ".RData",
    ".Rproj.user",
    "06_results/*.RData",
    "",
    "# 系统",
    ".DS_Store",
    "Thumbs.db"
  ), file.path(name, ".gitignore"))
  
  cat(sprintf("\n✅ 项目 [%s] 创建成功!\n", name))
  cat(sprintf("   类型: %s\n", study))
  cat(sprintf("   路径: %s\n\n", normalizePath(name)))
  cat("下一步:\n")
  cat("  1. 放入原始数据 → 01_data/\n")
  cat("  2. 填写数据说明 → 01_data/README.md\n")
  cat("  3. 开始清洗 → 02_code/01_data_cleaning.R\n")
  
  invisible(name)
}
