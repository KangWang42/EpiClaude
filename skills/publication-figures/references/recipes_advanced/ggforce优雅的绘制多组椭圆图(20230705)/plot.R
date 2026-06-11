library(tidyverse)  # 加载tidyverse库，包括ggplot2等常用绘图工具
library(ggforce)  # 加载ggforce库，提供额外的绘图功能
library(PrettyCols)  # 加载PrettyCols库，用于创建漂亮的颜色调色板

bg <- "white"  # 设置背景颜色为白色
pal <- prettycols("Dark")  # 创建一个名为"Dark"的漂亮颜色调色板



df <- read_tsv("data.xls")

ggplot() +  # 创建一个ggplot对象
  geom_ellipse(aes(x0 = 0, y0 = 0, a = 5, b = 3, angle = 225),  # 添加椭圆
               fill = pal[1], colour = pal[1],  alpha = 0.5) +  # 设置填充色、边框颜色和透明度
  geom_ellipse(aes(x0 = 6, y0 = 0, a = 5, b = 3, angle = 45),  # 添加椭圆
               fill = pal[2], colour = pal[2], alpha = 0.5) +  # 设置填充色、边框颜色和透明度
  geom_ellipse(aes(x0 = 3, y0 = 5.5, a = 5, b = 3, angle = 0),  # 添加椭圆
               fill = pal[3], colour = pal[3], alpha = 0.5) +  # 设置填充色、边框颜色和透明度
  geom_circle(aes(x0 = 7.5, y0 = -3.5, r = 1.2),  # 添加圆
              fill = pal[4], colour = pal[4], alpha = 0.5) +  # 设置填充色、边框颜色和透明度
  geom_text(data = filter(df, size == 1),  # 添加文本标签，只选择大小为1的数据
            aes(x = x, y = y, label = label_en, angle = angle),  # 设置位置、标签和角度
            colour ="white", size = 10) + # 设置文本颜色为白色，大小为10
  geom_text(data = filter(df, size > 1), # 添加文本标签，只选择大小大于1的数据
            aes(x = x, y = y, label = label_en, angle = angle), # 设置位置、标签和角度
            colour = "white", size = 4) + # 设置文本颜色为白色，大小为4
  guides(size = "none") + # 隐藏size的图例
  coord_equal() + # 设置坐标系相等
  theme_void() # 使用空白主题
