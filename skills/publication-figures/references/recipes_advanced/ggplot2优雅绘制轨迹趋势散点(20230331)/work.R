library(tidyverse)
library(ggforce)
# install.packages("janitor")
library(janitor)

age <- read_csv("age.txt") %>% janitor::clean_names()
age_new <- age %>%  head(20) %>% 
  mutate(median_age_2 = median_age - difference)

age_new %>% ggplot() +
  ggforce::geom_link(aes(x = median_age,y = reorder(name, -index),
      xend = median_age_2,yend = name,
      size = after_stat(index),
      alpha = after_stat(index)),color = "#709AE1FF")+
  geom_point(
    aes(x = median_age_2, y = name),
    color = "#709AE1FF",shape = 21,size = 6,fill = "#F3F3F3") +
  geom_vline(xintercept = 26.3, linetype = "dashed") +
  geom_vline(xintercept = 28, linetype = "dashed") +
  geom_text(
    data = data.frame(x = 26.4, y = 10,
                      label = "Median 2006-10"),
    mapping = aes(x = x, y = y, label = label),
    inherit.aes = FALSE,size = 3,angle = 90) +
  geom_text(data = data.frame(x = 28.1, y = 12,
                      label = "Median 2015-19"),
    mapping = aes(x = x, y = y, label = label),
    inherit.aes = FALSE,size = 3,angle = 90) +
  theme_classic()+
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 8,face="bold"),
    axis.title.y = element_blank(),
    axis.title.x = element_text(size = 9))

