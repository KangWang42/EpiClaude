library(tidyverse)
library(gapminder)
library(ggsci)
library(ggpmisc)




# 示例数据
data <- gapminder %>% filter(!continent %in% c("Oceania","Americas"),year ==1987)

# 绘制散点图
ggplot(data,aes(x = gdpPercap, y = lifeExp, color = continent)) +
  geom_point()+
  scale_color_manual(values =c("#E64B35", "#4DBBD5", "#00A087", "#3C5488")) +
  theme_bw()+
  theme(axis.text = element_text(color="black",face="bold"),
        legend.text = element_text(color="black",face="bold")) +
  labs(x=NULL,y=NULL)




p1 <- data %>% ggplot(aes(gdpPercap,lifeExp,color=continent))+
  geom_point(size=2.5,aes(color=continent))+
  geom_smooth(aes(color=continent),method = 'lm', se = TRUE, show.legend=FALSE)+
  facet_wrap(.~year,scales="free_x",nrow=2,ncol=3)+
  scale_color_npg()+
  stat_poly_eq(method = 'lm',
               aes(label=paste(after_stat(rr.label),
                               after_stat(p.value.label),sep = "*\", \"*")),
               size=3)+
  labs(x=NULL,y=NULL)+
  theme_bw()+
  theme(axis.text=element_text(colour='black',size=9),
        legend.position ="non")





label_positions <- data.frame(
  group = c("Africa", "Asia", "Europe"),
  x = c(0, 20000, 20000),
  y = c(80, 53, 56)
)


label_colors <- c("Africa" = "#E64B35", "Asia" = "#4DBBD5", "Europe" = "#00A087")



source("geom_fit.R")

p2 <- ggplot(data,aes(x = gdpPercap, y = lifeExp, colour = continent)) +
  geom_point()+
  facet_wrap(.~year,scales="free_x",nrow=2,ncol=3)+
  scale_color_manual(values =c("#E64B35", "#4DBBD5", "#00A087", "#3C5488"))+
  geom_fit(data,"gdpPercap", "lifeExp", "continent",
           label_positions,label_colors,label_size = 3.5,
           digits = 3, se = T,r_square=T)+
  labs(x=NULL,y=NULL)+
  theme_bw()+
  theme(axis.text = element_text(color="black"),
        legend.text = element_text(color="black"),
        legend.key = element_blank(),
        legend.spacing.x = unit(0,"cm"))

library(patchwork)

p1+p2

