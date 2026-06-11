library(tidyverse)
library(glue)
library(ggtext)
library(janitor)

df <- readr::read_csv('data.txt')

d <- df %>% janitor::clean_names() %>% 
  select(year, j_d) %>% drop_na()

anom <- tibble(j_d = seq(-.50, 1.25, .50)) %>% 
  mutate(label = gt::vec_fmt_number(j_d,decimals = 1,
                                    pattern = "{x}°C",sep_mark = ".",dec_mark = ","))

ggplot(data = d,aes(x = year, y = j_d)) +
  geom_raster(aes(y = 1, fill = j_d)) +
  geom_raster(aes(y = 0, fill = j_d)) +
  geom_raster(aes(y = -1, fill = j_d)) +
  geom_hline(yintercept = anom$j_d, color ="grey70", linetype = 3, linewidth = .3) +
  geom_text(
    data = anom,aes(x = 1880, y = j_d, label = label),inherit.aes = FALSE,
    angle = 0, hjust = 0, vjust = 0, color ="red", size = 4) +
  geom_line(linewidth = 0.5, color = "white", lineend = "round") +
  geom_line(linewidth = 0.8, color ="grey70", lineend = "round") +
  geom_line(linewidth = .25, color = "black", lineend = "round") +
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(11, "RdBu")))+ 
  scale_x_continuous(breaks = seq(1800, 2020, 20)) +
  labs(x = NULL, y = NULL) +
  coord_cartesian(expand = FALSE, ylim = c(-.55, 1.1), clip = "on") +
  theme_void()+
  theme(
    aspect.ratio = 0.5,
    plot.margin = margin(10,20,10,20),
    axis.text.x = element_text(color="black",hjust = 0.5, vjust=0.5,size = 10,face="bold"),
    axis.ticks.x = element_line(color="black", linewidth = .75),
    axis.ticks.length.x = unit(.2, "line"),
    legend.position = "top",
    legend.background = element_blank(),
    legend.title = element_blank(),
    panel.grid = element_blank())+
  guides(fill=guide_colorbar(direction="horizontal",reverse=F,barwidth=unit(16,"cm"),
                              barheight=unit(0.5,"cm")))


