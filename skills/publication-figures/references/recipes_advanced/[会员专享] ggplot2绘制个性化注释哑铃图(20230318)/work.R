library(tidyverse)
library(ggforce)


df <- read_tsv("data.xls") %>% arrange(desc(line_order))
  
df$line <- factor(df$line,levels = df$line) 
  
df %>% ggplot() +
  geom_link(aes(x = start_year, xend = end_year, y = line_order, yend = line_order), size = 5, 
            lineend = "round", color = "#12618D")+
  geom_point(aes(x = start_year, y = line_order), color = "white", size = 3)+
  geom_text(aes(x = end_year, y = line_order, label = duration), color="white",
            hjust = 1, size =2.5,fontface = "bold") +
  geom_text(aes(x = 2007, y = line_order, label = length_label), hjust = 0.5, size = 3.5)+
  geom_circle(aes(x0 = 2004, y0 = line_order, r = 0.4, fill = cost_km_millions),
              color = NA, show.legend = FALSE) +
  geom_text(aes(x = 2004, y = line_order, label = cost_km_millions, color = color_cost), hjust = 0.5, size = 2.3) +
  geom_text(aes(x = 1999, y = line_order, label = line),hjust = 0, size=3,color="grey60") +
  geom_segment(aes(x = 2007.5, xend = start_year - 0.5, y = line_order, yend = line_order),
               size = 0.25, color = "grey85") +
  geom_segment(aes(x = 2009, xend = 2026, y = 13.75 * 1.1, yend = 13.75 * 1.1), size = 0.25, color = "grey85")+
  annotate("text", x = 2004, y = 14.5 * 1.1, label="Cost per km\n millions",color="#EDB749", 
           hjust = 0.5, size = 3,fontface ="bold",lineheight = 0.9) +
  annotate("text", x = 2007, y = 14.5 * 1.1, label = "Length",color="#9C8D58",
           hjust = 0.5,size = 3, fontface ="bold",lineheight = 0.9 ) +
  annotate("text", x = 2016, y = 14.5 * 1.1, label = "Project Timeline",color="#3CB2EC",
           hjust = 0.5, size =3,fontface ="bold") +
  annotate("label", x = c(2009, 2017, 2026), y = 13.75 * 1.1, label = c(2009, 2017, 2026), size = 2.75, 
    vjust = 0.5, label.size = NA, fontface = "bold", color = "grey65") +
  scale_y_continuous(limits = c(0, 15 *1.1)) +
  scale_color_identity() +
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(6,"RdBu")))+
  coord_equal(clip = "off") +
  theme_void() +
  theme(plot.margin = margin(0,10,0,5),plot.title.position = "plot")



df %>% ggplot() +                            # 用df数据集创建ggplot对象
  geom_link(aes(x = start_year, xend = end_year, y = line_order, yend = line_order), 
            size = 5, lineend = "round", color = "#12618D") +    # 添加连接线
  geom_point(aes(x = start_year, y = line_order), color = "white", size = 3) +    # 添加起点圆圈
  geom_text(aes(x = end_year, y = line_order, label = duration), color = "white", 
            hjust = 1, size = 2.5, fontface = "bold") +    # 添加文字标签
  geom_text(aes(x = 2007, y = line_order, label = length_label), hjust = 0.5, size = 3.5) +    # 添加长度标签
  geom_circle(aes(x0 = 2004, y0 = line_order, r = 0.4, fill = cost_km_millions), 
              color = NA, show.legend = FALSE) +    # 添加圆圈
  geom_text(aes(x = 2004, y = line_order, label = cost_km_millions, color = color_cost), 
            hjust = 0.5, size = 2.3) +    # 添加每公里成本标签
  geom_text(aes(x = 1999, y = line_order, label = line), hjust = 0, size = 3, color = "grey60") +    # 添加灰色线
  geom_segment(aes(x = 2007.5, xend = start_year - 0.5, y = line_order, yend = line_order), 
               size = 0.25, color = "grey85") +    # 添加灰色竖线
  geom_segment(aes(x = 2009, xend = 2026, y = 13.75 * 1.1, yend = 13.75 * 1.1), 
               size = 0.25, color = "grey85") +    # 添加灰色横线
  annotate("text", x = 2004, y = 14.5 * 1.1, label = "Cost per km\n millions", 
           color = "#EDB749", hjust = 0.5, size = 3, fontface = "bold", lineheight = 0.9) +    # 添加标签
  annotate("text", x = 2007, y = 14.5 * 1.1, label = "Length", color = "#9C8D58", 
           hjust = 0.5, size = 3, fontface = "bold", lineheight = 0.9) +    # 添加标签
  annotate("text", x = 2016, y = 14.5 * 1.1, label = "Project Timeline", color = "#3CB2EC", 
           hjust = 0.5, size = 3, fontface = "bold") +    # 添加标签
  annotate("label", x = c(2009, 2017, 2026), y = 13.75 * 1.1, label= c(2009, 2017, 2026), size = 2.75, vjust = 0.5, label.size = NA,
           fontface = "bold", color = "grey65") + # 添加标签
  scale_y_continuous(limits = c(0, 15 *1.1)) + # 设置y轴上下限
  scale_color_identity() + # 设置颜色标识
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(6,"RdBu"))) + # 设置颜色渐变
  coord_equal(clip = "off") + # 设置坐标轴相等
  theme_void() + # 设置无背景主题
  theme(plot.margin = margin(0, 10, 0, 5), plot.title.position = "plot") # 设置图形边距和标题位置
           

