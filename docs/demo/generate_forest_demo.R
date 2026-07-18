#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(forestploter)
  library(grid)
  library(showtext)
  library(sysfonts)
})

script_arg <- grep("^--file=", commandArgs(), value = TRUE)
if (length(script_arg) != 1) {
  stop("请使用 Rscript docs/demo/generate_forest_demo.R 运行本脚本。")
}

script_path <- normalizePath(
  sub("^--file=", "", script_arg[[1]]),
  winslash = "/",
  mustWork = TRUE
)
demo_dir <- dirname(script_path)
input_path <- file.path(demo_dir, "forest-demo-data.csv")
output_dir <- file.path(demo_dir, "output")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

dat <- read.csv(
  input_path,
  fileEncoding = "UTF-8",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

required <- c("subgroup", "n", "estimate", "lower", "upper")
if (!identical(names(dat), required)) {
  stop("演示数据字段必须严格为: ", paste(required, collapse = ", "))
}
if (anyNA(dat) || anyDuplicated(dat$subgroup)) {
  stop("演示数据不得包含缺失值或重复亚组。")
}
if (any(dat$n <= 0) || any(dat$lower <= 0) ||
    any(dat$lower > dat$estimate) || any(dat$estimate > dat$upper)) {
  stop("样本量、效应量或置信区间的数值关系不合法。")
}

font_candidates <- Sys.glob(c(
  "C:/Windows/Fonts/msyh.ttc",
  "C:/Windows/Fonts/simhei.ttf",
  "/System/Library/Fonts/PingFang.ttc",
  "/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc",
  "/usr/share/fonts/opentype/adobe-source-han-sans/SourceHanSansCN-Regular.otf"
))
if (length(font_candidates) == 0) {
  stop("未找到可用的中文字体；脚本不会自动安装或替换系统字体。")
}
font_path <- font_candidates[[1]]
bold_candidates <- Sys.glob(c(
  "C:/Windows/Fonts/msyhbd.ttc",
  "C:/Windows/Fonts/simhei.ttf",
  "/System/Library/Fonts/PingFang.ttc",
  "/usr/share/fonts/opentype/noto/NotoSansCJK-Bold.ttc",
  "/usr/share/fonts/opentype/adobe-source-han-sans/SourceHanSansCN-Bold.otf"
))
bold_path <- if (length(bold_candidates) > 0) bold_candidates[[1]] else font_path
font_add("demo_zh_sans", regular = font_path, bold = bold_path)
plot_family <- "demo_zh_sans"
showtext_auto()
showtext_opts(dpi = 300)

table_data <- data.frame(
  "亚组" = dat$subgroup,
  "样本量" = format(dat$n, big.mark = ",", scientific = FALSE),
  " " = rep(strrep(" ", 22), nrow(dat)),
  "OR（95% CI）" = sprintf(
    "%.2f（%.2f–%.2f）",
    dat$estimate,
    dat$lower,
    dat$upper
  ),
  check.names = FALSE
)

make_theme <- function(base_size) {
  forest_theme(
    base_size = base_size,
    base_family = plot_family,
    ci_pch = 15,
    ci_col = "#0F766E",
    ci_fill = "#0F766E",
    ci_lwd = 1.4,
    refline_gp = gpar(col = "#64748B", lty = "dashed", lwd = 1),
    xaxis_gp = gpar(
      fontsize = base_size - 1,
      fontfamily = plot_family,
      col = "#111827"
    ),
    xlab_gp = gpar(
      fontsize = base_size,
      fontfamily = plot_family,
      col = "#111827"
    ),
    summary_col = "#0F766E",
    summary_fill = "#0F766E"
  )
}

demo_theme <- make_theme(10)

build_plot <- function(data_view, ci_column, plot_theme, tick_values) {
  forest(
    data_view,
    est = dat$estimate,
    lower = dat$lower,
    upper = dat$upper,
    sizes = c(0.55, rep(0.38, nrow(dat) - 1)),
    ci_column = ci_column,
    is_summary = seq_len(nrow(dat)) == 1,
    ref_line = 1,
    x_trans = "log",
    xlim = c(0.45, 1.60),
    ticks_at = tick_values,
    ticks_digits = 2,
    xlab = "比值比及 95% 置信区间",
    theme = plot_theme
  )
}

width_mm <- 160
height_mm <- 78
pdf_path <- file.path(output_dir, "forest-plot.pdf")
png_path <- file.path(output_dir, "forest-plot.png")
mobile_path <- file.path(output_dir, "forest-plot-mobile.png")

cairo_pdf(
  pdf_path,
  width = width_mm / 25.4,
  height = height_mm / 25.4,
  onefile = TRUE
)
showtext_begin()
p <- build_plot(table_data, 3, demo_theme, c(0.50, 1.00, 1.50))
grid.draw(p)
showtext_end()
dev.off()

ragg::agg_png(
  png_path,
  width = width_mm,
  height = height_mm,
  units = "mm",
  res = 300,
  background = "white"
)
p <- build_plot(table_data, 3, demo_theme, c(0.50, 1.00, 1.50))
grid.draw(p)
dev.off()

mobile_data <- data.frame(
  "亚组" = dat$subgroup,
  " " = rep(strrep(" ", 15), nrow(dat)),
  "OR（95% CI）" = table_data[["OR（95% CI）"]],
  check.names = FALSE
)
ragg::agg_png(
  mobile_path,
  width = 100,
  height = 95,
  units = "mm",
  res = 300,
  background = "white"
)
p <- build_plot(mobile_data, 2, make_theme(12), c(0.50, 1.00))
grid.draw(p)
dev.off()

cat("Generated:\n", normalizePath(pdf_path, winslash = "/"), "\n")
cat(normalizePath(png_path, winslash = "/"), "\n")
cat(normalizePath(mobile_path, winslash = "/"), "\n")
