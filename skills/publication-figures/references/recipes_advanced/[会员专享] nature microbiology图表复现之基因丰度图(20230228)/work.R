library(tidyverse)
library(readxl)
library(ggtree)
library(cowplot)
library(patchwork)
library(ggh4x)
library(magrittr)
library(ggsci)
library(ggplotify)
library(grid)

# 导入数据
df <- read_excel("41564_2023_1322_MOESM5_ESM.xlsx",sheet = 1) %>% 
  select(`Sample Name`,`Metabolic pathway`,`Capped copies per organism`) %>% 
  pivot_wider(.,names_from = `Sample Name`,
              values_from = `Capped copies per organism`)

# 如果此处根据ggtree绘制聚类树结果不一致，请降低ggtree的版本

# 绘制聚类树用于后面调整Y轴顺序
tree <- hclust(dist(df %>% column_to_rownames(var="Metabolic pathway"))) %>% 
  ggtree(layout="rectangular", branch.length="none")

# 绘制热图
p1 <- read_excel("41564_2023_1322_MOESM5_ESM.xlsx",sheet = 1) %>% 
  ggplot(aes(`Sample Name`, `Metabolic pathway`,fill= `Capped copies per organism`))+
  geom_tile()+
  facet_grid(.~`Data source`,scale="free")+
  labs(x=NULL,y=NULL)+
  scale_y_discrete(expand = c(0,0),limits = get_taxa_name(tree))+
  scale_x_discrete(expand = c(0,0))+
  theme(axis.text.x = element_blank(),
        axis.text.y=element_text(color="black"),
        axis.ticks = element_blank(),
        panel.spacing = unit(0.1,"lines"))+ # 调整分面间距
  force_panelsizes(cols = c(0.3,0.5),respect = TRUE)+ # 调整分面的比例
  scale_color_gradientn(colours = rev((RColorBrewer::brewer.pal(6,"RdBu"))))+
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(6,"RdBu")))

p2 <- read_excel("41564_2023_1322_MOESM5_ESM.xlsx",sheet = 2) %>% 
  mutate(RPKM=log10(`Total RPKM`+1)) %>% 
  ggplot(aes(`Sample Name`, `Metabolic pathway`,fill= RPKM))+
  geom_tile()+
  facet_grid(.~`Data source`,scale="free")+
  labs(x=NULL,y=NULL)+
  scale_y_discrete(expand = c(0,0),limits = get_taxa_name(tree))+
  scale_x_discrete(expand = c(0,0))+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        panel.spacing = unit(0.08,"lines"))+
  scale_color_gradientn(colours = rev((RColorBrewer::brewer.pal(6,"RdBu"))))+
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(6,"RdBu")))

# 绘制条行图
p3 <- read_excel("41564_2023_1322_MOESM5_ESM.xlsx",sheet = 3) %>% select(4,3,5) %>% 
  set_colnames(c("group","value","sample")) %>% 
  mutate(face="Tara Oceans (metagenomes)") %>% 
  bind_rows(.,read_excel("41564_2023_1322_MOESM5_ESM.xlsx",sheet = 4) %>% select(6,4,5) %>% 
              set_colnames(c("group","value","sample")) %>% 
              mutate(face="This study (metagenomes)")) %>% 
  bind_rows(.,read_excel("41564_2023_1322_MOESM5_ESM.xlsx",sheet = 5) %>% select(6,4,5) %>% 
              set_colnames(c("group","value","sample")) %>% 
              mutate(face="Tara Oceans (metatranscriptomes)")) %>% 
  ggplot(aes(sample,value,fill=group))+
  geom_bar(stat="identity",position="fill",width=0.8)+
  facet_grid(.~face,scale="free")+
  labs(x=NULL,y=NULL)+
  scale_y_continuous(expand = c(0,0))+
  scale_x_discrete(expand = c(0,0))+
  theme_test()+
  theme(axis.text.x=element_text(color="black",angle = 45,vjust=1,hjust=1,size=6),
        panel.spacing = unit(0.3,"lines"))+
  force_panelsizes(cols = c(1,1.7,2),respect = TRUE)+
  scale_fill_npg()

# 拼图
(p1+theme(legend.position = "non",plot.margin = margin(0.1,12,10,0,unit="cm"))) %>% 
  ggdraw()+
  draw_plot(p3+theme(legend.position = "non"),scale=0.7,x=0.082,y=-0.318)+
  draw_plot(p2+theme(legend.position = "non"),scale=1,x=0.638,y=0.321,width = 0.2959,height=0.68)+
  draw_plot(ggpubr::get_legend(p3) %>% 
              as.ggplot(),scale=0.05,x=-0.32,y=-0.27)+ # 添加图例
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#55BF93",col="#55BF93",alpha=0.2)), # 添加阴影
            x=0.065,y=0.859,height=0.05,width=0.19)


# 16.34×12.07






