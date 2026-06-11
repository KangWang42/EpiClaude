library(tidyverse)
library(ggtext)

outer_ring <- read_tsv("outer_ring.xls")

inner_ring <- read_tsv("data.xls")

ggplot()+
  geom_rect(data = inner_ring,
    aes(xmin = 0.5, xmax = 1.5, ymin = ymin, ymax = ymax, fill = character2),
    alpha = 1, color = "white", linewidth = 0.42)+
  annotate("rect", xmin = 0, xmax = 0.75, ymin = -Inf, ymax = Inf, fill = "grey")+
  annotate("text",x = 0, y = 0, label = "The Office",fontface = "plain", color = "grey10", size = 7)+
  geom_text(data = inner_ring,aes(x = ifelse(words_share > 0.05, 1.1, 1.9), 
      y = ymin + (ymax - ymin) / 2,
      label = character2,
      size = ifelse(words_share > 0.05, 4, 3.5),
      vjust = ifelse(words_share > 0.05, 0.5, -0.7)),hjust = 0.5)+
  scale_size_identity() +
  scale_color_identity() +
  coord_polar(theta = "y", clip = "off", start = -0.005) +
  labs(title =NULL) +
  theme_void() +
  theme(plot.background = element_rect(color = "white", fill = "white"),
    text = element_text(color ="black"),
    legend.title = element_blank(),
    plot.margin = margin(t = 0, b = 0, l = 4, r = 4))

ggplot()+
  geom_rect(data = outer_ring,
            aes(xmin = 0.25, xmax = 1.5 + 2 * words_share.season, 
                ymin = ymin, ymax = ymax, fill = character2), color = "white", linewidth = 0.1)+
  geom_rect(data = inner_ring,
            aes(xmin = 0.5, xmax = 1.5, ymin = ymin, ymax = ymax, fill = character2),
            alpha = 1, color = "white", linewidth = 0.42)+
  annotate("rect", xmin = 0, xmax = 0.75, ymin = -Inf, ymax = Inf, fill = "grey")+
  annotate("text",x = 0, y = 0, label = "The Office",fontface = "plain", color = "grey10", size = 7)+
  geom_text(data = inner_ring,aes(x = ifelse(words_share > 0.05, 1.1, 1.9), 
                                  y = ymin + (ymax - ymin) / 2,
                                  label = character2,
                                  size = ifelse(words_share > 0.05, 4, 3.5),
                                  vjust = ifelse(words_share > 0.05, 0.5, -0.7)),hjust = 0.5)+
  scale_size_identity() +
  scale_color_identity() +
  coord_polar(theta = "y", clip = "off", start = -0.005) +
  labs(title =NULL) +
  theme_void() +
  theme(plot.background = element_rect(color = "white", fill = "white"),
        text = element_text(color ="black"),
        legend.title = element_blank(),
        plot.margin = margin(t = 0, b = 0, l = 4, r = 4))  




