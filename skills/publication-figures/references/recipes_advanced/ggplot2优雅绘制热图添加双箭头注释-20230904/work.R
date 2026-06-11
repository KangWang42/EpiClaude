library(tidyverse)
library(readxl)
library(magrittr)
library(grid)
library(cowplot)

df <- read_excel("F1.xlsx", sheet = "Fig 1c KEGG module") %>% 
  column_to_rownames(var="...1")

df2 <- df %>% rownames_to_column(var="ID") %>% head(60) %>% select(1:13) %>%  
  pivot_longer(-1) %>% set_colnames(c("ID","name","value"))

p <- df2 %>% 
  ggplot(aes(name,ID,fill=value))+
  geom_tile()+
  coord_cartesian(clip = "off") + 
  labs(x=NULL,y=NULL)+
  scale_y_discrete(expand=c(0,0),position="right")+
  scale_x_discrete(expand=c(0,0))+
  scale_fill_gradient2(mid="#FBFEF9",low="#0C6291",high="#A63446") +
  coord_cartesian(clip = "off") + 
  theme_test()+
  theme(axis.text.x=element_text(color="black",size=8,face="bold",angle = 90,vjust=0.5),
        axis.text.y=element_text(color="black",size=8,face="bold",angle = 0,vjust=0.5),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        legend.background = element_blank(),
        legend.text = element_text(size=8,color="black",face="bold"),
        legend.position =c(-0.2,0.9),
        legend.spacing.x = unit(0.01,"in"),
        plot.margin = ggplot2::margin(10,60,10,60))

ggdraw(xlim = c(0, 1.1), ylim = c(0,1))+
  draw_plot(p,x = 0, y =0) +
  draw_line(x = c(0.9,0.9), y = c(0.08,0.98),lineend = "butt",size =1, col = "grey80",
            arrow=arrow(angle = 30, length = unit(0.4,"inches"),ends = "both", type = "closed"))+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="grey80",col="grey80")),x=0.875,y=0.11,height = 0.85,width=0.05)+
  draw_text(text = "EDC genes", size = 12, x = 0.9, y = 0.55, angle = 90,color="black",fontface = "bold",hjust = 0.5)


