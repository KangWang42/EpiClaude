library(tidyverse)
library(ggtext)
library(showtext)

font_add_google("Karla")
f1="Karla"

data <- read_tsv("data.xls")

df <- data %>% 
  select(-total) %>%
  mutate(biodiesel= parse_number(biodiesel)) %>%
  pivot_longer(2:7) %>%
  mutate(year=parse_number(year))

lev <- df %>% group_by(name) %>% tally(value) %>% arrange(n) %>%
  pull(name)

df %>%
  mutate(name=factor(name, levels=rev(lev)),value=replace_na(value,0)) %>%
  arrange(year,name) %>%
  group_by(year) %>%
  mutate(val = cumsum(value)) %>%
  ungroup() %>%
  ggplot() + 
  annotate(geom="segment",x=rep(2005.5,7), xend=rep(2021,7), 
           y=seq(10000,70000,10000), yend=seq(10000,70000,10000), size=.3, color="black") +
  ggforce::geom_link(aes(x=year, xend=year, y=0, yend=val,
                         color=fct_rev(name)), size=2) +
  geom_text(data = df %>% filter(year %in% c(2007, 2013,2019), name=="other"),
            aes(label=year, x=year, y=0), vjust=2, size=3, family=f1) +
  geom_text(data = df %>% filter(year %in% c(2007, 2013,2019), name=="other"),
            aes(label="|", x=year, y=0), vjust=1.5, size=1, familiy=f1) +
  scale_color_manual(values=rev(c("#788FCE","#0073B2","#E6956F","#C5E8E3","#F2CC8F","#A88AD2")),
                     labels=c("Other","Gasoline","Biodiesel","Hybrid","Natural Gas","Diesel")) +
  coord_polar(theta = "y", clip="off", start = 4.71)+
  scale_x_continuous(expand = expansion(mult = c(1, -0.12))) +
  scale_y_continuous(expand = expansion(mult = c(0, .1)), 
                     breaks=seq(10000,70000,10000), labels=scales::comma_format()) +
  theme_void() +
  theme(text=element_text(family=f1),
        axis.text.x=element_text(color="black", size=8),
        legend.position=c(.5,.5),
        legend.title=element_blank(),
        legend.text = element_text(color="black"),
        plot.margin=margin(.3,.3,.3,.3, unit="cm")) +
  guides(color=guide_legend(reverse=T))

