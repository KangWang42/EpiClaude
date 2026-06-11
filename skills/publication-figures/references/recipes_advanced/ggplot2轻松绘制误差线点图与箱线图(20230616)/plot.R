library(tidyverse)
library(gapminder)
library(ggsci)
library(patchwork)

gapminder %>% filter(continent=="Asia",year=="1952")

df <- gapminder %>% select(continent,year,lifeExp) %>% 
  filter(continent==c("Europe","Oceania","Americas")) %>% 
  mutate(year=as.character(year)) %>% 
  group_by(continent,year) %>% 
  summarise(value_mean=mean(lifeExp),sd=sd(lifeExp),se=sd(lifeExp)/sqrt(n()))

p1 <- df %>% ggplot(aes(year,value_mean,fill=continent,group=continent,
                  ymin=value_mean-se,ymax=value_mean+se))+
  geom_errorbar(width=0.1)+
  geom_line(color="black")+
  geom_point(key_glyph="polygon",aes(color=continent))+
  geom_point(pch=21,size=3,show.legend = F)+
  scale_fill_npg()+scale_color_npg()+
  labs(x=NULL,y=NULL)+
  theme_bw()+
  theme(plot.margin=unit(c(0.1,0.1,0.1,0.1),units=,"cm"),
        axis.line = element_line(color = "black",size = 0.4),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(size = 0.2,color = "#e5e5e5"),
        axis.text.y = element_text(color="black",size=10),
        axis.text.x = element_text(margin = margin(t=3),color="black",
                                   size=9,angle=90,vjust = 0.5),
        legend.key=element_blank(),
        legend.title = element_blank(),
        legend.text = element_text(color="black",size=8),
        legend.spacing.x=unit(0.1,'cm'),
        legend.spacing.y=unit(1,'cm'),
        legend.key.width=unit(0.7,'cm'),
        legend.key.height=unit(0.4,'cm'),
        legend.background=element_blank(),
        legend.position = c(0.2,0.9),
        legend.box.margin = margin(0,0,0,0))

p2 <- df %>% ggplot(aes(continent,value_mean,fill=continent))+
  stat_boxplot(geom="errorbar",width=0.2)+
  geom_boxplot()+
  scale_fill_npg()+scale_color_npg()+
  theme_bw()+
  labs(x=NULL,y=NULL)+
  theme(axis.text = element_text(color="black",angle=90,vjust=0.5,hjust=0.5),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        legend.position = "non")

(p1+p2)+plot_layout(widths=c(2,1))

  
