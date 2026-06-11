library(tidyverse)
library(ggforce) 
library(ggtext)

df <- read_tsv("data.xls") %>%
  select(1, 8:15) %>%
  mutate(
    Year2 = -90 + 180 * (Year - 1880) / (2022 - 1880),
    across(2:9, ~ .x * 25) # 对第2到第9列的数据乘以25
  )

COLORS_ZON <- c("#797d62","#9b9b7a","#d9ae94","#E5C59E","#f1dca7","#ffcb69","#d08c60",
                "#B58463")

ggplot(df) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = 64, ymax =Inf), fill = COLORS_ZON[8]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = 44, ymax =64), fill = COLORS_ZON[7]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = 24, ymax =44), fill = COLORS_ZON[6]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = 0, ymax = 24), fill = COLORS_ZON[5]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -24, ymax = 0), fill = COLORS_ZON[4]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -44, ymax = -24), fill = COLORS_ZON[3]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -64, ymax = -44), fill = COLORS_ZON[2]) +
  geom_rect(aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax =-64), fill = COLORS_ZON[1]) +
  geom_circle(aes(x0=0, y0=0, r=90), col=NA, fill="grey0", alpha=.5, size=1)+ 
  geom_segment(aes(x=-90, xend=90, y=0, yend=0), col="seashell1", size=.1) +
  geom_line(aes(x=Year2, y=`64N-90N`), col=COLORS_ZON[8]) +
  geom_line(aes(x=Year2, y=`44N-64N`), col=COLORS_ZON[7]) +
  geom_line(aes(x=Year2, y=`24N-44N`), col=COLORS_ZON[6]) +
  geom_line(aes(x=Year2, y=`EQU-24N`), col=COLORS_ZON[5]) +
  geom_line(aes(x=Year2, y=`24S-EQU`), col=COLORS_ZON[4]) +
  geom_line(aes(x=Year2, y=`44S-24S`), col=COLORS_ZON[3]) +
  geom_line(aes(x=Year2, y=`64S-44S`), col=COLORS_ZON[2]) +
  geom_line(aes(x=Year2, y=`90S-64S`), col=COLORS_ZON[1]) +
  scale_y_continuous(limits=c(-100,100)) +
  scale_x_continuous(limits=c(-100*16/9,100*16/9)) +
  coord_fixed() +
  theme_void()

