

install.packages("pacman")
pacman::p_load(tidyverse,ggtext,camcorder,scales,ggsci,ggdist,gghalves)

df <- read_tsv("data.tsv")

spam <- df %>% mutate(yesno = ifelse(yesno == 'y', "Yes", "No")) %>%
  pivot_longer(cols = -yesno, names_to = "category") 

spam %>%
  filter(value > 0, value < 3000) %>%
  ggplot(aes(x = as_factor(yesno), y = value, color = yesno, fill = yesno)) +
  geom_boxplot(width = 0.2,fill  = "transparent",size  = 0.4,outlier.shape = NA) +
  geom_half_violin(alpha = 0.5, side = 'top')+ 
  geom_half_point(side  = "l",alpha = 0.1, size  = 0.6) +
  scale_x_discrete() +
  scale_y_log10()+
  scale_fill_npg()+
  scale_color_npg(guide = "none")+
  coord_flip(clip = 'off') +
  labs(x=NULL,y= "Number of events (log10 scale)") +
  facet_wrap(~ category, scales = "free")+
  theme_minimal()+
  theme(
    plot.background = element_rect(fill = "white", color = "white"),
    panel.background= element_rect(fill = "white", color = "white"),
    axis.ticks.y = element_blank(),
    plot.margin= margin(t = 10, r = 10, b = 10, l = 10),
    axis.title.x= element_text(size = 10,face='bold',margin=margin(t=10)), 
    axis.text = element_text(size = 10,color="black"),
    axis.line.x = element_line(color = "black"),
    panel.grid.major.y= element_line(linetype="dotted",linewidth=0.3,color='gray'),
    panel.grid.minor.y= element_blank(),
    panel.grid.major.x= element_blank(),
    panel.grid.minor.x= element_blank(),
    legend.position = "non",
    strip.text= element_textbox(size= 10,face= 'bold',color= "grey20",
                                hjust= 0.5,halign= 0.5,r= unit(5, "pt"),
                                width = unit(5.5, "npc"),
                                padding = margin(3, 0,3, 0),
                                margin= margin(1,1,1,1)),
    panel.spacing=unit(1,'lines'))






