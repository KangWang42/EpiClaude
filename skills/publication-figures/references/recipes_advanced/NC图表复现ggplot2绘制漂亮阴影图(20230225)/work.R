library(tidyverse)
library(readxl)
library(ggpattern)
library(ggsci)
library(ggthemes)
library(ggprism)


df <- read.delim("data.xls",check.names = F) %>% 
  pivot_longer(-Nb) %>% left_join(.,read_excel("group.xlsx"),by="name",
                                  multiple = "all") %>% drop_na()
  

df$group <- factor(df$group,levels = df$group %>% unique())

df %>% ggplot(aes(group,value,fill=name),color="black")+
  stat_boxplot(geom="errorbar",position=position_dodge(width=1),
               width=0.2,color="black",size=0.5)+
  geom_boxplot_pattern(aes(fill=name),size=0.2,key_glyph=draw_key_rect,
                       pattern='stripe',
                       pattern_spacing = 0.01,
                       pattern_density=0.01,
                       pattern_angle=45,
                       position=position_dodge(width=1),outlier.shape = NA)+
 
  scale_fill_jco()+
  scale_y_continuous(expand = c(0,0),limits=c(0,100),breaks = seq(0,100,10),
                     guide = "prism_minor")+
  labs(x=NULL,y=NULL)+
  theme(panel.grid.major.y= element_line(linetype=3,color="black"),
        panel.grid.major.x=element_blank(), # 去除X轴主网格
        panel.grid.minor=element_blank(),   # 去除次网格
        panel.background =element_rect(color="grey"),
        axis.text = element_text(color="black",face="bold",size=10),
        axis.line = element_line(color="black",size=0.8),
        axis.ticks = element_line(color="black",size=0.8),
        axis.ticks.x=element_blank(),
        legend.title = element_blank(),
        legend.key.height = unit(0.2,'in'))+
  guides(fill = guide_legend(override.aes = list(alpha = 1),
                             nrow=3, byrow=TRUE), # 图例分三行展示
                             keywidth = unit(5, units = "mm"))
