library(tidyverse)
library(ggtext)
library(patchwork)
library(showtext)

font_add_google(name = "Roboto Condensed", family = "Roboto Condensed")
showtext_auto()

age_gaps <- readr::read_csv('age_gaps.txt')

act1_m <- age_gaps %>% filter(character_1_gender == "man") %>% 
  pull(actor_1_age)

act2_m <- age_gaps %>% filter(character_2_gender == "man") %>% 
  pull(actor_2_age)

act1_w <- age_gaps %>% filter(character_1_gender == "woman") %>% 
  pull(actor_1_age)

act2_w <- age_gaps %>% filter(character_2_gender == "woman") %>% 
  pull(actor_2_age)

ages_m <- c(act1_m, act2_m)
ages_w <- c(act1_w, act2_w)

ages_m_bins <- tibble(age = ages_m) %>% 
  mutate(bin = cut(ages_m, breaks = seq(0, 85, 5),
                   include.lowest = TRUE, right = FALSE)) %>% 
  count(bin) %>% 
  complete(bin, fill = list(n = 0)) %>% select(ages = bin, men = n)

ages_w_bins <- tibble(age = ages_w) %>% 
  mutate(bin = cut(ages_w, breaks = seq(0, 85, 5),
                   include.lowest = TRUE, right = FALSE)) %>% 
  count(bin) %>% 
  complete(bin, fill = list(n = 0)) %>% select(ages = bin, women = n)

ages_bins <- ages_m_bins %>%  
  left_join(ages_w_bins) %>% 
  mutate(ages_labels = c("0 - 4","5 - 9","10 - 14","15 - 19","20 - 24","25 - 29",
                         "30 - 34","35 - 39","40 - 44","45 - 49","50 - 54","55 - 59",
                         "60 - 64","65 - 69","70 - 74", "75 - 79", "80+")) %>% 
  rowid_to_column()

ggplot(data = ages_bins) +
   geom_rect(aes(xmin = -men - 25,xmax = -25, ymin = rowid - 0.4, ymax = rowid + 0.4),
             fill="#0487e2") +
   geom_rect(aes(xmin = 25,xmax = women + 25, ymin = rowid - 0.4, ymax = rowid + 0.4),
             fill="#ed2939") +
   geom_text(aes(x=0, y = rowid,family = "Roboto Condensed",
                 label = ages_labels),color = "white", size =3.5) +
   scale_x_continuous(breaks = c(seq(-375, -25, 50), seq(25, 375, 50)),
                      labels = c(abs(seq(-350, 0, 50)), seq(0, 350, 50)),
                      limits = c(-375, 375)) +
   labs(x=NULL,y=NULL)+
   theme_minimal() +
   theme(
     panel.background = element_rect(fill = "#1a1a1a", color = NA),
     panel.grid.minor = element_blank(),
     panel.grid.major.y = element_blank(),
     panel.grid.major.x = element_line(linewidth = 0.15, linetype = "dotted"),
     plot.background = element_rect(fill = "#1a1a1a", color = NA),
     axis.text.y = element_blank(),
     axis.text.x = element_text(family = "Roboto Condensed",color = "white", size = 10))

