library(tidyverse)
library(scales)
library(ggtext)
library(ggp)
library(geomtextpath)

data <- read_tsv("data.xls")

df <- data %>% 
  filter(country == "USA") %>% 
  filter(status %in% c("Operating", "Planned", "In development", "Under Construction")) %>%
  select("country", "height", "status") %>%
  mutate(new_status = ifelse(status == "Operating", "In Operation", "Coming Soon")) %>%
  group_by(new_status) %>%
  tally(height) %>% 
  mutate(csum = rev(cumsum(rev(n))), 
         pos = n/2 + lead(csum, 1),
         pos = if_else(is.na(pos),n/2,pos))


df %>%
  ggplot(aes(x = 5, y = n, fill = new_status, label = n)) +
  geom_col(width=0.8, color = "#f2f2f2") +
  geom_textpath(aes(x = 5,y=pos,label = paste(n,"feet")),
                text_only = TRUE,angle = 90,size=4.5,color = "black") +
  xlim(c(1.5, 5.5)) +
  coord_polar("y", start = 0, clip = "off") +
  scale_fill_manual(values = c("#E6956F", "#709AE1FF")) +
  annotate(geom='richtext', x = 1.5, y = 0, size = 4,
           label = "<b>Cumulative Height</b><br>4,902 feet",fill = NA, label.color = NA) +
  theme_void() +
  theme(text = element_text(size = 9,color = "black"),
        legend.position = "top",
        legend.title = element_blank(),
        legend.spacing.x = unit(0.05,"cm"),
        legend.text = element_text(color="black",size=8),
        plot.margin = unit(c(2,2,2,2), "cm"),
        plot.background =element_blank())


