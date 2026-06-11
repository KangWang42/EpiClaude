library(tidyverse)
library(janitor)
library(ggtext)
library(ggforce)
library(ggfx)

df <- read_tsv("data.tsv")

pal <- c('#ecbf3d', '#f0cc46', '#f5e355', '#fdf56d', '#fdffbe', '#ffffff')

cities <- c("Paris", "Berlin", "London", "Sydney", "New York")

df_time <- df %>% 
  group_by(zone) %>% 
  slice_max(end) %>% 
  mutate(city = str_replace(str_extract(zone, "(?<=/)[^/]*$"), "_", " ")) %>% 
  filter(city %in% cities) %>% 
  mutate(
    city = factor(city, levels = rev(cities)),
    lab = paste0(city, "."),
    offset = offset/3600,
    offset_lab = ifelse(offset < 0, as.character(offset), paste0("+", offset))
  ) %>% 
  ungroup()

df_circle <- map_dfr(cities, ~{
  tibble(x = 0,y = 0,
    r = seq(1, 0.75, length = 10),
    col = colorRampPalette(pal)(10),
    city = .x)
}) %>% 
  mutate(city = factor(city, levels = rev(cities))) %>% 
  left_join(df_time %>% select(city, offset),by = "city") %>% 
  mutate(y = as.numeric(city))

df_time %>% 
  ggplot() +
  geom_text(aes(0, city, label = lab),size =5, colour = ifelse(df_time$dst,"#ecbf3d", "white"),
            hjust = 0, fontface = "bold") +
  geom_text(aes(3.8, city, label = offset_lab), colour = "white", size = 4, fontface = "bold") +
  geom_segment(aes(x=4, xend = 8, y = city, yend = city), colour = "white") +
  with_inner_glow(
    geom_circle(aes(x0 = offset/6+6, y0 = y, r = r/2, fill = col, group = city), df_circle, colour = NA),
    colour = "grey20", expand = 2, sigma = 5) +
  scale_fill_identity() +
  coord_fixed() +
  theme_void() +
  theme(plot.background = element_rect(fill ="grey20", colour = "grey20"),
    plot.margin = margin(b = 2, t = 5, r = 5, l = 5))
