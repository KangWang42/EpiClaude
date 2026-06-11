library(tidyverse)
library(patchwork)

gdp <- read_tsv("data.tsv")

df <- gdp %>% filter(continent=="Africa") %>% 
  select(1,3,4,6) %>% mutate(year=as.character(year))


ggplot()+
  stat_summary(data=df,aes(year,lifeExp),fun = "mean", geom = "bar", alpha = 0.7,fill="#00A08A") +
  stat_summary(data=df,aes(year,lifeExp),fun.data = "mean_cl_normal",
               geom = "errorbar",width = .2,color="#00A08A") +
  stat_summary(data=df %>% mutate(gdpPercap=gdpPercap/20),aes(year,gdpPercap),fun = mean,
               geom = "errorbar",width=.2,color="#F98400",
               fun.max = function(x) mean(x) + sd(x) / sqrt(length(x)),
               fun.min = function(x) mean(x) - sd(x) / sqrt(length(x)))+
  stat_summary(data=df %>% mutate(gdpPercap=gdpPercap/20),
               aes(year,gdpPercap),
               fun = "mean", geom = "point",size=3,color="#F98400")+
  stat_summary(data=df %>% mutate(gdpPercap=gdpPercap/20),
               aes(year,gdpPercap,group=1),
               fun = "mean", geom = "line",color="#F98400")+
  scale_y_continuous(expand = c(0,1),breaks = scales::pretty_breaks(n =12),
                     sec.axis=sec_axis(~. *20,breaks = scales::pretty_breaks(n =12),
                                       name="gdpPercap"))+
  theme_test()+
  theme(panel.background = element_blank(),
        axis.ticks.length.x.bottom =unit(-0.05,"in"),
        axis.ticks.length.y.left =unit(-0.05,"in"),
        axis.ticks.length.y.right =unit(-0.05,"in"),
        axis.ticks.y.right = element_line(color="#F98400"),
        axis.ticks.y.left =  element_line(color="#00A08A"),
        axis.line.y.left = element_line(color="#00A08A"),
        axis.line.y.right =  element_line(color="#F98400"),
        axis.line.x.bottom = element_line(color="black"),
        axis.line.x.top = element_line(color="grey80"),
        axis.text.y.right =  element_text(color="#F98400",margin = margin(l=5,r=10)),
        axis.text.y.left=  element_text(color="#00A08A",margin = margin(l=10,r=5)),
        axis.text.x.bottom = element_text(color="black",face="bold",angle = 90,vjust=0.5),
        axis.title.y.left = element_text(color="#00A08A",face="bold"),
        axis.title.y.right = element_text(color="#F98400",face="bold"),
        axis.title.x.bottom = element_blank())



