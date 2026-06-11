library(tidyverse)
library(ggsci)
library(cowplot)
library(patchwork)

df <- read_tsv("data-1.txt") %>% pivot_longer(-sample) 

df$sample <- factor(df$sample,levels = df$sample %>% unique() %>% rev())
df$name <- factor(df$name,levels = df$name %>% unique())

  
p1 <- df %>% ggplot(aes(name,sample,fill=value,color=value))+
  geom_tile(color="grey50",fill="white",size=0.28)+
  geom_point(data=df %>% filter(value=="Expressed"),
             size=6,shape=21)+
  geom_point(data=df %>% filter(value=="Gene encoded"),
             size=6,shape=21)+
  scale_fill_manual(values =c("grey90","grey90"))+
  scale_color_manual(values =c("black","grey90"))+
  labs(x = NULL,y = NULL,color=NULL,fill=NULL)+
  scale_x_discrete(expand=c(0,0))+
  scale_y_discrete(expand=c(0,0),position = 'left') +
  theme(axis.text.x=element_text(angle =45,hjust =1,vjust =1,color="black",size =8),
        axis.text.y=element_text(color="black",size =8,face="bold"),
        axis.ticks= element_blank(),
        legend.background = element_blank(),
        plot.background = element_blank(),
        legend.key = element_blank(),
        legend.text = element_text(color="black",face="bold"),
        plot.margin = unit(c(3,0.2,0.2,0.2),units="cm"))


df2 <- read_tsv("data-2.txt")
df2$sample <- factor(df2$sample,levels = df2$sample %>% unique())
  
p2 <- df2 %>% ggplot(aes(sample,value,fill=group))+
  geom_col(width=0.9)+
  scale_y_continuous(expand = c(0,0))+
  scale_fill_npg()+
  theme_classic()+
  theme(legend.position = "non",
        plot.background = element_blank(),
        axis.text.y=element_text(color="black",face="bold"),
        axis.title = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank())

ggdraw(p1)+
  draw_plot(p2+theme(legend.position = "non"),scale=0.635,x=-0.124,y=0.6,width=1,height=0.4)+
  draw_text(text="Condition MAG\n relative abundance(%)",size=9,x=0.25,y=0.9,color="black")
  
