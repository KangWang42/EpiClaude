library(tidyverse)
library(ggsci)
library(ggridges)
library(ggtext)
library(ggh4x)


p <- read_tsv("data.xls") %>% 
  filter(continent %in% c("Asia","Europe")) %>%
  ggplot(aes(y = country, x = lifeExp, fill = continent))+
  geom_density_ridges(size = .15, color = "white")+
  scale_x_continuous(
    trans = "log10", expand = c(0, 0),
    labels = scales::comma_format(suffix = "k", scale = 1e-4)) +
  scale_y_discrete(expand = c(0, 0)) +
  scale_fill_futurama(alpha = .95) +
  facet_wrap(vars(continent), scales = "free_y") +
  coord_cartesian(clip = "off") +
  theme_minimal() +
  theme(legend.position = "bottom",
    legend.justification="right",
    axis.title.x = element_text(margin = margin(t = 10), color = "white"),
    axis.title.y = element_blank(),
    axis.text.x = element_text(size = 8, color = "white"),
    axis.text.y = element_text(face = "bold", color = "white"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(linewidth = .3, linetype = "dashed", color = "grey75"),
    panel.grid.major.y = element_blank(),
    axis.ticks.x = element_line(linewidth = .3, color = "white"),
    panel.spacing = unit(1,"lines"),
    strip.text = element_text(face = "bold", margin = margin(b = 10),  color = "white", size = 12),
    plot.background = element_rect(fill = "#3F4041FF", color = NA),
    plot.margin = margin(20, 20, 20, 20),
    legend.title = element_blank())+
  guides(fill = guide_legend(override.aes = list(color = NA),
                             label.theme = element_text(color = "white",size = 8)))

ggsave(plot =p, filename="plot.pdf", device = cairo_pdf,width = 7.8, height=7.7, units = "in")


library(magick)


tmp = image_read_pdf("plot.pdf", density = 300)
image_write(tmp, "plot.jpeg")


