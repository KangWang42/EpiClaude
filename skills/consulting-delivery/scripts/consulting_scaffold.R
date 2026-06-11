# ============================================================
# consulting_scaffold.R
# 一键创建统计咨询交付包的骨架
# ============================================================

create_delivery_pack <- function(name, root = "05_reports", overwrite = FALSE) {
  if (!grepl("^结果-\\d+-\\d+", name)) {
    warning("建议命名为 '结果-M-D[-主题]' 格式，例如 '结果-4-20-训练测试集'")
  }

  pack <- file.path(root, name)

  if (dir.exists(pack) && !overwrite) {
    stop("目录已存在：", pack, "；如需覆盖请 overwrite = TRUE")
  }

  subdirs <- c("data", "code", "06_results", "tables", "figures")
  invisible(lapply(
    file.path(pack, subdirs),
    dir.create, recursive = TRUE, showWarnings = FALSE
  ))

  # 写占位文件
  writeLines(
    c("# [包名]",
      "",
      "## 这份文件夹是什么",
      "",
      "[一句话说明]",
      "",
      "## 怎么看结果",
      "- 想看**方法和结论** → 打开 `01_方法与结果.docx`",
      "- 想看**具体数字** → 打开 `tables/` 里的 Excel 文件",
      "- 想看**图** → 打开 `figures/` 里的 PDF",
      "",
      "## 怎么重现结果",
      "1. 安装 R ≥ 4.2（推荐 RStudio）",
      "2. 双击打开 `run_all.R`",
      "3. 菜单栏：Session → Set Working Directory → To Source File Location",
      "4. Ctrl+Shift+Enter 运行全文",
      "",
      "## 文件清单",
      "| 路径 | 作用 |",
      "|------|------|",
      "| `data/` | 分析用数据 |",
      "| `code/` | R 脚本（编号顺序执行）|",
      "| `tables/` | 所有表格 |",
      "| `figures/` | 所有图件 |",
      "| `06_results/` | 中间产物 |",
      "| `sessionInfo.txt` | 运行环境 |"),
    con = file.path(pack, "00_客户说明.md"),
    useBytes = TRUE
  )

  # run_all.R 模板
  run_all <- c(
    "# ============================================================",
    paste0("# ", name, " · 一键复现脚本"),
    "# 使用方法：",
    "#   1. 在 RStudio 打开本文件",
    "#   2. Session → Set Working Directory → To Source File Location",
    "#   3. Ctrl+Shift+Enter 运行全文",
    "# ============================================================",
    "",
    'if (!file.exists("run_all.R")) {',
    '  stop("工作目录不对。请 Set Working Directory → To Source File Location")',
    "}",
    "",
    'if (getRversion() < "4.2.0") warning("建议使用 R >= 4.2.0")',
    "",
    "required_pkgs <- c(",
    '  "tidyverse", "readxl", "writexl",',
    '  "survival", "survminer", "broom",',
    '  "gtsummary", "flextable",',
    '  "ggsci", "ragg"',
    ")",
    "missing_pkgs <- setdiff(required_pkgs, rownames(installed.packages()))",
    "if (length(missing_pkgs) > 0) {",
    '  message("缺少依赖：", paste(missing_pkgs, collapse = ", "))',
    '  install.packages(missing_pkgs, repos = "https://cloud.r-project.org")',
    "}",
    "",
    'scripts <- list.files("code", pattern = "^[0-9]{2}_.*\\\\.R$", full.names = TRUE) |> sort()',
    "",
    "set.seed(123)",
    "for (s in scripts) {",
    '  cat("\\n执行：", s, "\\n")',
    "  t0 <- Sys.time()",
    '  source(s, encoding = "UTF-8", echo = FALSE)',
    '  cat("完成（", round(difftime(Sys.time(), t0, units = "secs"), 1), " 秒）\\n")',
    "}",
    "",
    'writeLines(capture.output(sessionInfo()), "sessionInfo.txt")',
    'cat("\\n全部分析已复现完成；表格见 tables/，图件见 figures/\\n")'
  )
  writeLines(run_all, file.path(pack, "run_all.R"), useBytes = TRUE)

  # README
  writeLines(
    c(paste0("# ", name),
      "",
      "本交付包的文件清单见 `00_客户说明.md`。",
      "",
      "复现方法：打开 `run_all.R` 并运行。"),
    file.path(pack, "README.md"),
    useBytes = TRUE
  )

  message("交付包骨架已建：", pack)
  message("  下一步：把数据放入 data/、脚本放入 code/、填 00_客户说明.md")
  invisible(pack)
}

# 复现自检函数：实测 run_all.R 能否在独立 session 跑通
verify_reproducibility <- function(pack_path) {
  stopifnot(dir.exists(pack_path))

  run_all <- file.path(pack_path, "run_all.R")
  if (!file.exists(run_all)) stop("缺 run_all.R")

  message("在独立 R session 中测试复现...")
  cmd <- sprintf('Rscript --vanilla -e "setwd(\\"%s\\"); source(\\"run_all.R\\")"',
                 normalizePath(pack_path, winslash = "/"))
  status <- system(cmd)

  if (status != 0) {
    stop("复现失败；状态码 ", status,
         "；请检查路径硬编码、依赖包、脚本顺序")
  }

  expected <- c("sessionInfo.txt")
  missing <- expected[!file.exists(file.path(pack_path, expected))]
  if (length(missing) > 0) {
    warning("缺少预期输出：", paste(missing, collapse = ", "))
  }

  message("复现通过")
  invisible(TRUE)
}
