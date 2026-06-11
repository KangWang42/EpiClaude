library(tidyverse)
library(ggsci)
library(magrittr)
library(reshape)
library(RColorBrewer)
library(ggalluvial)
### 导入数据

df <- read_tsv("genus.xls") %>% column_to_rownames(var="ID")

### 数据清洗

# 按列求和单独计算每列的相对丰度
df_new <- df %>% mutate_all(~ . / sum(.)) %>% rownames_to_column(var="Genus")

### 整合数据
# 将分组文件与丰度表进行整合
plot <- df_new %>% pivot_longer(-Genus) %>% 
  left_join(.,read_tsv("group.xls"),by=c("name"="sample"))

### 绘制冲积图

ggplot(plot, aes(name, value, alluvium = Genus, stratum = Genus)) +  # 创建绘图对象，设置x轴、y轴、alluvium和stratum变量为name、value、Genus
  geom_alluvium(aes(fill = Genus), alpha = .5, width = 0.6) +  # 添加alluvium图层，设置填充颜色为Genus，透明度为0.5，宽度为0.6
  geom_stratum(aes(fill = Genus), width = 0.6) +  # 添加stratum图层，设置填充颜色为Genus，宽度为0.6
  facet_grid(. ~ group, scales = "free", space = "free_x") +  # 根据group变量进行网格分面，设置自由的x轴和y轴刻度，自由的x轴间距
  labs(x = NULL, y = NULL) +  # 设置x轴标签和y轴标签为空
  scale_fill_simpsons() +  # 设置填充颜色的比例尺为Simpsons风格
  scale_y_continuous(expand = c(0, 0)) +  # 设置y轴刻度范围的扩展为0
  scale_x_discrete(expand = c(0, 0)) +  # 设置x轴刻度范围的扩展为0
  theme(
    axis.line.x = element_line(color = "black"),  # 设置x轴线的颜色为黑色
    axis.line.y = element_line(color = "black"),  # 设置y轴线的颜色为黑色
    axis.text.x = element_text(size = 8,face = "plain",angle = 0,
                               vjust = 0.5,hjust = 0.5,color = "black"),  # 设置x轴文本的大小、样式、角度、垂直和水平对齐方式，颜色为黑色
    axis.text.y = element_text(size = 8, face = "plain", color = "black"),  # 设置y轴文本的大小、样式，颜色为黑色
    panel.border = element_blank(),  # 设置面板边框为空白
    plot.background = element_blank(),  # 设置绘图区背景为空白
    axis.title.x = element_text(margin = margin(t = 10), size = 11, color = "black"),  # 设置x轴标题的边距、大小，颜色为黑色
    axis.title.y = element_text(margin = margin(r = 10), size = 11, color = "black"),  # 设置y轴标题的边距、大小，颜色为黑色
    panel.grid.major.x = element_blank(),  # 设置x轴主要网格线为空白
    panel.grid.minor.x = element_blank(),  # 设置x轴次要网格线为空白
    panel.grid.minor.y = element_blank(),  # 设置y轴次要网格线为空白
    panel.grid.major.y = element_blank(),  # 设置y轴主要网格线为空白
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = "cm"),  # 设置绘图区边距为0.5厘米
    legend.text = element_text(size = 8, color = "black"),  # 设置图例文本的大小和颜色
    legend.key = element_blank(),  # 设置图例键为空白
    legend.title = element_blank(),  # 设置图例标题为空白
    panel.background = element_rect(fill = "white"),  # 设置面板背景为白色
    legend.background = element_rect(color = "black",fill = "transparent",
                                     size = 2,linetype = "blank"),  # 设置图例背景的边框颜色为黑色，填充为透明，边框大小为2，线型为空白
    panel.spacing.x = unit(0.1, "cm"),  # 设置面板x轴间距为0.1厘米
    strip.background = element_blank(),  # 设置分面标签背景为空白
    strip.text = element_text(color = "black", face = "bold"),  # 设置分面标签文本的颜色为黑色，样式为粗体
    legend.key.height = unit(0.5, "cm"),  # 设置图例键的高度为0.5厘米
    legend.key.width = unit(0.5, "cm"),  # 设置图例键的宽度为0.5厘米
    legend.spacing.x = unit(0.1, "cm"),  # 设置图例水平间距为0.1厘米
    legend.box.background = element_blank()  # 设置图例框背景为空白
  )

### 绘制组间冲积图

plot %>% select(1,3,4) %>% 
  group_by(Genus,group) %>% 
  summarise(sum=sum(value),.groups = 'drop') %>% 
  pivot_wider(names_from=group,values_from=sum) %>% 
  column_to_rownames(var="Genus") %>% 
  mutate_all(~ . / sum(.)) %>% 
  rownames_to_column(var="Genus") %>% 
  pivot_longer(-Genus) %>% 
  ggplot(aes(name,value,alluvium=Genus,stratum = Genus))+
  geom_alluvium(aes(fill = Genus),alpha = .5,width = 0.6) +
  geom_stratum(aes(fill = Genus),width = 0.6)+
  labs(x=NULL,y=NULL)+
  scale_fill_simpsons()+
  scale_y_continuous(expand=c(0,0))+
  scale_x_discrete(expand=c(0,0))+
  theme(axis.line.x = element_line(color="black"), 
        axis.line.y = element_line(color="black"),
        axis.text.x = element_text(size=8,face="plain",angle = 90,vjust=0.5,color="black"),
        axis.text.y = element_text(size=8,face="plain",color="black"),
        panel.border = element_blank(),
        plot.background = element_blank(),
        axis.title.x = element_text(margin = margin(t = 10),size=11,color="black"),
        axis.title.y = element_text(margin = margin(r = 10),size=11,color="black"),
        panel.grid.major.x = element_blank(),                                          
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),  
        plot.margin = unit(c(0.5,0.5,0.5,0.5), units = ,"cm"),
        legend.text = element_text(size =8,color="black"),
        legend.key = element_blank(),
        legend.title = element_blank(),
        panel.background = element_rect(fill = "white"),
        legend.background = element_rect(color = "black", 
                                         fill = "transparent",size = 2, linetype = "blank"),
        panel.spacing.x = unit(0,"cm"),
        strip.background = element_blank(),
        strip.text = element_text(color="black",face="bold"),
        legend.key.height = unit(0.5,"cm"),
        legend.key.width = unit(0.5,"cm"),
        legend.spacing.x = unit(0.2,"cm"),
        legend.box.background = element_blank())
