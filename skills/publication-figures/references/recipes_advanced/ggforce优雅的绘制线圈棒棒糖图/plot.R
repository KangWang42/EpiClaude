library(tidyverse)
library(janitor)
library(ggtext)
library(ggforce)
library(ggfx)
library(colorspace)

yarn <- readr::read_csv("yarn.csv")

pal <- tribble(~r, ~g, ~b,198, 114, 67,
  220, 166, 146,180, 185, 163,129, 160, 149,30, 166, 179) %>% 
  mutate(pal = rgb(r, g, b, maxColorValue = 255)) %>% 
  pull(pal)

pal <- colorRampPalette(pal)(8)

df_base <- yarn %>% 
  group_by(yarn_company_name) %>% 
  summarise(rating = mean(rating_average, na.rm = TRUE),n = n()) %>% 
  arrange(desc(n)) %>% 
  head(8) %>% 
  ungroup() %>% 
  mutate(p = n/sum(n),x0 = 1:n())

df_yarn <- map_dfr(1:nrow(df_base), ~{
  tibble(
    x = 3*df_base$p[.x]*sin(seq(0, 2*pi, length = 200)) + df_base$x0[.x],
    y = 3*df_base$p[.x]*cos(seq(0, 2*pi, length = 200)) + df_base$rating[.x] - 3*df_base$p[.x],
    id = runif(200),yarn_company_name = df_base$yarn_company_name[.x]
    )}) %>% 
  mutate(y = -y) %>% 
  arrange(yarn_company_name, id)

df_yarn %>% 
  ggplot(aes(x, y)) +
  geom_rect(aes(xmin=0.5,xmax=8.5,ymin=-1.2,ymax = -1),fill = lighten("#d4a373", 0.2)) +
  with_blur(geom_segment(aes(x = x0, xend = x0, y = -1, yend = -rating+0.2,
                             colour = yarn_company_name), df_base, size = 0.6),sigma = 3) +
  with_blur(geom_bspline0(aes(colour = yarn_company_name),size=0.6),sigma=3) +
  geom_text(aes(x0, -rating-0.2, label = paste0(yarn_company_name, "\n\n\n",round(rating, 1), "|", n)),
            df_base,size =4, colour = "black", lineheight = 0.3)+
  coord_cartesian(clip = "off") +
  scale_colour_manual(values = pal,breaks = df_base$yarn_company_name) +
  scale_x_continuous(breaks = 1:8,labels = df_base$yarn_company_name) +
  ylim(-5, -1) +
  theme_void() +
  theme(
    text = element_text(size =4, colour = "grey20"),
    legend.position = "none",
    plot.background = element_rect(fill ="white", colour = "grey20"),
    plot.margin = margin(t=20,b=0,l=20,r=20))

