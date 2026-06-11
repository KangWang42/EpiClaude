library(tidyverse)
library(janitor)
library(ggtext)
library(igraph)
library(ggraph)
library(ggsci)

data <- readr::read_csv("data.txt")


source("process_data.R")
source("create_edge_vertex_list.R")
processed_data <- process_data(data)

# 创建边、点文件
edge_vertex_list <- create_edge_vertex_list(processed_data)

# 提取边列表和顶点列表
edge_list <- edge_vertex_list$edge_list
vertices <- edge_vertex_list$vertices

dendro <- graph_from_data_frame(edge_list, vertices = vertices)

dendro %>% 
  ggraph(layout = 'dendrogram', circular = TRUE) + 
  geom_edge_diagonal2(color = "#BDBDBD")+
  geom_node_point(aes(filter = leaf, color = group))+
  geom_node_text(aes(x = x * 1.15, y = y * 1.15, filter = leaf, 
                     angle = -((-node_angle(x, y) + 90)%%180) + 90, 
                     label = name,color=group), 
                 hjust = "outward", size = 2.25)+
  scale_x_continuous(limits = c(-2,2)) +
  scale_y_continuous(limits = c(-2,2)) +
  scale_color_jama()+
  coord_equal(clip = "off") +
  theme_void() + 
  theme(legend.position = "none",
        plot.margin = unit(c(0.5, 0.5, 0.5,0.5), "cm"),
        plot.background = element_rect(color = NA, fill = "#FFFFFF"),
        axis.text = element_blank())
#--------------------------------------------------------------------------------
data <- read.csv("data.txt")

df <- data %>% 
  clean_names() %>% 
  count(taxonomic_group, common_name, nc_status) %>% 
  ungroup() %>% group_by(nc_status)


edge_list1 <- df %>% # 创建边列表1
  
  select(taxonomic_group, nc_status) %>%   # 选择taxonomic_group和nc_status列
  unique() %>% 
  
  rename(from = taxonomic_group, to = nc_status) %>%    # 重命名列名
  
  mutate(color = to)   # 添加颜色列

# 创建边列表2
edge_list2 <- df %>% 
  select(nc_status, common_name) %>% 
  unique() %>% 
  rename(from = nc_status, to = common_name) %>% 
  mutate(color = from)

edge_list <- rbind(edge_list1, edge_list2) # 合并边文件


vertices <- data.frame(
  name = unique(c(as.character(edge_list$from), as.character(edge_list$to))),    # 将from和to列中的唯一值作为name列
  # 为value列随机生成值
  value = runif(length(unique(c(as.character(edge_list$from), 
                                as.character(edge_list$to))))))

# 将group列设置为from列匹配to和color列后的结果，如果未找到匹配项，则将其替换为"none"
vertices$group = edge_list$from[match(vertices$name, edge_list$to, edge_list$color)] %>% 
  replace_na("none")

dendro <- graph_from_data_frame(edge_list, vertices = vertices)

dendro %>% 
  ggraph(layout = 'dendrogram', circular = TRUE) + 
  geom_edge_diagonal2(color = "#BDBDBD") +   # 添加对角线边
  geom_node_point(aes(filter = leaf, color = group)) +   # 添加节点点
  geom_node_text(aes(x = x * 1.15, y = y * 1.15, filter = leaf,    # 添加节点文本
                     angle = -((-node_angle(x, y) + 90)%%180) + 90, 
                     label = name,color=group), 
                 hjust = "outward", size = 2.25) +
  scale_x_continuous(limits = c(-2,2)) +
  scale_y_continuous(limits = c(-2,2)) +
  scale_color_jama()+
  coord_equal(clip = "off") +
  theme_void() + 
  theme(legend.position = "none",
        plot.margin = unit(c(0.5, 0.5, 0.5,0.5), "cm"),
        plot.background = element_rect(color = NA, fill = "#FFFFFF"),
        axis.text = element_blank())


