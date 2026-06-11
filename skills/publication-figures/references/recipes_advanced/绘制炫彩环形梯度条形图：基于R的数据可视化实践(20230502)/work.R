library(tidyverse)
library(scico)
library(geomtextpath)

data <- readr::read_csv("data.xls")


df <- data %>%
  group_by(p_year) %>% 
  summarise(n = n()) %>% 
  na.omit() %>% 
  filter(p_year > 2002) %>% 
  mutate(order = seq(0, 19, by = 1)) 

df %>% 
  ggplot() + 
  ggpattern::geom_rect_pattern(data = df, aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf),
                               pattern = "gradient", pattern_fill = "#87CEEB",
                               pattern_fill2 = "#FFFFFF", color = NA)+
  geom_tile(aes(x = order, y = 0, fill = n), color = "#FFFFFF", size = 0.5) +
  geom_textpath(aes(x = order, y = 0, label = p_year),color = "#000000", size =3, vjust = -2) +
  geom_hline(yintercept = 0.5, color = "#000000") +
  geom_hline(yintercept = -0.5, color = "#000000") +
  scale_y_continuous(limits = c(-7, NA)) +
  scale_fill_scico(palette = "bamako", direction = -1, breaks = c(min(df$n), max(df$n))) +
  coord_curvedpolar(start = 0, clip = "off") +
  theme_void() +
  theme(legend.position = c(0.5, 0.5),
        legend.direction = "horizontal",
        legend.key.height = unit(0.55,'cm'),
        legend.key.width = unit(0.75,'cm'),
        legend.title = element_blank(),
        legend.text = element_text(hjust = 0.5, size = 7, color = "#000000", face = "bold"),
        plot.margin = unit(c(0.5, 0.5, 1, 0.5), "cm"),
        plot.background = element_rect(color = NA, fill = "#FFFFFF"))



