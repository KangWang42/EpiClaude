library(tidyverse)
library(ggsci)


df <- tibble(
  country = c("Sweden", "Denmark", "Netherlands", "Portugal", "Japan", "Estonia"),
  n_years = c(271, 186, 169, 81, 74, 60)) %>% 
  group_by(country) %>% 
  group_modify(~ runif(n = .x$n_years) %>% tibble(random = .)) %>% 
  mutate(year = 2022 - seq_along(country)) %>% 
  ungroup()

df %>% 
  ggplot(aes(year, random, color = country))+
  geom_path()+
  facet_wrap(~country, ncol = 2)

arr <- df %>% mutate(country = country %>% as_factor %>% fct_infreq()) %>%
  arrange(country, year) %>% 
  mutate(row = country %>% lvls_revalue(new_levels = 1:3 %>% rep(2) %>% paste),
    col = country %>%lvls_revalue(new_levels = 1:2 %>% rep(each = 3) %>% paste)) %>%
  ungroup()

arr %>% 
  ggplot(aes(year, random, color = country))+
  geom_line()+ 
  facet_grid(row~col, scales = "free_x", space = "free")+
  geom_text(data = . %>% distinct(country, row, col),
    aes(label = country), x = 2020, y = 1.05,
    hjust = 1, vjust = 0, size = 5)+
  scale_y_continuous(limits = c(0, 1.15), breaks = seq(0, 1, .25))+
  scale_x_continuous(breaks = seq(1750,2000,50))+
  scale_color_jco()+
  labs(x=NULL,y=NULL)+
  theme_bw()+
  theme(legend.position = "none",strip.text = element_blank(),
        axis.text = element_text(color="black",size=9,face="bold"))

