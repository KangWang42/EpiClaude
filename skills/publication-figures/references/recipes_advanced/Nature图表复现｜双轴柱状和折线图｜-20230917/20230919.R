library(tidyverse)
library(patchwork)

df <- iris %>% pivot_longer(-Species) %>% 
  group_by(Species) %>% 
  slice_head(n=2) %>% 
  ungroup() %>% 
  slice(-4,-6)

p1 <- ggplot(df) +
  geom_col(aes(x =Species,y=value,fill=name),
           position =  "dodge")+
  labs(x=NULL,y=NULL)+
  theme(legend.position ="non")

p2 <- ggplot(mtcars, aes(factor(cyl), fill = factor(vs))) +
  geom_bar(position = position_dodge(preserve = "single"))+
  labs(x=NULL,y=NULL)+
  theme(legend.position ="non")

p3 <- ggplot(df) +
  geom_col(aes(x =Species,y=value,fill=name),
           position = position_dodge2(preserve = "single"))+
  labs(x=NULL,y=NULL)+
  theme(legend.position ="non")

p1+p2+p3

set.seed(1234)                                         
data <- data.frame(values = rnorm(100),
                   group = LETTERS[1:4])

ggplot(data, aes(x = group, y = values)) +              

  stat_boxplot(geom="errorbar",width=0.1)+
  geom_boxplot() +
  stat_summary(fun = mean, geom = "point", col = "#00A08A") +  
  stat_summary(fun = mean, geom = "text", col = "#00A08A",  
               vjust = 1.5, aes(label = paste("Mean", round(..y.., digits = 1))))+
  theme_bw()
            