
library(tidyverse)
library(igraph)
library(ggraph)
library(widyr)

# 从文件中读取数据
loadouts <- readr::read_csv('loadouts.txt')

df <- loadouts %>%
  pairwise_count(item, name, sort = TRUE, upper = FALSE) %>%   # 计算配备物品之间的成对计数
  graph_from_data_frame()

df %>% ggraph(layout = "fr") +    # 用力导向布局算法构建图形
  geom_edge_link(aes(edge_alpha = n, edge_width = n), edge_colour = "#205FA7") +  # 添加边，设置透明度、宽度和颜色
  # 添加节点，设置大小、形状和颜色
  geom_node_point(size = 4, shape = 21, color = 'grey20') +
  # 添加节点文本，设置自动避让和字体大小
  geom_node_text(aes(label = name), repel = TRUE, size = 3) +

  theme_void() +   # 设置背景为透明
  # 设置主题，包括文本大小、颜色、背景颜色等
  theme(text = element_text(size = 10, color = 'grey20'),
        plot.background = element_rect(fill = '#edede9'),
        legend.position = 'none',
        panel.grid = element_blank(),
        plot.margin = margin(5, 5, 5, 5))

