library(tidyverse)
library(xlsx)
library(janitor)
library(ggpattern)
library(shadowtext)
library(camcorder)

# 从Excel文件中读取数据，sheetIndex为工作表索引，startRow和endRow指定读取的行范围
tc_n <- read.xlsx("data.xls",sheetIndex = 1, startRow = 1, endRow = 2) %>% 
  clean_names() %>%  # 将列名转换为小写字母并用下划线代替空格
  select(-ar) %>%    # 删除名为“ar”的列
  mutate(across(everything(), as.character)) %>%  # 将所有列转换为字符型
  pivot_longer(everything(), names_to = "year", values_to = "n")  # 将数据从宽格式转换为长格式，年份作为新的列名，n为新的值列名

# 从Excel文件中读取数据，进行与上述代码相同的数据清洗和整理，读取的行范围为1到4行，然后只选择第3行
tc_ci <- read.xlsx("data.xls",sheetIndex = 1, startRow = 1, endRow = 4) %>% 
  clean_names() %>% 
  filter(row_number() == 3) %>% 
  select(-ar) %>% 
  mutate(across(everything(), as.character)) %>% 
  pivot_longer(everything(), names_to = "year", values_to = "ci")

# 对两个数据集进行左连接，将ci列分成两列low_ci和high_ci，同时将所有列转换为数字型
tc <- left_join(tc_n, tc_ci) %>% 
  separate(ci, into = c("low_ci", "high_ci")) %>% 
  mutate(across(everything(), parse_number))



# 设置颜色变量
col = "mediumpurple2"
  
ggplot(tc)+
  
  geom_col(aes(x = year, y = n), fill = col, width = 0.7)+   # 绘制柱状图
  # 绘制95%置信区间的图案矩形
  geom_rect_pattern(aes(xmin = year - 0.35, xmax = year + 0.35, ymin = low_ci, ymax = high_ci),
                    fill = NA, pattern_fill = colorspace::lighten(col, 0.3), pattern_color = NA,
                    pattern_spacing = 0.0075, pattern_density = 0.4) +
  # 添加特殊的图案
  geom_tile_pattern(aes(2017, 0, pattern_fill = "whatever"), width = 0, height = 0, fill = NA, pattern_color = NA,
                    pattern_spacing = 0.0075, pattern_density = 0.4) + 
  # 添加带阴影效果的文本标签
  geom_shadowtext(aes(x = year, y = n, label = n), nudge_y = -1.5,fontface = "bold",size = 3,
                  color = colorspace::lighten(col, 0.9), bg.colour = colorspace::darken(col, 0.9),
                  bg.r = 0.07, hjust = 1) +
  geom_text(aes(x = year, y = -2, label = year), hjust = 1,size =3) +   # 添加年份标签
  scale_x_reverse() +   # 翻转坐标轴
  scale_y_continuous(limits = c(-5, 100)) +   # 设置y轴范围
  # 设置图案颜色
  scale_pattern_fill_manual(values = colorspace::lighten(col, 0.3),
                            label = "95% 置信区间", name = NULL) +
  coord_flip() +  # 设置坐标轴翻转后的主题
  theme_void() + #  清空主题
  theme(
    legend.position = "top", # 图例位置
    legend.text = element_text(size=8,color="black"), # 图例文本样式
    plot.background = element_rect(fill = "grey97", color = NA), # 图形背景
    plot.margin = margin(5,0,0,5)) # 图形边距


