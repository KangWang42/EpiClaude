library(tidyverse)
library(readxl)
library(magrittr)

df <- read_excel("F1.xlsx", sheet = "Fig 1c KEGG module") %>% 
  column_to_rownames(var="...1")

df2 <- df %>% rownames_to_column(var="ID") %>% head(20) %>% select(1:13) %>%  
  pivot_longer(-1) %>% set_colnames(c("ID","name","value"))

p1 <- df2 %>% filter(name %in% c("J043V6","J035V8","J009V6")) %>% 
  mutate(p_value=case_when(value <0 ~ "**")) %>% drop_na() %>% 
  mutate(group=case_when(value < -0.5 ~ "latter",
                         TRUE ~ "former"))

ggplot()+ 
  geom_tile(data=p1,aes(ID,name,fill=group))+
  geom_text(data=p1,aes(ID,name,label=p_value),
            color="white",vjust=1,size=5,hjust=0.5)+
  geom_point(data=df2 %>% 
               filter(name %in% c("C422V8","C402V8","C220V8","1107V4","1075V6","1055V4")),
            aes(ID,name,color=value,size=value))+
  coord_cartesian(clip = "off") +  # 关闭坐标轴裁剪
  labs(x=NULL,y=NULL)+  # 移除x和y轴标签
  scale_x_discrete(expand=c(0,0))+  # 设置x轴
  scale_fill_manual(values=c("#E6956F","#788FCE"))+
  scale_color_gradient2(mid="#FBFEF9",low="#0C6291",high="#A63446") +  # 设置填充颜色
  theme_test()+  # 使用theme_test主题
  theme(axis.text.x=element_text(color="black",size=8,face="bold",angle = 90,vjust=0.5),  # 自定义x轴文本
        axis.text.y=element_text(color="black",size=8,face="bold",angle = 0,vjust=0.5),  # 自定义y轴文本
        axis.ticks = element_blank(),  # 移除轴刻度
        legend.title = element_blank(),  # 移除图例标题
        legend.background = element_blank(),  # 设置图例背景为透明
        legend.text = element_text(size=8,color="black",face="bold"),  # 自定义图例文本
        legend.position ="right",  # 设置图例位置
        legend.spacing.x = unit(0.05,"in"),  # 设置图例内部的水平间距
        plot.margin = ggplot2::margin(10,30,10,10),
        legend.direction = "vertical",
        legend.box = "horizontal") 
