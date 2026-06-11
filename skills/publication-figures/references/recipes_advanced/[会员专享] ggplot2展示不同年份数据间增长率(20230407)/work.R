library(tidyverse)
library(tidytuesdayR)
library(lubridate)
library(scales)
library(ggimage)
library(ggbump)
library(ggtext)


df <- read_tsv("data.xls")

ar_clean <- df %>%
  mutate(across(matches("cost|pump|itude"), as.numeric),
         date_call = dmy_hm(date_time_of_call),
         day_call = wday(date_call),
         month_call = month(date_call),
         hour_call = hour(date_call),
         year_call = year(date_call),
         animal_group_parent = str_to_title(animal_group_parent),
         animal = fct_lump(animal_group_parent, 5)) 

# Filters for years 2019 and 2020
year_filter <- function(data) {
  data %>%
    filter(year_call >= 2019 & year_call <= 2020)
}

ar_wide <- year_filter(ar_clean) %>%
  filter(property_category %in% c("Dwelling", "Outdoor")) %>%
  select(year_call, animal, property_category) %>%
  count(year_call, animal, property_category) %>%
  mutate(year_call = paste0("y", year_call)) %>%
  pivot_wider(id_cols = c(animal, property_category), names_from = year_call, values_from = n) %>%
  mutate(diff = y2020 - y2019,
         perc = y2020 / y2019 - 1, 
         sign = ifelse(diff < 0, "neg", "pos"))

cost <- year_filter(ar_clean) %>%
  select(year_call, animal, pump_hours_total, incident_notional_cost) %>%
  group_by(year_call, animal) %>%
  summarise(total_hours = sum(pump_hours_total, na.rm = TRUE),
            total_cost = sum(incident_notional_cost, na.rm = TRUE)) %>%
  pivot_wider(id_cols = animal, names_from = year_call, values_from = c(total_hours, total_cost)) %>%
  mutate(posy = 6 - as.numeric(animal),
         perc = total_cost_2020 / total_cost_2019 - 1,
         sign2020 = ifelse(perc > 0, "pos", "neg"),
         sign2019 = ifelse(perc < 0, "pos", "neg"),
         offset = ifelse(perc > 0, 0.15, -0.15),
         angle = ifelse(perc > 0, 15, -12),
         proportion = total_cost_2020 / sum(total_cost_2020),
         poscol = proportion / 2 + rev(cumsum(rev(lead(proportion, default = 0)))))

pal <- c("Bird" = "#818C30", "Cat" = "#64732F", "Dog" = "#C4DDF2", "Fox" = "#6F9ABF", "Horse" = "#3264A6", "Other" = "#6C8CB5")


ar_wide %>%
  mutate(posy = 6 - as.numeric(animal),
         shifty = ifelse(property_category == "Dwelling", 0.15, -0.15),
         posy_shift = posy + shifty) %>%
  ggplot()+
  geom_segment(data = tibble(x = seq(0,250,50), 250), aes(x = x, xend = x, y = -0.25, yend = 5.5), 
               linetype = "15", size = 0.3)+
  geom_text(data = tibble(x = seq(0,250,50), 250), aes(x = x, y = -0.5, label = x)) +
  geom_segment(aes(x = y2019, xend = y2020, y = posy_shift, 
                   yend = posy_shift, color = sign), size =2)  + 
  geom_point(aes(y2019, posy_shift, color = sign), shape = 21, 
             fill = "white", size = 4, stroke = 1) +
  geom_point(aes(y2020, posy_shift, color = sign, fill = sign),
             shape = 21, size = 3, stroke = 1)+
  geom_segment(aes(x = 0, xend = 250, y = posy, yend = posy), 
               size = 0.5, color = "#C29E44") +
  geom_text(data = cost,aes(x = 325, y = posy - offset, 
                            label = dollar(total_cost_2019,prefix= "$")), hjust = 1,size=3) +
  geom_text(data = cost,aes(x = 413, y = posy + offset, 
                            label = dollar(total_cost_2020,prefix="$"),color = sign2020),hjust = 1,size=3) +
  geom_text(data = cost,aes(x = 355, y = posy, label = percent(perc),
                            angle = angle), hjust=0.5,vjust = -0.3,size=2)+
  geom_segment(data = cost,aes(x=330,xend=380,y=posy-offset, 
                               yend = posy + offset),arrow=arrow(length=unit(2,"mm")))+
  geom_sigmoid(data = cost,aes(x=420,xend =520,y=posy+offset, 
                               yend = poscol * 5 , group = animal), color = "grey60")+
  geom_col(data = cost, aes(x = 540, y = proportion * 5, fill = animal), width = 30)+
  geom_text(data = cost, aes( x = 540, y = poscol * 5, label = percent(proportion)),size=2) +
  annotate("text", x = 320, y = 5.8, label = "2019", hjust = 1, vjust = 0) +
  annotate("text", x = 390, y = 5.8, label = "2020", hjust = 0, vjust = 0) +
  scale_x_continuous(limits = c(-50, 560)) +
  scale_color_manual(values = c("neg" = "#9FBFC2", "pos" = "#49868C"))+
  scale_fill_manual(values = c(pal, "neg" = "#9FBFC2", "pos" = "#49868C"))+
  labs(x=NULL,y=NULL)+
  guides(color = FALSE) +
  theme_bw()+
  theme(axis.text=element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        legend.spacing.x = unit(0.1,"cm"),
        legend.key.height = unit(0.5,"cm"),
        legend.key.width = unit(0.5,"cm"))


