library(tidyverse)
library(lubridate)
library(scico)
library(ggforce)

df <- read_csv("data.csv") %>% janitor::clean_names()
df <- df %>% mutate(year=year(gas_day_started_on)) %>% 
  filter(year > 2012)
  
df %>%
  select(gas_day_started_on,gas_in_storage_t_wh) %>%
  mutate(mth = month(gas_day_started_on)) %>%
  ggplot(aes(x=mth, y=gas_in_storage_t_wh,group=mth)) +
  ggforce::geom_sina(aes(color=gas_in_storage_t_wh), alpha=.5, shape=21)+
  geom_text(data=tibble(x=6.5, y=seq(2,8,2), lab=c("2","4","6","8TWh")),
            aes(x=x, y=y, label=y),inherit.aes = FALSE)+
  scico::scale_color_scico(palette="roma", direction=-1,
                           labels=scales::label_number(suffix="TWh")) +
  scale_x_continuous(breaks=c(seq(1,12,1)), labels=month.abb[1:12]) +
  scale_y_continuous(breaks=c(seq(0,8,2))) +
  coord_polar() +
  cowplot::theme_minimal_grid(12, line_size = .3) +
  theme(legend.position = "top",
        legend.title=element_blank(),
        legend.text=element_text(size=9.5),
        axis.title=element_blank(),
        axis.text.y=element_blank(),
        plot.margin=margin(.5,0,.3,0, unit="cm"),
        legend.justification = "center",
        legend.margin=margin(b=-15)) +
  guides(color=guide_colorbar(barwidth = unit(18,"lines"),
                              barheight = unit(.5,"lines"))) 
