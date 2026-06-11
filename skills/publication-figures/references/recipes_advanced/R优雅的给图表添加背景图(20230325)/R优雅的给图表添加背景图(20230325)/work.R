library(tidyverse)
library(ggforce)
library(cowplot)
library(magick)
library(ggbeeswarm)
library(ggtext)
library(ggh4x)


penguins <- read_tsv("penguins.xls")
color_scale <- c("Adelie" = "darkorange", "Chinstrap" = "purple","Gentoo" = "cyan4")

ridiculous_strips <- strip_themed(
  background_x = elem_list_rect(
    fill =  c("#DE9ED6FF","#709AE1FF","white","white")))

p <- penguins %>% 
  pivot_longer(cols = bill_length_mm:body_mass_g) %>% 
  mutate(species = factor(species, levels = c("Chinstrap", "Gentoo", "Adelie"))) %>% 
  ggplot(aes(species, value, color = species)) +
  geom_violin(aes(fill = species),alpha = 0.40) +
  geom_beeswarm() +
  facet_wrap2(vars(name),scales="free_y",axes="y",strip = ridiculous_strips)+
  scale_color_manual(values = color_scale) +
  scale_fill_manual(values = color_scale) +

#  facet_wrap(vars(name), scales = "free_y") +
  theme_void() +
  theme(legend.position = "none",
        plot.margin = margin(5,5,5,5),
        panel.spacing = unit(0,"lines"),
        panel.background = element_rect(color = "black",fill = NA),
        strip.background = element_rect(fill = "grey95"),
        strip.text = element_text(hjust = 0.5, size = 10,face = "bold",color="black",
                                  margin = margin(5,5,5,5)))

img <- 
  image_read("penguins.png") %>% 
  image_resize("200x220") %>%
  image_colorize(80,"white")

ggdraw() + draw_image(img) +draw_plot(p)

