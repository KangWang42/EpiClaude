library(tidyverse)

dat_long <- read_csv("data.txt")

cols <- c("Severe hypoxia" = "#b24745","Intubated" = "#483d8b", 
          "Not intubated" = "#3B9AB2", "Steroids"="#ffd966", 
          "Death" = "#000000")

dat_swim <- dat_long %>% 
  mutate(severe_this_day = case_when(severe == 1 ~ day),
         steroids_this_day = case_when(steroids == 1 ~ day),
         death_this_day = case_when(death == 1 ~ day)) %>% 
  group_by(id) %>% 
  mutate(max_day = max(day)) %>% 
  ungroup() %>% 
  mutate(id = fct_reorder(factor(id), max_day))


dat_swim %>% 
  ggplot() +
  geom_line(aes(x=day, y=id, col = intubation_status, group=id),size=2)+
  geom_point(aes(x=steroids_this_day, y=id, col="Steroids"), shape=15, stroke=2) +
  geom_point(aes(x=severe_this_day, y=id, col="Severe hypoxia"), size=2, stroke=1.5, shape=21) +
  geom_point(aes(x=death_this_day, y=id, col="Death"), size=2, stroke=1.5, shape=4) +
  theme_bw() +
  scale_color_manual(values = cols, name="Patient Status")+
  scale_x_continuous(expand=c(0,0)) + 
  labs(x=NULL,y=NULL)+
  theme(axis.text= element_text(size=8,face="bold",hjust=1.5),
    axis.ticks.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank()) +
  guides(color = guide_legend(override.aes = list(
    shape =  c(4, NA, NA,21,15), # 修改图例形状
    linetype = c(NA,1,1,NA,NA),  #  线型
    size = c(2.6,2.5,2.5,2.6,2)  # 尺寸
    )))

