library(tidyverse)
library(lubridate)
library(camcorder)
library(ggtext)
library(glue)
library(sf)
library(lwgeom)

df <- readr::read_csv("data.txt")

plot_data <- df %>% 
  mutate(q_year = quarter(observed_month, type = "year.quarter"),
         q = quarter(observed_month)) |>
  filter(prod_process == "cage-free (organic)") %>% 
  select(q_year, q, n_eggs) %>% 
  group_by(q_year) %>% 
  mutate(n = round(mean(n_eggs) / 1000000)) %>% 
  select(-n_eggs) %>% unique()

theta <- seq(0, 2 * pi, length.out = 1000)
a <- 1
b <- 3
k <- 70
r <- k * (cos(theta)^2 + a * cos(theta) + b)

plot_egg <- tibble(
  x = 0.0115 * r * sin(theta) + 2018.9,
  y = -1 * r * cos(theta) + 350
)


egg_poly <- st_polygon(list(cbind(plot_egg$x, plot_egg$y / 70)))
egg_line <- st_linestring(matrix(c(plot_data$q_year, plot_data$n / 70), ncol = 2))
cropped_sf <- lwgeom::st_split(egg_poly, egg_line) %>%
  st_collection_extract(c("POLYGON"))

ggplot() +
  geom_sf(data = cropped_sf[[1]],fill = "peachpuff2",colour="sienna4") +
  geom_point(data = filter(plot_data, q == 1),
             mapping = aes(x = q_year,y = n / 70),colour ="sienna4") +
  geom_text(data = filter(plot_data, q == 1),
            mapping = aes(x = q_year,y = n / 70,
                          label = paste0("Jan ", round(q_year), "\n\n\n", n)),
    colour ="black",size = 3,lineheight = 0.8,fontface = "bold") +
  theme_void() +
  theme(plot.background = element_rect(colour = "#FFEDDE", fill = "#FFEDDE"),
        panel.background = element_rect(colour ="#FFEDDE", fill = "#FFEDDE"),
        plot.margin = margin(2,2,2,2))

dev.off()
gg_playback(
  name = file.path("20230415.gif"),
  first_image_duration = 4,
  last_image_duration = 20,
  frame_duration = .25,
  background = "#FFEDDE")
