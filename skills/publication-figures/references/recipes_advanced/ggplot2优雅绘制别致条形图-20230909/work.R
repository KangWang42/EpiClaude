library(tidyverse)
library(ggtext)
library(ggforce)

df <- read_tsv("data.tsv")

r <- .275
xo <- 115 / 10
yo <- -0.15

df %>% ggplot()+
  facet_wrap(vars(holder_company_name), ncol = 1) +
  geom_rect(aes(xmin = 0, xmax = n / 10, ymin = -.125, ymax = 1.125),fill = "#add8e6", alpha = .65) +
  geom_text(aes(x = 95 / 10, y = .5, label = holder_company_name), color = "white",
            fontface = "bold", size = 4, hjust = 1) +
  annotate(geom = "rect", xmin = 0, xmax = 100 / 10, ymin = -.125, ymax = 1.125, color = "white", fill = NA) +
  annotate(geom = "rect", xmin = -5 / 10, xmax = 0, ymin = .35, ymax = .65, color = "white", fill = "white") +
  annotate(geom = "rect", xmin = -7 / 10, xmax = -5 / 10, ymin = .15, ymax = .85, color = "white", fill = "white") +
  annotate(geom = "rect", xmin = 100 / 10, xmax = 101 / 10, ymin = .35, ymax = .65, color = "white", fill = "white") +
  annotate(geom = "rect", xmin = 101 / 10, xmax = 102 / 10, ymin = .4, ymax = .6, color = "white", fill = "white") +
  annotate(geom = "segment", x = 102 / 10, xend = 115 / 10, y = .5, yend = .5, color = "white") +
  ggforce::geom_circle(data = tibble(x = xo, y = yo), aes(x0 = xo, y0 = yo, r = r), color = "white", fill = "#add8e6", alpha = .65, size = .85) +
  geom_text(aes(x = xo, yo, label = n),size = 3) +
  theme_minimal() +
  theme(
    text = element_text(color = "white"),
    axis.title = element_blank(),
    axis.text = element_blank(),
    strip.text = element_blank(),
    panel.spacing.y = unit(.125, "cm"),
    panel.grid = element_blank(),
    plot.background = element_rect(fill = "grey20", color = NA),
    plot.margin = margin(t = .5, r = 1.5, b = .5, l = 1.5, unit = "cm"))
