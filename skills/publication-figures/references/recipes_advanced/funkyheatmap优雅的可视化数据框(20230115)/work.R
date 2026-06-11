library(tidyverse)

# install.packages("funkyheatmap")

library(funkyheatmap)


data("dynbenchmark_data")
data <- dynbenchmark_data$data

preview_cols <- c(
  "id",
  "method_source",
  "method_platform",
  "benchmark_overall_norm_correlation",
  "benchmark_overall_norm_featureimp_wcor",
  "benchmark_overall_norm_F1_branches",
  "benchmark_overall_norm_him",
  "benchmark_overall_overall"
)

dynbenchmark_data$column_info 

g <- funky_heatmap(data[,preview_cols])

g
column_info <- dynbenchmark_data$column_info

g <- funky_heatmap(data, column_info = column_info)


column_groups <- dynbenchmark_data$column_groups
row_info <- dynbenchmark_data$row_info
row_groups <- dynbenchmark_data$row_groups
palettes <- dynbenchmark_data$palettes
g <- funky_heatmap(
  data = data,
  column_info = column_info,
  column_groups = column_groups,
  row_info = row_info,
  row_groups = row_groups,
  palettes = palettes,
  col_annot_offset = 3.2
)
ggsave("path_to_plot.pdf", g, device = cairo_pdf, width = g$width, height = g$height)


data <- mtcars %>% 
  rownames_to_column("id") %>%
  arrange(desc(mpg)) %>%
  head(20)

funky_heatmap(data)


column_info <- tribble(
  ~id,     ~group,         ~name,                      ~geom,        ~palette,    ~options,
  "id",    NA,             "",                         "text",       NA,          list(hjust = 0, width = 6),
  "mpg",   "overall",      "Miles / gallon",           "bar",        "palette1",  list(width = 4, legend = FALSE),
  "cyl",   "overall",      "Number of cylinders",      "bar",        "palette2",  list(width = 4, legend = FALSE),
  "disp",  "group1",       "Displacement (cu.in.)",    "funkyrect",  "palette1",  lst(),
  "hp",    "group1",       "Gross horsepower",         "funkyrect",  "palette1",  lst(),
  "drat",  "group1",       "Rear axle ratio",          "funkyrect",  "palette1",  lst(),
  "wt",    "group1",       "Weight (1000 lbs)",        "funkyrect",  "palette1",  lst(),
  "qsec",  "group2",       "1/4 mile time",            "circle",     "palette2",  lst(),
  "vs",    "group2",       "Engine",                   "circle",     "palette2",  lst(),
  "am",    "group2",       "Transmission",             "circle",     "palette2",  lst(),
  "gear",  "group2",       "# Forward gears",          "circle",     "palette2",  lst(),
  "carb",  "group2",       "# Carburetors",            "circle",     "palette2",  lst()
)

column_groups <- tribble( # tribble_start
  ~Category,  ~group,         ~palette,
  "Overall",  "overall",      "overall",
  "Group 1",  "group1",       "palette1",
  "Group 2",  "group2",       "palette2"
) # tribble_end

row_info <- data %>% transmute(id, group = "test")
row_groups <- tibble(Group = "Test", group = "test")

palettes <- tribble(
  ~palette,             ~colours,
  "overall",            grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(9, "Greys")[-1]))(101),
  "palette1",           grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(9, "Blues") %>% c("#011636")))(101),
  "palette2",           grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(9, "Reds")[-8:-9]))(101)
)

g <- funky_heatmap(
  data = data,
  column_info = column_info,
  column_groups = column_groups,
  row_info = row_info,
  row_groups = row_groups,
  palettes = palettes,
  expand = list(xmax = 4)
)
g












