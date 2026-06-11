library(tidyverse)
library(geomtextpath)
library(ggsci)

df <- read_tsv("data.xls")

dat <- df %>% group_by(boardgamecategory) %>% 
  summarise(dens_x = density(average)$x,
            dens_y = density(average)$y,
            .groups = 'drop') %>% 
  mutate(dens_y = dens_y / max(dens_y) * 0.8,
    dens_y = dens_y + case_when(
      boardgamecategory == 'Card Game' ~ 1, 
      boardgamecategory == 'Dice' ~ 2,
      boardgamecategory == 'Fantasy' ~ 3,
      boardgamecategory == 'Party Game' ~ 0,
      boardgamecategory == 'Wargame' ~ 4)) %>% 
  filter(dens_x > 3, (dens_x > 5 | boardgamecategory != 'Wargame'))

dat %>% 
  ggplot(aes(x = dens_x, y = dens_y, fill = boardgamecategory)) +
  geom_polygon() +
  geom_boxplot(data = df, 
    aes(x = average, y = case_when(
      boardgamecategory == 'Card Game' ~ 1, 
      boardgamecategory == 'Dice' ~ 2,
      boardgamecategory == 'Fantasy' ~ 3,
      boardgamecategory == 'Party Game' ~ 0,
      boardgamecategory == 'Wargame' ~ 4)),
    size = 1, width = 0.2, outlier.shape = NA) +
  geom_textpath(aes(col = boardgamecategory, label = boardgamecategory, 
                    hjust = case_when(
                      boardgamecategory == 'Card Game' ~ 0.2, 
                      boardgamecategory == 'Dice' ~ 0.3,
                      boardgamecategory == 'Fantasy' ~ 0.35,
                      boardgamecategory == 'Party Game' ~ 0.2,
                      boardgamecategory == 'Wargame' ~ 0.15)), 
                vjust = -0.2, text_only = T,size = 4)+
  scale_y_continuous(breaks = NULL, minor_breaks = NULL) +
  labs(x=NULL,y=NULL)+
  scale_fill_npg()+
  scale_color_npg()+
  theme_minimal() +
  theme(legend.position = 'none',
    text = element_text(size = 10,color="black",face="bold")) 




