
library(tidyverse) 
library(ggsci)

### 构建数据

set.seed(123)
# 创建一个数据框 df，其中包含 50 行数据。month 列为 1 到 12 之间的随机值，value 列为 0 到 80 之间的随机值，name 列为 A 到 E 中的随机字母，size 列为 1 到 20 之间的随机值。
df <- data.frame(
  month = sample(1:12, 50, replace = TRUE),
  value = sample(0:80, 50, replace = TRUE),
  name = sample(LETTERS[1:5], 50, replace = TRUE),
  size = sample(1:100,50, replace = TRUE)
)


ggplot() +
  # 添加水平网格线段，y 坐标为 0 到 80，线段长度分别为 0.25 和 0.1，透明度为 0.5
  annotate("segment", x = -Inf, xend = Inf, y = seq(0, 80, 10), yend = seq(0, 80, 10),
           size = rep(c(0.25, 0.1),length.out =9), alpha = 0.5) +
  # 添加垂直虚线，x 坐标分别为 1 到 12，线型为虚线，透明度为 0.5
  geom_vline(xintercept = 1:12, linetype = "dashed", alpha = 0.5) +
  # 添加散点图，x 坐标为 month，y 坐标为 value，填充色和边框色为 name，点的大小为 size
  geom_point(data=df,aes(x = month, y = value,fill = name,
                         color=name,size=size),pch=21,alpha=0.8)+
  # 设置 x 轴坐标的范围为 0.5 到 12.5，刻度为 1 到 12，刻度标签为英文月份缩写
  scale_x_continuous(limits = c(0.5, 12.5), breaks = 1:12, labels = month.abb) +
  # 设置 y 轴坐标的范围为 -10 到 90
  scale_y_continuous(limits = c(-10, 90)) +
  # 将坐标系设置为极坐标系
  coord_polar() +
  # 设置填充颜色为 jama 颜色调色板
  scale_fill_jama()+
  # 隐藏图例
  guides(color=F,fill=F)+
  # 设置主题为 minimal
  theme_minimal()+
  # 设置主题的其他参数，如隐藏图例、设置背景颜色等
  theme(legend.title = element_blank(),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_text(color = "black",size=8,face="bold")
  )

