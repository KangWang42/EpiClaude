

library(tidyverse)
library(ggtext)
library(glue)
#install.packages("rcartocolor")
library(rcartocolor)
library(VoronoiPlus) 

# devtools::install_github("AllanCameron/VoronoiPlus")



all_countries <- read_csv("all_countries.csv")
country_regions <- read_csv("country_regions.csv")
global_economic_activity <- read_csv("global_economic_activity.csv")
global_human_day <- read_csv("global_human_day.csv")


au_data <- all_countries |> 
  select(Category, Subcategory, hoursPerDayCombined, country_iso3) |> 
  left_join(country_regions, by = "country_iso3") |> 
  filter(country_name == "Australia") |> 
  select(Category, Subcategory, hoursPerDayCombined)

# get plot data
au_vor <- voronoi_treemap(hoursPerDayCombined ~ Category + Subcategory,
                          data = au_data)

set.seed(1234)
groups <- filter(au_vor, level == 1)

subgroups <- filter(au_vor, level == 2) |> 
  group_by(group) |> 
  mutate(alpha = runif(1, 0, 0.6)) |> 
  ungroup()


r <- 1.1
theta <- seq(0, (2 * pi), length.out = 13)[1:12]
clock_data <- tibble(
  x = r * cos(theta),
  y = r * sin(theta),
  angle = 90 + 360 * (theta / (2 * pi)),
  label = c("III", "II", "I", "XII", "XI", "X", "IX", "VIII", "VII", "VI", "V", "IV")
)
theta2 <- seq(0, (2 * pi), length.out = 61)[1:60]
clock_data2 <- tibble(
  x = r * cos(theta2),
  y = r * sin(theta2))
clock_data3 <- tibble(
  x = c(0.9, 0.7) * cos(theta[c(2, 6)]),
  y = c(0.9, 0.7) * sin(theta[c(2, 6)]),
  grp = c(1, 2)
)




cols_vec = rcartocolor::carto_pal(length(unique(au_data$Category))+1, "Prism")[1:length(unique(au_data$Category))]
names(cols_vec) = unique(au_data$Category)

highlight_col <- cols_vec[1]


ggplot() +
  geom_polygon(data = groups,mapping = aes(x = x, y = y, group = group, fill = group),
               colour = "#fafafa",linewidth = 5) +
  geom_polygon(data = subgroups,
               mapping = aes(x = x, y = y, group = group, alpha = alpha),
               fill = "#fafafa",colour = "#fafafa",linewidth = 0.3) +
  geom_label(data = clock_data,
             mapping = aes(x = x, y = y, label = label),
             size = 8,label.size = 0,fill = "#fafafa",
             colour = "grey10",fontface = "bold")+
  geom_point(data = data.frame(),mapping = aes(x = 0, y = 0),
             size = 3,colour = "grey10") +
  geom_segment(data = clock_data3,
               mapping = aes(x = 0, y = 0, xend = x, yend = y, group = grp),
               linewidth = 1,
               colour = "grey10") +
  geom_point(data = clock_data2,
             mapping = aes(x = x, y = y),
             size = 0.5,
             colour = "grey10") +
  scale_alpha_identity() +
  scale_fill_manual(values = cols_vec) +
  coord_equal() +
  theme_void(base_size = 12) +
  theme(
    legend.background = element_blank(),
    legend.spacing.x = unit(0,"in"),
    legend.key.height = unit(0.2,"in"),
    legend.key.width = unit(0.2,"in"),
    legend.title = element_blank(),
    plot.background = element_rect(fill = "#fafafa", colour = '#fafafa'),
    panel.background = element_rect(fill = "#fafafa", colour = "#fafafa"),
    plot.margin = margin(10, 10, 10, 10))


