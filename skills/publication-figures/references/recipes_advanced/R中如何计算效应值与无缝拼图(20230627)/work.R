library(tidyverse)
library(magrittr)
library(patchwork)


data <- read_tsv("data.txt") %>% pivot_longer(-Sample.taxa) %>% 
  left_join(.,read_tsv("group.txt") %>% 
              dplyr::rename(name=sample),by="name") %>% 
  select(value,group) %>% set_colnames(c("outcome","treatment"))

mean_A = mean(data$outcome[data$treatment == "pre"])
mean_B = mean(data$outcome[data$treatment == "post"])
sd_pooled = sqrt((var(data$outcome[data$treatment == "pre"]) + var(data$outcome[data$treatment == "post"])) / 2)

d <- (mean_A - mean_B) / sd_pooled

# 计算组间平方和（SSB）
SSB <- sum((mean(data$outcome[data$treatment == "pre"]) - mean(data$outcome))^2) +
  sum((mean(data$outcome[data$treatment == "post"]) - mean(data$outcome))^2)

# 计算总平方和（SST）
SST <- sum((data$outcome - mean(data$outcome))^2)

# 计算Eta-squared
eta_squared <- SSB / SST


p1 <- iris %>% 
  ggplot(aes(Sepal.Length,Petal.Length,color=Species))+
  geom_point()+
  theme(legend.position = "non")

p2 <- iris %>% 
  ggplot(aes(Petal.Width,Petal.Length,color=Species))+
  geom_point()+
  theme(plot.background = element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.y = element_blank(),
        legend.position = "non")+
  labs(y=NULL)
  

p1+p2+plot_layout(guides = 'collect')


library(aplot)

p1 %>% insert_right(p2)

library(cowplot)


ggdraw()+
  draw_plot(p1,scale = 0.9,x=0.02,y=0,width = 0.5,height=1)+
  draw_plot(p2,scale = 0.9,x=0.44,y=0,width = 0.5,height=1)
