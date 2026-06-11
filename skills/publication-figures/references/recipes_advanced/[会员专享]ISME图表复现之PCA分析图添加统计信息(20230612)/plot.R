library(tidyverse)
library(ggrepel)
library(FactoMineR)
library(magrittr)
library(factoextra)
library(RColorBrewer)


df <- read_tsv("data.xls")

pca <- df %>% column_to_rownames(var="Sample_id") %>% 
  select(-Subtype) %>% prcomp(.,scale. = TRUE)

var_explained <- pca$sdev^2/sum(pca$sdev^2)

p1 <- fviz_pca_biplot(pca, axes = c(1, 2),geom.ind = c("point"),geom.var = c("arrow", "text"),
                pointshape = 20,pointsize=4,label ="var",repel = TRUE,col.var = "black",
                labelsize=0.5,addEllipses=TRUE, ellipse.level=0.95,
                col.ind = df$Subtype)+
  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Paired"))(4))+
  labs(x=paste0("(PC1: ",round(var_explained[1]*100,2),"%)"),
       y=paste0("(PC2: ",round(var_explained[2]*100,2),"%)"))+
  theme(panel.background = element_rect(fill = 'white', colour = 'black'),
        axis.title.x = element_text(colour="black",size = 12,margin = margin(t=12)),
        axis.title.y = element_text(colour="black",size = 12,margin = margin(r=12)),
        axis.text=element_text(color="black"),
        plot.title = element_blank(),
        legend.title = element_blank(),
        legend.key=element_blank(),   # 图例键为空
        legend.text = element_text(color="black",size=9), # 定义图例文本
        legend.spacing.x=unit(0.06,'cm'), # 定义文本书平距离
        legend.key.width=unit(0.01,'cm'), # 定义图例水平大小
        legend.key.height=unit(0.01,'cm'), # 定义图例垂直大小
        legend.background=element_blank(), # 设置背景为空
        legend.position=c(1,0),legend.justification=c(1,0))


df <- df %>% select(-Sample_id) %>% pivot_longer(-Subtype) %>% select(-name)

# 按照分组计算方差分析
result <- aov(value ~ Subtype, data = df)

anova_results <- summary(result)[[1]]
f_values <- anova_results$"F value"
p_values <- anova_results$"Pr(>F)"

# 创建包含分组、F值和P值的数据框
group_stats <- data.frame(Group = unique(df$Subtype),
                          F_value = f_values,
                          P_value = p_values)

library(ggh4x)

group_stats %>% pivot_longer(-Group) %>% 
  rownames_to_column(var="n") %>% 
  mutate(values=0) %>% 
  mutate(value=round(value,digits = 2)) %>% 
  
  ggplot(aes(n,values))+
  geom_bar(position = "fill",stat="identity")+
  facet_nested(.~Group+name+value,drop=T,scale="free",space="free")+
  labs(x=NULL, y=NULL)+
  scale_y_continuous(expand = c(0,0))+
  theme(
    strip.background = element_rect(fill="white",color="black"),
    panel.spacing = unit(0,"lines"),
    panel.border = element_blank(),
    strip.text.x = element_text(size=7,color="black",face="bold"),
    axis.text.y=element_text(size=8,color="black"),
    axis.title.y = element_text(size=10,color="black"),
    axis.ticks.x = element_blank(),
    axis.text.x=element_text(color="white"),
    panel.grid.major=element_blank(),
    panel.grid.minor=element_blank(),
    panel.background = element_blank(),
    plot.margin = unit(c(-10,1,0,0.5),"cm"))


library(cowplot)

ggdraw()+
  draw_plot(plot,x=0.06,y=0.05,scale=0.775)+
  draw_plot(p1,x=0,y=-0.1,scale=0.8)



