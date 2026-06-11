library(tidyverse)
library(showtext)
library(ggimage)
library(scales)


df  <- readr::read_csv('data.txt')

egg <- magick::image_read("egg.svg") %>%
  magick::image_trim()

egg_img <- magick::image_write(egg, path = "egg.img", format = "png")
image <- egg_img

df <- df %>%
  filter(grepl("cage", prod_process)) %>%
  filter(prod_process == "cage-free (non-organic)") %>% 
  arrange(observed_month) %>%
  mutate(mom = (n_eggs - lag(n_eggs)) / lag(n_eggs), label = percent(mom %>% round(2))) %>%
  mutate(month = format(observed_month, "%m"), year = format(observed_month, "%Y"))

df %>%
  ggplot(aes(x = month, y = year)) +
  geom_tile(color="grey80",fill="white",size=0.5)+
  geom_image(aes(image = image), size = 0.15, by = "height", asp =1.5, hjust = 0.5) +
  geom_text(aes(label = label, color = ifelse(mom < 0, "#205FA7", "red")),size = 3.5, hjust = 0.5) +
  scale_color_identity() +
  scale_size_continuous(range = c(0, 30)) +
  scale_x_discrete(label = month.abb) +
  scale_y_discrete() +
  theme_void() +
  theme(legend.position = "Null",
        axis.text.x = element_text(size = 8, color = "#000000", margin = margin(t = -5)),
        axis.text.y = element_text(size = 8, color = "#000000", margin = margin(r = 2)),
        plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"),
        plot.background = element_rect(color = "white", fill = "white")) 


