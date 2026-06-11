library(tidyverse)
library(janitor) 
library(MetBrewer)

data <- readr::read_csv("data.csv") # 从"data.csv"文件中读取数据，并将其赋值给data变量

df <- data %>% 
  clean_names() %>% # 将列名转换为小写，并替换掉特殊字符
  filter(year == 2022) %>% # 过滤出年份为2022的数据
  filter(area_name %in% c("Hyde County", "Orange County")) %>% # 过滤出区域名为"Hyde County"和"Orange County"的数据
  select(2:3, 6:8) %>% # 选择第2列到第3列和第6列到第8列的数据
  pivot_longer(!area_name, names_to = "type", values_to = "units") %>% # 对除了area_name列之外的列进行长格式转换，将变量名转换为type列，数值转换为units列
  mutate(type = replace(type, type == "all_hybrids", "hybrid")) %>% # 将type列中的"all_hybrids"替换为"hybrid"
  group_by(area_name, type) %>% # 按照area_name和type进行分组
  summarise(n = sum(units)) %>% # 对units列进行求和，并将结果赋值给n列
  mutate(percent = round(n / sum(n), 5)) %>% # 计算每个组的百分比，并将结果赋值给percent列
  group_by(type) %>% # 按照type进行分组
  mutate(ymax = if_else(type %in% c("gas", "electric"), sqrt(percent), 0), # 根据type的值判断ymax的取值
         xmax = if_else(type %in% c("hybrid", "electric"), sqrt(percent), 0), # 根据type的值判断xmax的取值
         xmin = if_else(type %in% c("gas", "diesel"), -sqrt(percent), 0), # 根据type的值判断xmin的取值
         ymin = if_else(type %in% c("diesel", "hybrid"), -sqrt(percent), 0)) %>% # 根据type的值判断ymin的取值
  mutate(type = str_to_title(type)) %>% # 将type列中的字符串转换为首字母大写的形式
  mutate(area_name = case_when(area_name == "Hyde County" ~ "Hyde County\n(low)", # 根据area_name的值替换为对应的标签
                               area_name == "Orange County" ~ "Orange County\n(high)"))

df$type <- factor(df$type, levels = c("Gas", "Diesel", "Hybrid", "Electric")) # 将type列转换为有序因子，并指定水平顺序为"Gas", "Diesel", "Hybrid", "Electric"

df %>% ggplot() + # 创建一个基础的ggplot对象
  geom_rect(aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = type), color = "#FFFFFF") + 
  # 添加矩形图层，使用xmin、xmax、ymin、ymax定义矩形的位置和大小，fill指定填充颜色，color指定边框颜色
  geom_text(aes(x = ifelse(type %in% c("Gas", "Electric"), xmin + 0.01, xmin + 0.01), 
                y = ifelse(type %in% c("Gas", "Electric"), ymax + 0.05, ymin - 0.05),
                label = scales::percent(percent), color = type),
            size = 2.5, hjust = 0) +
  # 添加文本图层，显示百分比标签，位置由x和y决定，颜色由type指定
  scale_color_manual(values = rev(met.brewer("Kandinsky", 4))) +
  scale_fill_manual(values = rev(met.brewer("Kandinsky", 4))) +
  facet_wrap(~ area_name) +   # 根据area_name进行分面，创建多个子图
  coord_equal(clip ="off") +   # 设置坐标系为相等比例，clip设置为"off"表示绘图区域不被裁剪
  theme_void() +   # 使用空白主题，不显示背景和边框
  theme(strip.text = element_text(size = 9,color = "#000000", hjust = 0.5, margin = margin(b = 1)),
        legend.position = "top",         # 图例位置在顶部
        legend.margin = margin(b = 15),         # 图例的下边距为15
        legend.text = element_text(size = 8,color = "#000000", hjust = 0.5),
        legend.title = element_blank(),        # 不显示图例标题
        plot.margin = unit(c(1,0.25,1,0.25),"cm"),
        plot.background = element_rect(color = NA, fill = "#FFFFFF"))
