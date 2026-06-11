library(tidyverse)
#devtools::install_github("doehm/ggbrick")
library(ggbrick)


data <- read_tsv("data.xls")

df <- data %>% arrange(desc(n)) %>% 
  mutate(state = fct_reorder(state, n, max)) %>% 
  slice_head(n =10) %>% 
  mutate(n_lab = paste0(round(n/1000, 1), "k"))

df %>% 
  ggplot(aes(state,state_lab)) +
  geom_brick(aes(state, n, fill = n), colour = NA, size = 0.2) +
  geom_text(aes(state, y = n+280, label = n_lab),colour = "black",
            lineheight = 0.5, size =3.5) +
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(6, "RdBu"))) +
  labs(x=NULL,y=NULL,fill = "Number of\nHistorical\nMarkers") +
  scale_y_continuous(expand = c(0,100))+
  scale_x_discrete(labels = function(y) str_wrap(y, width=6))+
  theme_classic()+
  theme(axis.line.y.left = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.x=element_text(color="black",size=8,face="bold"),
    plot.background = element_rect(fill ="white", colour ="white"),
    plot.margin = margin(b = 2, t = 5, r = 5, l = 5),
    legend.title = element_text(size =10))




