library(tidyverse)
# devtools::install_local("truchet-master.zip")
# install.packages("devtools")
# devtools::install_github("paezha/truchet")
library(truchet)
library(MetBrewer)
library(ggtext)
library(camcorder)


df <- read_tsv("data.xls") %>% 
  mutate(
    yard_r = round(yardage / 1e3),
    m_r = round(yardage * 0.9144),
    max_yard_r = max(yard_r)) %>% 
  mutate(i = row_number())

source("knit.R")

top_yarn <- df %>%  rowwise() %>% 
   mutate(truchet = list(knit(i, max_yard_r, yard_r)))

top_yarn$name <- factor(df$name,levels = df$name)

top_yarn %>% unnest(truchet) %>%
  ggplot() +
  annotate("segment", x = -2, xend = 28, y = 32.2, yend = 32.3,size = 4,
           lineend = "round", color = "grey20") +
  annotate("point", x = -2, y = 32.2, size = 10, color = "grey20") +
  geom_sf(aes(group = name, geometry = geometry, fill = name,
              color = after_scale(colorspace::darken(fill, 0.2))))+
  scale_fill_manual(values = met.brewer("Cassatt2", 10, direction = -1)) +
  theme_classic()+
  labs(x=NULL,y=NULL)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x = element_blank(),
        panel.background = element_blank(),
        legend.background = element_blank(),
        legend.title = element_blank(),
        plot.background = element_rect(fill = "white", color = "white"))


