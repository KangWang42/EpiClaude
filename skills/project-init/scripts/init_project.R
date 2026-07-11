# ============================================================
# init_project.R
# 一键创建卫生统计研究项目骨架
#
# 用法：从 Claude Code 的 ~/.claude/skills、Codex 的 ~/.agents/skills，
#       或 EPICLAUDE_SKILLS 指定目录 source 本脚本后运行：
#   init_project("cohort_smoking_chd", type = 1, mode = "research")
#   init_project("client_xxx_survival", type = 1, mode = "consulting")
# ============================================================

init_project <- function(name,
                         type = 1,
                         mode = c("research", "consulting"),
                         root = ".",
                         git = TRUE,
                         overwrite = FALSE) {
  mode <- match.arg(mode)
  type_names <- c("cohort", "case_control", "cross_sectional",
                  "rct", "meta", "rwd", "methodology")
  stopifnot(type %in% seq_along(type_names))

  # 名称检查 -----------------------------------------------
  if (!grepl("^[a-z][a-z0-9_]*$", name)) {
    warning("项目名建议 snake_case（小写 + 下划线），例如 'cohort_smoking_chd'")
  }

  proj <- file.path(root, name)
  if (dir.exists(proj) && !overwrite) {
    stop("目录已存在：", proj, "；如需覆盖请 overwrite = TRUE")
  }

  # 建目录 -------------------------------------------------
  dirs <- c(
    "01_data/rawdata",
    "02_code",
    "03_tables",
    "04_figures",
    "05_reports",
    "06_results",
    "07_paper",
    "09_backup"
  )
  invisible(lapply(file.path(proj, dirs),
                   dir.create, recursive = TRUE, showWarnings = FALSE))

  today <- format(Sys.Date(), "%Y-%m-%d")
  today_md <- format(Sys.Date(), "%-m-%-d")
  type_name <- type_names[type]

  # 项目规则：CLAUDE.md 为单源，AGENTS.md 指示 Codex 读取它 ----
  claude_md <- c(
    sprintf("# %s · 项目级规则", name),
    "",
    "本项目继承 EpiClaude 全局规则（Claude Code：`~/.claude/CLAUDE.md`；Codex：`~/.codex/AGENTS.md`）。",
    "以下是本项目专属约束。",
    "",
    "## 项目基本信息",
    "",
    sprintf("- 研究类型：%s", type_name),
    "- 研究问题：[一句话 PICOS]",
    "- 数据来源：[数据集名 + 时间段]",
    "- 主要终点：[具体定义]",
    "- 分析计划：[主分析 + 敏感性]",
    "",
    "## 口径锁定（严禁擅自变动）",
    "",
    "- 纳入标准：",
    "- 排除标准：",
    "- 暴露变量：",
    "- 结局变量：",
    "- 随访时间：",
    "- 协变量：",
    "",
    "口径变动 → 先改本节 → 记录 `DECISIONS.md` → 重跑受影响的分析。",
    "",
    if (mode == "consulting")
      c("## 咨询模式专属",
        "",
        "- 交付前必过 `consulting-delivery` 的 FINAL 终检清单（§八）",
        "- `05_reports/` 内结果包必须自包含，`run_all.R` 能在空 session 跑通",
        "") else NULL
  )
  writeLines(claude_md, file.path(proj, "CLAUDE.md"), useBytes = TRUE)
  writeLines(
    c("# Codex 项目指引",
      "",
      "开始任何项目工作前，完整读取同目录 `CLAUDE.md`。",
      "`CLAUDE.md` 是项目口径、当前状态与工作流约束的单一真源；本文件不复制其内容，避免双份规则漂移。"),
    file.path(proj, "AGENTS.md"), useBytes = TRUE
  )

  # SESSION_LOG.md ----------------------------------------
  writeLines(
    c("# Session Log",
      "",
      "| 时间 | 操作 | 文件 | 结果 |",
      "|------|------|------|------|",
      sprintf("| %s | 项目初始化 | 全部目录和模板 | 骨架就绪 |", today)),
    file.path(proj, "SESSION_LOG.md"), useBytes = TRUE
  )

  # DECISIONS.md ------------------------------------------
  writeLines(
    c("# 方法决策记录",
      "",
      "所有会影响最终结果的方法选择都必须写到这里。",
      "格式：时间 + 选择 + 原因 + 放弃的替代方案。",
      "",
      "---",
      "",
      sprintf("## %s · 项目启动", today),
      "",
      sprintf("**决策**：项目类型 = %s，主分析计划 = [待用户确认]", type_name),
      "**原因**：[待用户填写]",
      "**放弃方案**：[待用户填写]"),
    file.path(proj, "DECISIONS.md"), useBytes = TRUE
  )

  # BACKLOG.md --------------------------------------------
  writeLines(
    c("# BACKLOG · 待补清单",
      "",
      "全项目周期随时冒出来的缺口与待办都进这里：缺文献、缺数据、缺方法/分析、",
      "写作待补、下一步规划。规划研究方案时先扫本文件，决定下一步让 AI 做",
      "什么、自己去找哪些数据 / 做哪些决策。",
      "",
      "维护规则：",
      "",
      "- 任何时候（清洗 / 分析 / 出图 / 写作 / 审查）发现缺口或想法 → 立即追加一行到主表顶部，不留到\"以后\"。",
      "- 本表只装\"主流程要用的事\"——做完的、没做的同在一张表，靠「状态」列区分，不另设已完成表。",
      "- **待完善内容**：开头加【文献/数据/方法/分析/写作/规划】类别标签，便于规划时筛。",
      "- **完善方式**：AI（agent 可直接做：编程 / 分析 / 检索 / 下载）| 人工（需我提供数据 / 外部资源 / 做决策）。",
      "- **重要性**三档：",
      "  - 必补 —— 不补研究做不了 / 结论不成立 / 无法投稿（阻断项，最高优先）。",
      "  - 建议 —— 补了完善论文（敏感性、稳健性、对照、双标化等），不补也能成稿。",
      "  - 可选 —— 探索 / 锦上添花 / 不确定有无用。",
      "- **状态**：完成填 `✅ YYYY-MM-DD`，未完成留空；做完只打勾不删行（删了查不到\"补过没\"）。",
      "- **做了发现不该进主流程**（效果不好 / 实属探索）→ 不留主表，整条挪到 `09_backup/<日期>_<主题>/` 并在 FINDINGS.md 记结论；本表「已移出」区只留一行指针。",
      "",
      "## 待办与已完成（同一张表，新发现加到顶部）",
      "",
      "| 待完善内容 | 完善方式 | 重要性 | 状态 |",
      "|------------|----------|--------|------|",
      "| 【方法】主分析可加竞争风险模型作敏感性分析 | AI | 建议 |  |",
      "| 【数据】缺基线用药史，需回原始库提取或问数据方 | 人工 | 必补 |  |",
      sprintf("| 【数据】（示例已完成）省界 GeoJSON 已下载，出地图用 | AI | 建议 | ✅ %s |", today),
      "",
      "（首次使用删除上面三行示例）",
      "",
      "## 已移出主流程（挪至 09_backup，留指针不留正文）",
      "",
      "| 原待完善内容 | 去向（09_backup/…） | 原因 | 日期 |",
      "|--------------|----------------------|------|------|"),
    file.path(proj, "BACKLOG.md"), useBytes = TRUE
  )

  # README.md ---------------------------------------------
  writeLines(
    c(sprintf("# %s", name),
      "",
      sprintf("**研究类型**：%s", type_name),
      sprintf("**启动日期**：%s", today),
      sprintf("**模式**：%s", if (mode == "research") "研究" else "咨询"),
      "",
      "## 目录结构",
      "",
      "```",
      "01_data/       # 原始数据（只读）",
      "02_code/       # R 脚本",
      "03_tables/     # 最终表",
      "04_figures/    # 最终图",
      "05_reports/    # 结果分享包",
      "06_results/    # 中间产物",
      "07_paper/      # 论文稿 + 结果汇总",
      "09_backup/     # 归档",
      "```",
      "",
      "另有 `BACKLOG.md`（待补清单）：缺文献 / 缺数据 / 缺方法 / 下一步规划随时记录，规划时先看它。",
      "",
      "## 快速开始",
      "",
      "1. 把原始数据放入 `01_data/rawdata/`",
      "2. 填写 `01_data/README.md` 数据字典",
      "3. 锁口径：打开 `CLAUDE.md`，填\"口径锁定\"节（Codex 由 `AGENTS.md` 自动指向该单源）",
      "4. 开始清洗：打开 `02_code/01_data_cleaning.R`"),
    file.path(proj, "README.md"), useBytes = TRUE
  )

  # 07_paper/results.yaml（机器可读单源）------------------
  writeLines(
    c("# 结果单一真源（machine-readable）。数字只在此处改；",
      "# 下游论文/报告/PPT 一律 val(\"07_paper/results.yaml\", \"key\") 取数，禁手敲。",
      "# 改下游须先回写此处再向其余下游传播（双向一致性）。",
      "# 写入与渲染用 r-biostats/scripts/emit_summary.R 的 add_result()；",
      "# 0_result_summaries.md 由 render_summary_md() 从本文件生成，勿手改 md。",
      "meta:",
      "  project: \"[项目名]\"",
      "results: {}",
      "# 示例（由 add_result 自动写成，勿手敲）：",
      "#  S2_vs_S1_diff:",
      "#    label: S2 vs S1 组间差异",
      "#    section: 主要结果",
      "#    source: 02_code/03_main.R",
      "#    table: Table2",
      "#    raw: {est: -1.82, ci_low: -3.29, ci_high: -0.36, p: 0.015, unit: kg}",
      "#    rendered: {full: \"...\", est_ci: \"...\", p: \"...\"}",
      "#    interp: \"结论/效应解读（人写）；数字变了会自动标 interp_review 待复核\"",
      "# conclusion: \"跨结果总结论（人写，set_conclusion 写）\""),
    file.path(proj, "07_paper/results.yaml"), useBytes = TRUE
  )

  # 07_paper/0_result_summaries.md（由 results.yaml 自动生成）----
  writeLines(
    c("# 结果汇总（论文数据源 · 由 results.yaml 自动生成）",
      "",
      "本文件由 `emit_summary.R::render_summary_md()` 从 `results.yaml` 渲染，**勿手改**。",
      "改数字 → 改 `results.yaml`（或重跑产出脚本的 add_result）→ 重跑 render_summary_md。",
      "所有图表 / docx / 论文正文的数字一律 val() 从 results.yaml 取，与本文件同源。",
      "",
      "（首次分析后此处自动填入分节结果。）"),
    file.path(proj, "07_paper/0_result_summaries.md"), useBytes = TRUE
  )

  # 01_data/README.md -------------------------------------
  writeLines(
    c("# 数据字典",
      "",
      "## 数据来源",
      "",
      "- 数据集名称：",
      "- 提供方：",
      "- 数据时间范围：",
      "- 样本量（原始）：",
      "- 获取日期：",
      "- 伦理批件号：",
      "",
      "## 变量清单",
      "",
      "| 变量名 | 类型 | 单位 | 编码 | 说明 | 缺失率 |",
      "|--------|------|------|------|------|--------|",
      "| id | chr | — | 匿名编码 | 唯一标识 | 0% |",
      "| age | num | 年 | — | 基线年龄 | — |",
      "| sex | int | — | 1=男 2=女 | — | — |"),
    file.path(proj, "01_data/README.md"), useBytes = TRUE
  )

  # 02_code/01_data_cleaning.R ----------------------------
  cleaning_r <- c(
    "# ============================================================",
    "# 脚本：02_code/01_data_cleaning.R",
    "# 目的：从 01_data/rawdata/ 读取原始数据，清洗为分析用数据集",
    "# 输入：01_data/rawdata/xxx.csv",
    "# 输出：06_results/cohort_clean.xlsx（表格化数据一律 xlsx；06_results 按内容命名不编号）",
    "#       03_tables/Table0_flowchart.xlsx",
    "# ============================================================",
    "",
    "library(tidyverse)",
    "library(here)",
    "library(writexl)",
    "",
    'here::i_am("02_code/01_data_cleaning.R")',
    "set.seed(123)",
    "",
    "# 1. 读取 ----------------------------------------------------",
    '# raw <- readr::read_csv("01_data/rawdata/xxx.csv", show_col_types = FALSE)',
    "",
    "# 2. 样本量损失链 --------------------------------------------",
    "# n_raw <- nrow(raw)",
    "# step1 <- raw |> filter(!is.na(exposure))",
    "# step2 <- step1 |> filter(age >= 18)",
    "",
    "# 3. 编码分类变量 --------------------------------------------",
    "# cohort <- step2 |>",
    "#   mutate(sex = factor(sex, levels = c(1, 2), labels = c('Male', 'Female')))",
    "",
    "# 4. 保存 ----------------------------------------------------",
    '# writexl::write_xlsx(cohort, "06_results/cohort_clean.xlsx")',
    "",
    '# flowchart <- tibble(step = ..., n = ..., loss = ...)',
    '# writexl::write_xlsx(flowchart, "03_tables/Table0_flowchart.xlsx")',
    "",
    'message("清洗完成（模板，待填充实际逻辑）")'
  )
  writeLines(cleaning_r, file.path(proj, "02_code/01_data_cleaning.R"), useBytes = TRUE)

  # .gitignore --------------------------------------------
  writeLines(
    c("# 数据（敏感）",
      "01_data/rawdata/*",
      "!01_data/rawdata/.gitkeep",
      "!01_data/README.md",
      "",
      "# 中间产物",
      "06_results/*",
      "!06_results/.gitkeep",
      "",
      "# 系统",
      ".Rproj.user/",
      ".Rhistory",
      ".RData",
      ".DS_Store",
      "Thumbs.db",
      "~$*",
      "",
      "# 编辑器",
      ".vscode/",
      ".idea/",
      "",
      "# 临时",
      "*.tmp",
      "*.bak"),
    file.path(proj, ".gitignore"), useBytes = TRUE
  )
  file.create(file.path(proj, "01_data/rawdata/.gitkeep"))

  # .Rproj ------------------------------------------------
  writeLines(
    c("Version: 1.0",
      "",
      "RestoreWorkspace: No",
      "SaveWorkspace: No",
      "AlwaysSaveHistory: Default",
      "",
      "EnableCodeIndexing: Yes",
      "UseSpacesForTab: Yes",
      "NumSpacesForTab: 2",
      "Encoding: UTF-8",
      "",
      "AutoAppendNewline: Yes",
      "StripTrailingWhitespace: Yes",
      "LineEndingConversion: Posix"),
    file.path(proj, paste0(name, ".Rproj")), useBytes = TRUE
  )

  # 咨询模式：预建一个结果包骨架 --------------------------
  if (mode == "consulting") {
    pack_name <- sprintf("结果-%s-主题占位", today_md)
    pack <- file.path(proj, "05_reports", pack_name)
    invisible(lapply(
      file.path(pack, c("data", "code", "06_results", "tables", "figures")),
      dir.create, recursive = TRUE, showWarnings = FALSE
    ))

    writeLines(
      c(sprintf("# %s", pack_name),
        "",
        "（首次使用请把\"主题占位\"改成实际主题，例如\"训练测试集\"）",
        "",
        "## 这份文件夹是什么",
        "",
        "[一句话说明]",
        "",
        "## 怎么看结果",
        "",
        "- 方法与结论 → `01_方法与结果.docx`",
        "- 表格 → `tables/`",
        "- 图件 → `figures/`",
        "",
        "## 怎么重现",
        "",
        "1. 在 RStudio 打开 `run_all.R`",
        "2. Session → Set Working Directory → To Source File Location",
        "3. Ctrl+Shift+Enter 运行全文"),
      file.path(pack, "00_客户说明.md"), useBytes = TRUE
    )

    writeLines(
      c("# ============================================================",
        sprintf("# %s · 一键复现脚本", pack_name),
        "# ============================================================",
        "",
        'if (!file.exists("run_all.R")) stop("工作目录错了")',
        "",
        'required_pkgs <- c("tidyverse", "readxl", "writexl", "ggsci", "ragg")',
        "missing_pkgs <- setdiff(required_pkgs, rownames(installed.packages()))",
        'if (length(missing_pkgs) > 0) install.packages(missing_pkgs)',
        "",
        'scripts <- list.files("code", pattern = "^[0-9]{2}_.*\\\\.R$", full.names = TRUE) |> sort()',
        "set.seed(123)",
        'for (s in scripts) { cat("执行：", s, "\\n"); source(s, encoding = "UTF-8") }',
        'writeLines(capture.output(sessionInfo()), "sessionInfo.txt")',
        'cat("\\n全部分析已复现；表格见 tables/，图件见 figures/\\n")'),
      file.path(pack, "run_all.R"), useBytes = TRUE
    )

    writeLines(
      c(sprintf("# %s", pack_name),
        "",
        "交付包骨架已就绪。文件清单见 `00_客户说明.md`。"),
      file.path(pack, "README.md"), useBytes = TRUE
    )
  }

  # Git ---------------------------------------------------
  if (git) {
    old <- setwd(proj)
    on.exit(setwd(old))
    try(system2("git", c("init", "--quiet")), silent = TRUE)
    try(system2("git", c("add", ".")), silent = TRUE)
    try(system2("git",
                c("commit", "-m", "chore: init project skeleton", "--quiet")),
        silent = TRUE)
  }

  # 完成报告 ----------------------------------------------
  message("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  message("项目 [", name, "] 创建成功")
  message("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
  message("路径：", normalizePath(proj))
  message("类型：", type_name, "  |  模式：", mode)
  message("")
  message("下一步：")
  message("  1. 把原始数据放入 ", file.path(name, "01_data/rawdata/"))
  message("  2. 填写 ", file.path(name, "01_data/README.md"), "（数据字典）")
  message("  3. 锁口径：打开 ", file.path(name, "CLAUDE.md"))
  message("  4. 开始清洗：", file.path(name, "02_code/01_data_cleaning.R"))

  invisible(proj)
}
