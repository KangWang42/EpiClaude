library(tidyverse)
library(ggtext)

lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C") 

global_temps <- readr::read_csv('global_temps.csv') 

temps <- global_temps |>
  select(!c("J-D", "D-N", "DJF", "MAM", "JJA", "SON")) |>
  pivot_longer(cols = !"Year", names_to = "Month", values_to = "Temp") |>
  mutate(Month = factor(Month, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))) |>
  mutate(date = as.Date(paste("01", Month, Year), format = "%d %b %Y")) |>
  arrange(date)

break_vec <- c(seq(from = as.Date("01-01-1880"), to = as.Date("01-01-2024"), by = "20 years"))

ggplot(temps) +
  geom_hline(aes(yintercept = 0), color = "yellow") +
  geom_line(aes(x = date, y = Temp, color = Temp), linewidth = 0.6) +
  ylab("Temperature deviation (°C)") +
  scale_color_gradientn(name = "Temperature (°C)",colours = (RColorBrewer::brewer.pal(11,"RdBu")))+
  scale_x_date(breaks = "20 years", date_labels = "%Y", expand = c(0,0)) +
  theme(plot.background = element_rect(fill = "grey10"),
        panel.background = element_rect(fill = "grey10"),
        axis.text.x = element_text(size = 16,color = "grey50"),
        axis.title.x = element_blank(),
        axis.text.y = element_text(size = 16,color = "grey50"), 
        axis.title.y = element_text(size = 20,margin = margin(0, 10,0, 0)),
        text = element_text(color = "white"), 
        panel.grid.major = element_line(linewidth = 0.1,color="black"),
        panel.grid.minor = element_blank(),
        legend.background = element_rect(fill = "grey10"),
        legend.position = "bottom",
        plot.margin = margin(1, 1, 1, 1.2, "cm"),
        legend.key.width = unit(1.5, "cm"), 
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 16))

