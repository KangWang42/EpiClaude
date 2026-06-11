
library(tidyverse)  
library(plotly)     
library(glue)
# 读入原始数据
df2 <- read_tsv("genus_tax.xls")

# 将数据变为长格式
genus <- df2 %>% 
  pivot_longer(-genus) %>%   # 对除'genus'列以外的所有列进行展开
  select(2, 1, 3) %>%       # 调整列顺序
  set_colnames(c("sample", "genus", "value"))  # 重命名列

# 按照样品和属的组合对物种进行聚合，计算总和，并按总和进行排序
genus_data <- genus %>%
  group_by(sample, genus) %>%
  summarize(total = sum(value, na.rm = TRUE)) %>%
  arrange(desc(total)) %>%
  ungroup()

# 按照样品对总和进行聚合
genus_samples <- genus_data %>%
  group_by(sample) %>%
  summarize(values = sum(total))

# 按照样品和属对总和进行聚合，并计算唯一的标识符
genus_tax <- genus_data %>%
  group_by(sample, genus) %>%
  summarize(values = sum(total)) %>%
  mutate(id = paste(sample, genus))

# 创建用于可视化的向量
genus_labels = c(glue('Genus'), genus_samples$sample, genus_tax$genus)
genus_ids = c(glue('Genus'),genus_samples$sample, genus_tax$id)
genus_parents = c("", replicate(length(genus_samples$sample),"Genus"), genus_tax$sample)
genus_values = c(sum(genus_samples$values), genus_samples$values, genus_tax$values)

# 创建交互式旭日图
plot_ly(labels = genus_labels,ids = genus_ids,parents = genus_parents,
        values = genus_values,type = 'sunburst',branchvalues = 'total',
        sort = TRUE) %>% 
  layout(font = list(size =10,color = "black"))

