library(tidyverse)
library(stringr)
library(janitor)
library(tsibble)
library(ggtext)
library(bsts)
library(tidybayes)
library(ggfx)

data <- readr::read_csv("data.txt")

df <- data %>%
  clean_names() %>% 
  mutate(date = ymd(date)) %>%
  rename(avg_price = apu000072610) %>% 
  filter(date > "2006-12-01") %>% 
  mutate(avg_price = as.numeric(avg_price)) %>% 
  mutate(year = year(date), month = month(date), day = day(date)) %>%
  mutate(date = floor_date(as_date(date), "month")) %>% 
  mutate(date = yearmonth(date))


set.seed(74)

ss <- AddLocalLinearTrend(list(), df$avg_price)
ss <- AddSeasonal(ss, df$avg_price, nseasons = 12)

model <- bsts(df$avg_price, state.specification = ss, niter = 1000)

horizon <- 48

df_forecast <- data.frame(date = max(df$date) + 1:horizon) %>% 
  add_draws(predict(model, horizon = horizon, burn = SuggestBurn(0.1, model), 
                    quantiles = c(0.25, 0.75))$distribution) %>% 
  sample_draws(200)


ggplot() +
  geom_line(data = df, aes(x = as.Date(date), y = avg_price), color = "black", linewidth = 0.8) +
  with_outer_glow(
    geom_line(data = df_forecast, aes(x = as.Date(date), y = .value, group = .draw), linewidth = 0.3, color = "#69F0AE", alpha = 0.5),
    color = "#69F0AE", sigma = 7) +
  scale_y_continuous(limits = c(0, NA),breaks = seq(0, 0.3, by = 0.04)) +
  scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text = element_text(size = 8,color = "black"),
        axis.title.y = element_text(size =10,color = "black",face="bold",margin  = margin(r = 5)),
        axis.title.x = element_text(size =10,color = "black",face="bold",margin = margin(t = 20)),
        axis.line = element_line(color = "black", linewidth = 0.3),
        panel.grid = element_line(color = "#616161", linewidth = 0.2, linetype = "dashed"),
        plot.margin = unit(c(1, 1, 1, 1), "cm"),
        plot.background = element_rect(color = NA, fill = "grey80")) 
