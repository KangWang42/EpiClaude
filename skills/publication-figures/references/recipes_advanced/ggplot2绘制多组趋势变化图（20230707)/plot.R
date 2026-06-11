library(tidyverse)
library(patchwork)
library(janitor)
library(glue)
library(ggtext)

prices <- read_csv('prices.txt')
companies <- read_csv('companies.txt')

pal <- c(TSLA = "#e82127",MSFT = "#00a1f1",AAPL = "#555555",
  ADBE = "#ED2224",AMZN = "#FF9900",CSCO = "#15495d",
  GOOGL = "#3cba54",IBM = "#006699",INTC = "#0071c5",
  META = "#0668E1",NFLX = "#E50914",NVDA = "#76b900",
  ORCL = "#f80000")


df_base <- map_dfr(unique(prices$stock_symbol), ~{
  prices |>
    mutate(
      group = stock_symbol,
      stock_symbol = .x
    )
}) |>
  left_join(companies,by="stock_symbol")


df_base |>
  ggplot() +
  geom_line(aes(date, close, group = group),alpha = 0.5,size = 0.1,colour = "grey") +
  geom_area(aes(date, close, colour = stock_symbol, fill = stock_symbol),
            prices, alpha = 0.2, size = 0.5) +
  facet_wrap(~stock_symbol, ncol = 4) +
  scale_colour_manual(values = pal) +
  scale_fill_manual(values = pal) +
  theme_test() +
  theme(
    text = element_text(size =, lineheight = 0.3, colour = "white"),
    plot.margin = margin(b = 8, t = 8, r = 8, l = 8),
    axis.text = element_text(size =9,color="black"),
    strip.text = element_text(size=10,face="bold"),
    strip.background = element_blank(),
    panel.spacing.x = unit(0.2,"cm"),
    legend.position = "none")
