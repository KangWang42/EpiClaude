library(tidyverse)
library(ggsci)
library(rstatix)
library(ggpubr)
library(cowplot)

df <- read_tsv("data.txt") %>%
  pivot_longer(-Id) %>% 
  mutate(group = sub("\\.\\.\\..*", "", name),
         Id=as.factor(Id)) %>% select(-name)

plot <- df %>% group_by(Id,group) %>% 
  summarise(value_mean=mean(value),sd=sd(value),se=sd(value)/sqrt(n()))

p <- plot %>% ggplot(aes(Id,value_mean,fill=group,group=group,
                  ymin=value_mean-se,ymax=value_mean+se))+
  geom_errorbar(width=0.2)+
  geom_line(color="black")+
  geom_point(aes(pch=group,color=group,fill=group),size=3)+
  scale_shape_manual(values=c(25,21,22,24))+
  scale_fill_npg()+
  scale_color_npg()+
  labs(x=NULL,y=NULL)+
  theme_classic()+
  theme(plot.margin=unit(c(0.1,1,0.1,0.1),units=,"cm"),
        axis.line = element_line(color = "black",size = 0.4),
        panel.grid.minor =element_blank(),
        panel.grid.major =element_blank(),
        axis.text.y = element_text(color="black",size=9),
        axis.text.x = element_text(margin = margin(t=3),color="black",size=9,angle=0,vjust = 0.5),
        legend.key=element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(color="black",size=8),
        legend.spacing.x=unit(0.1,'cm'),
        legend.spacing.y=unit(1,'cm'),
        legend.key.width=unit(0.7,'cm'),
        legend.key.height=unit(0.4,'cm'),
        legend.background=element_blank(),
        legend.position = c(0.2,0.95),
        legend.box.margin = margin(0,0,0,0))

df %>%
  t_test(value ~ group) %>%
  adjust_pvalue() %>% add_significance("p.adj") %>% 
  select(2,3,p.adj.signif)

ggdraw()+
  draw_plot(p)+
  draw_line(x=c(0.95,0.95),y=c(0.35,0.63))+
  draw_line(x=c(0.95,0.95),y=c(0.65,0.8))+
  draw_text(x=0.975,y=0.5,text="****",angle=90,size=20,color="black")+
  draw_text(x=0.975,y=0.72,text="****",angle=90,size=20,color="black")
  
