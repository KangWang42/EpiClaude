library(tidyverse)
install.packages("networkD3")
library(networkD3)


# 读取CSV文件数据
refresults <- read.csv("result-data.csv")

# 按地区分组进行计算
results <- refresults %>%
  group_by(Region) %>%
  summarise(Remain = sum(Remain), Leave = sum(Leave)) %>%
  pivot_longer(-Region, names_to = "result", values_to = "vote")

# 创建节点数据框
regions <- unique(results$Region)
nodes <- data.frame(node = 0:13, name = c(regions, "Leave", "Remain"))

# 合并结果和节点数据框
results <- results %>%
  inner_join(nodes, by = c("Region" = "name")) %>%
  inner_join(nodes, by = c("result" = "name")) %>%
  rename(source = node.x, target = node.y, value = vote)

# 创建链接数据框
links <- results[, c("source", "target", "value")]

# 创建桑基图
sankeyNetwork(Links = links, Nodes = nodes, Source = "source", 
              Target = "target", Value = "value", NodeID = "name",
              units = "votes")
