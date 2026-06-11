# 载入所需的包
library(tidyverse)
library(ggtext)
library(glue)

# 读入数据文件
df <- read_tsv("data.xls")


# 设定需要突出显示的国家
country <- c("Canada", "Germany",
             "Indonesia", "Australia ", "United Kingdom",
             "Brazil", "Greece","Singapore", "Myanmar")


# 对数据进行预处理
data <- df %>% 
  # 选择1990年和最新年份的数据
  filter(Year == 1995 | Year == max(Year)) %>% 
  # 对同一国家的多年数据进行筛选，确保只有两条数据
  group_by(Entity) %>% 
  filter(n() == 2) %>% 
  # 找出每个国家最大的值出现在哪一年，并确定趋势（增加或减少）
  mutate(max_value_year = which.max(Hours),
         trend = ifelse(max_value_year == 1, "decrease", "increase")) %>% 
  ungroup() %>% 
  # 根据需要突出显示的国家和同一国家两年数据的趋势，给每个国家打上标签
  mutate(highlight = case_when(
    !(Entity %in% country) ~  "other",
    Entity %in% c("Myanmar", "Singapore") ~ "same",
    TRUE ~ trend))

# 使用ggplot2画图
data %>% ggplot(
  aes(factor(Year), Hours, group = Entity, color = highlight)) +
  # 画出线图
  geom_line(
    aes(size = ifelse(highlight == "other", 0.1, 0.7))) +
  # 画出散点图
  geom_point() +
  # 添加标签，使用ggrepel包来避免标签重叠
  ggrepel::geom_text_repel(
    data = . %>% filter(highlight != "other"),
    aes(
      x = ifelse(Year == min(Year), 1 - 0.5, 2 + 0.5),
      label = glue::glue("{Entity} ({scales::number(Hours, accuracy = 1)})"),
      hjust = ifelse(Year == min(Year),1,0)), 
    size = 2.5, nudge_x =0, direction = "y",
    segment.size = 0) +
  # 调整x轴的位置和大小
  scale_x_discrete(position = "top") +
  scale_size_identity() +
  # 设置坐标系的范围
  coord_cartesian(clip = "off") +
  # 设定颜色
  scale_color_manual(
    values = c(
      "other" = "grey", 
      "decrease" = "#205FA7", 
      "increase" = "#E9972A", 
      "same" = colorspace::darken("#46732EFF"))) +
  # 不显示颜色标尺
  guides(col = "none") +
  # 设定主题
  theme_minimal(base_size = 8) +
  theme (
    plot.background = element_rect(color = NA, fill = "white"),
    panel.grid = element_blank(),
    panel.grid.major.x = element_line(color = "#ECEEF2", size = 10),
    axis.title = element_blank(),
    axis.text.x = element_text(size = 12, face = "bold", color = "grey38"),
    axis.text.y = element_blank(),
    plot.margin = margin(t = 6, l = 16, r = 16, b = 4))

