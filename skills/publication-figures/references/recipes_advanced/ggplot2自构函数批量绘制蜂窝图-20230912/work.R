library(tidyverse)
library(janitor)
library(glue)
library(ggtext)
library(forcats)
library(ggbeeswarm)
library(emojifont)



df <- read_tsv("data.tsv")

pal <- c("#7B2CBF", "#953B98", "#AF4A72", "#CA5A4C", "#E46926", "#FF7900")
bright <- c("#540d6e", "#ee4266", "#ffd23f", "#3bceac")

df_mean <- df %>% 
  group_by(type) %>% 
  summarise(n_artists = sum(artists_n, na.rm = TRUE)) %>% 
  ungroup() %>% 
  mutate(p_mean = n_artists/sum(n_artists)) %>% 
  select(type, p_mean)

df_base <- df %>% 
  group_by(type, state) %>% 
  summarise(
    n_artists = sum(artists_n, na.rm = TRUE),
    lq = sum(log(location_quotient)*artists_n/sum(artists_n, na.rm = TRUE), na.rm = TRUE)) %>% 
  filter(is.finite(lq)) %>% 
  group_by(state) %>% 
  mutate(p = n_artists/sum(n_artists)) %>% 
  ungroup() %>% 
  mutate(lab = type,
    type = as.numeric(fct_reorder(type, lq, median)))

make_plot <- function(.state, .x) {
  df_state <- df_base %>% 
    filter(state == .state)

df_base %>% 
    ggplot(aes(type,lq)) +
    geom_text(aes(type, -4, label = str_wrap(lab, 25)), df_state,
              size = 20, colour = "grey20", hjust = 0, lineheight = 0.3, vjust = 0.5) +
    geom_beeswarm(size = 4, alpha = 0.5, colour = "grey40") +
    geom_point(aes(x, y), tibble(x = 1:13, y = 0), colour = "grey20", size = 3) +
    geom_point(aes(type, lq), df_state, size = 6, colour = .x) +
    annotate("text", y = -1.2, x = 14, label = "Less than the national share",size = 12, colour = "grey20") +
    annotate("text", y = 1.2, x = 14, label = "More than the national share",size = 12, colour = "grey20") +
    scale_y_continuous(breaks = log(c(0.1, 0.25, 0.5, 1, 2, 4, 8)),
                       labels = round(c(0.1, 0.25, 0.5, 1, 2, 4, 8), 1)) +
    coord_flip(clip = "off") +
    theme_void() +
    labs(y = "Location Quotient (log scale)") +
    theme(text = element_text(colour = "grey20", size =30),
      plot.background = element_rect(fill = "white"),
      plot.margin = margin(t = 30, b = 10, l = 30, r = 30),
      axis.text.x = element_text(),
      axis.title.x = element_text(margin = margin(t = 10)))

  ggsave(glue("plot/artists-{.state}.png"), height = 12, width = 8.5)

}

make_plot("California", pal[6])

states <- c("South Dakota", "District of Columbia", "Nevada", "New York")
walk2(states, bright, make_plot)
