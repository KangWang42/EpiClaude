library(tidyverse)
# devtools::install_github("wilkelab/ungeviz")
library(ungeviz)
library(broom)
library(emmeans)


hdi <- read_tsv("hdi.xls") 
population <- read_tsv("population.xls")

hdi_old <-
  lm(hdi ~ continent, data = filter(hdi, year == min(year)),
     weights = population) %>%emmeans("continent") %>%
  tidy() %>%
  mutate(continent = factor(continent),
         continent = fct_reorder(continent, 1:5),
    year = 1990)

hdi_new <-
  lm(hdi ~ continent, data = filter(hdi, year == max(year)),
     weights = population) %>%
  emmeans("continent") %>%tidy() %>%
  mutate(continent = factor(continent),
    continent = fct_reorder(continent, 1:5),year = 2021)

plot_data <- bind_rows(hdi_new, hdi_old) %>%
  mutate(year = factor(year))

txt <- "#0076BE"
cornflower <- "#95D8EB"
oceangreen <- "#48BF91"
bg <- "grey95"

ggplot(plot_data,
       aes(x = estimate, moe = std.error, y = year)) +
  stat_confidence_density(aes(group = year, fill = year),
                          height = 0.6,
                          confidence = 0.68) +
  geom_point(aes(x = estimate),
             size = 3) +
  geom_errorbarh(aes(xmin = estimate - std.error,
                     xmax = estimate + std.error),
                 height = 0.3) +
  scale_fill_manual(values = c(oceangreen, txt)) +
  xlim(0.3, 1.0) +
  facet_wrap( ~ continent ~ ., ncol = 1, switch = "y") +
  labs(y = NULL) +
  theme_minimal() +
  theme(
    text = element_text(family = "font", colour = txt,size = 10),
    plot.background = element_rect(fill = bg,colour = bg),
    axis.text = element_text(colour = txt),
    panel.grid.major = element_line(colour = "grey70"),
    panel.grid.minor.x = element_blank(),
    strip.placement = "outside",
    strip.text.y.left = element_text(size = 10,colour = txt,face = "bold",angle = 0,),
    panel.spacing = unit(2, "lines"),plot.margin = margin(5,5,5,5))


