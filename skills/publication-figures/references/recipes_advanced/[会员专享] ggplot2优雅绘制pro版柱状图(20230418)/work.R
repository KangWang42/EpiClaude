library(tidyverse)
library(ggforce)
library(janitor)
library(data.table)
library(patchwork)

# 设置ggplot2主题为最小化风格
theme_set(theme_minimal())

# 更新图表背景和其他视觉元素的样式
theme_update(
  plot.background = element_rect(fill = "#DBCECA", colour = "#DBCECA"), # 绘图区域的背景颜色和边框颜色
  panel.grid.major.x = element_blank(),  # x轴主要网格线不可见
  panel.grid.minor.x = element_blank(),  # x轴次要网格线不可见
  panel.grid.minor.y = element_blank(),  # y轴次要网格线不可见
  axis.text.x = element_blank(),  # x轴刻度标签不可见
  plot.margin = margin(b = 10, t = 10, r = 10, l = 10)  # 绘图区域的边距
)

# 读取数据，清理数据并计算寒冷和温暖的时间段
db_raw <-read_delim("etmgeg_260.txt", delim = ",", skip = 50) %>%
  clean_names()  # 将列名转换为小写并去除空格

cold_streaks <- db_raw %>% select(date = yyyymmdd,temp = tg) %>%  # 选择日期和温度两列
  mutate(date = lubridate::ymd(date),  # 将日期格式化为日期类型
         temp = parse_number(temp),  # 从字符串中解析温度值
         temp = temp / 10,  # 将温度值转换为摄氏度
         decade = glue::glue("{year(date) %/% 10}0's"),  # 根据日期计算年代
         freezing = temp < -5 ) %>%  # 判断是否处于寒冷状态
  group_by(decade, freezing, streak = rleid(freezing)) %>%  # 按年代和冷暖状态以及时间段进行分组
  summarise(streak_length = n(),.groups = "drop") %>%  # 计算时间段长度
  select(-streak) %>%  # 删除时间段列
  group_by(decade, freezing) %>%  # 按年代和冷暖状态分组
  filter(streak_length == max(streak_length) & freezing) %>%  # 选择最长的寒冷时间段
  distinct() %>%  # 去除重复的行
  mutate(type = "Cold streak (< 5 C)")  # 添加列，表示类型

warm_streaks <- db_raw %>% select(date = yyyymmdd,temp = tg) %>%  # 选择日期和温度两列
  mutate(
    date = lubridate::ymd(date),  # 将日期格式化为日期类型
    temp = parse_number(temp),  # 从字符串中解析温度值
    temp = temp / 10,  # 将温度值转换为摄氏度
    decade = glue::glue("{year(date) %/% 10}0's"),  # 根据日期计算年代
    warm = temp > 20 
  ) %>% 
  group_by(decade, warm, streak = rleid(warm)) %>%  # 按年代和冷暖状态以及时间段进行分组
  summarise(streak_length = n(),.groups = "drop") %>%  # 计算时间段长度
  select(-streak) %>%  # 删除时间段列
  group_by(decade, warm) %>%  # 按年代和冷暖状态分组
  filter(streak_length == max(streak_length) & warm) %>%  # 选择最长的温暖时间段
  distinct()%>%  # 去除重复的行
  mutate(type = "Warm streak (> 20 C)")  # 添加列，表示类型

# 计算每个十年的温度范围
plot_data <- db_raw %>% select(date = yyyymmdd,temp = tg) %>%
  mutate(date = lubridate::ymd(date),  # 将日期格式化为日期类型
         temp = parse_number(temp),  # 从字符串中解析温度值
         temp = temp / 10,  # 将温度值转换为摄氏度
         decade = year(date) %/% 10) %>%  # 根据日期计算年代
  group_by(decade) %>%  # 按年代分组
  summarise(min = min(temp),  # 计算温度的最小值
            avg = mean(temp),  # 计算温度的平均值
            max = max(temp),  # 计算温度的最大值
            .groups = "drop") %>%  # 取消分组
  mutate(idx = 0,decade = glue::glue("{decade}0's"))  # 添加列，表示索引和年代

# 创建散点图和折线图，展示每个十年的温度范围和寒冷/温暖的时间段
plot_data %>% 
  ggplot() +  # 创建一个ggplot对象
  geom_circle(aes(x0 = idx, y0 = -20, r = 2),fill = "grey60", colour = "grey60") +  # 创建一个圆
  geom_rect(aes(xmin = idx - 0.8, xmax = idx + 0.8, ymin = -20, ymax = 35),fill = "grey60",colour = "grey60") +  # 创建一个矩形
  geom_link(aes(x = idx, xend = idx,y = min, yend = max,colour = after_stat(y)),size = 3) +  # 创建一条连接最小值和最大值的线
  geom_segment(aes(x = idx - 0.8, xend = idx + 0.8,y = avg, yend = avg)) +  # 创建一条表示平均温度的线段
  facet_wrap(~decade, nrow = 1) +  # 将每个十年的数据绘制在一个单独的面板中
  coord_equal() +  # 将x轴和y轴的单位长度设为相等
  labs(x=NULL,y=NULL)+  # 设置x轴和y
  scale_y_continuous(breaks = seq(from = -20, to = 30, by = 10),  # 设置y轴刻度的位置和间隔
                     labels = scales::label_number(suffix = " C")) +  # 设置y轴刻度的标签和单位
  scale_colour_gradient2(low = "#49868C", mid = "white", high = "red", midpoint = 0) +  # 设置颜色映射的范围和中点
  guides(colour = "none")  # 设置图例，不显示颜色映射

