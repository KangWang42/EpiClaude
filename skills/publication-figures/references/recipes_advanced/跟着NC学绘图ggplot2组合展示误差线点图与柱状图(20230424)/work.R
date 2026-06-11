library(tidyverse)
library(readxl)
library(ggsci)
library(cowplot)

df <- read_tsv("data.xls")

p1 <- df %>% ggplot(aes(mean,group,color=type,fill=type))+
  geom_point(position = position_dodge(0.8))+
  geom_errorbar(aes(xmin=mean-error,xmax=mean+error),
                 position = position_dodge(0.8))+
  labs(y=NULL,x="standardized coefficient")+
  scale_fill_npg()+
  scale_color_npg()+
  theme_bw()+
  theme(axis.text= element_text(color = "black",size=8,face="bold"),
        axis.title = element_text(color="black",size=9,face="bold"),
        legend.title = element_blank(),
        legend.text = element_text(color="black",size=7,face="bold"),
        legend.position = c(0.2,0.065),
        legend.background = element_blank(),
        legend.spacing.x = unit(0.1,"cm"),
        legend.key = element_blank(),
        legend.key.height = unit(0.4,"cm"),
        legend.key.width = unit(0.4,"cm"),
        plot.background = element_blank(),
        panel.background = element_blank())

p2 <- df %>% ggplot(aes(`IncMSE (%)`,group,color=type,fill=type))+
  geom_col(position = position_dodge(0.8))+
  scale_x_continuous(expand = c(0,0))+
  labs(y=NULL)+
  scale_fill_npg()+
  scale_color_npg()+
  theme_bw()+
  theme(axis.text.y=element_blank(),
        axis.text.x=element_text(color="black",size=8),
        axis.title = element_text(color="black",size=9,face="bold"),
        axis.ticks.y=element_blank(),
        legend.position = "non",
        plot.background = element_blank(),
        panel.background = element_blank())

ggdraw()+
  draw_plot(p1,scale=0.9,x=-0.026,y=0,width = 0.6,height=1)+
  draw_plot(p2,scale=0.9,x=0.506,y=0,width = 0.4,height=1)

