library(tidyverse)
library(ggtext)

df<- readr::read_csv('data.csv')

labs <- data.frame(Episode_order = c(7, 18, 29), y = c(28, 32, 40), 
                   lab = c("<span style = 'color: #4169E1;'>Season 1</span>", 
                           "<span style = 'color: #5D478B;'>Season 2</span>", 
                           "<span style = 'color: darkorange3;'>Season 3</span>"))

ggplot(df, aes(x = Episode_order)) +
    annotate('text', x = 34.5, y = c(12, 22, 32, 42, 52),
             label = c('10', '20', '30', '40', '50'), color = "black") + 
    geom_hline(yintercept = seq(0, 50, by = 10), colour = "grey70", linewidth = 0.3) + 
    geom_col(aes(y = F_count_total, fill = as.factor(Season)), alpha = 0.8, show.legend = FALSE) + 
    geom_col(aes(y = F_count_RK, fill = as.factor(Season)), show.legend = FALSE) + 
    geom_richtext(data = labs, aes(x = Episode_order, y = y, label = lab), fill = NA,
                  label.color = NA, size = 8) + 
    scale_fill_manual(values = c("#788FCE","#E6956F","#A88AD2")) + 
    scale_y_continuous(limits = c(0, 52), breaks = seq(0, 50, 10)) +
    coord_polar() +
    theme_void() +
    theme(panel.grid = element_blank(),
          panel.background = element_rect(fill = NA, color = NA), 
          plot.background = element_rect(fill = NA, color = NA)) 


