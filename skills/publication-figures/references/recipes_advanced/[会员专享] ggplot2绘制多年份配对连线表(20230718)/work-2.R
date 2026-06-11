library(ggplot2)
# install.packages("dplyr")
library(dplyr)
# remotes::install_local("bstfun-main.zip",upgrade = F,dependencies = T)
library(bstfun) 
library(patchwork) 
library(gt)
library(scales) 
library(tidyverse)
library(RColorBrewer)

df <- read_tsv("data.xls") %>% 
  group_by(year, industry) %>% 
  summarise(med_rq = median(rq), .groups = "drop_last") %>% 
  arrange(desc(med_rq), .by_group = TRUE) %>% 
  mutate(rank = 1:n()) %>% ungroup() %>% 
  mutate(rank_fct=as.character(rank))

df2022 <- df %>% filter(year == 2022)

df2017 <- df %>% filter(year == 2017) %>% 
 bind_rows(tibble(year=2017,industry = "Healthcare",med_rq = NA_real_,rank = 18))

 

lines <- ggplot() +
  geom_line(data = df, aes(x = year, y = rank, group = industry))+
  geom_point(data = df %>% filter(year == 2022 | (year == 2017 & rank != 18)),
             aes(x = year, y = rank, fill = rank_fct),
             shape = 21, colour = "black", size = 3, stroke = 1)+
  scale_fill_manual(values=(colorRampPalette(brewer.pal(12, "Paired"))(18)))+
  scale_size_manual(values = c(0.25, 1)) +
  scale_alpha_manual(values = c(0.5, 1)) +
  scale_y_reverse(breaks = 1:max(df$rank), limits = c(NA, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  theme_classic() +
  theme(legend.position = "none",
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x=element_text(color="black"),
        axis.title = element_blank(),
        plot.margin = margin(r = 5, t = 0, l = 5, b = 0))


gt_palette <- scales::col_numeric(c("#004714","#35669D","#93A198","#FEF2F2"),
                                  domain = NULL, alpha = 0.75)

# gt_palette_factor22 <- scales::col_factor(palette = gt_palette(df2022$med_rq),
#                                          domain = df2022$industry, alpha = 0.75) 

tbl_2022 <- df2022 %>% select(med_rq, industry) %>% 
  gt() %>% cols_label(med_rq = "") %>% 
  fmt_number(columns = c(med_rq), n_sigfig = 3) %>% 
  tab_style(locations = cells_column_labels(columns = everything()),
            style= list(cell_borders(sides = "bottom", weight = px(3)),cell_text(weight = "bold"))) %>% 
  tab_style(locations = cells_title(groups = "title"),
            style = list(cell_text(weight = "bold", size = 24))) %>% 
  data_color(columns = c(med_rq),colors = gt_palette) %>%
 # data_color(columns = c(industry),colors = gt_palette_factor22) %>% 
  opt_all_caps() %>%
  cols_align(align = "left",columns = c(med_rq)) %>% 
  cols_align(align = "center",columns = c(industry)) %>% 
  cols_width(c(industry) ~ px(145),c(med_rq) ~ px(70)) %>% 
  tab_options(
    column_labels.border.top.width = px(3),
    column_labels.border.top.color = "transparent",
    table.border.top.color = "transparent",
    table.border.bottom.color = "transparent",
    data_row.padding = px(3),
    source_notes.font.size = 12,
    heading.align = "left")

#gt_palette_factor17 <- scales::col_factor(palette = gt_palette(df2017$med_rq),
#                                          domain = df2017$industry, alpha = 0.75) 

tbl_2017 <- df2017 %>% select(industry, med_rq) %>% 
  gt() %>% cols_label(med_rq = "") %>% 
  fmt_number(columns = c(med_rq), n_sigfig = 3) %>% 
  tab_style(locations = cells_column_labels(columns = everything()),
            style = list(cell_borders(sides = "bottom", weight = px(3)),
                         cell_text(weight = "bold"))) %>% 
  tab_style(locations = cells_title(groups = "title"),
            style = list(cell_text(weight = "bold", size = 24))) %>% 
  data_color(columns = c(med_rq),colors = gt_palette) %>%
 # data_color(columns = c(industry),colors = gt_palette_factor17) %>% 
  opt_all_caps() %>%
  cols_align(align = "right",columns = c(med_rq)) %>%
  cols_align(align = "center",columns = c(industry)) %>% 
  cols_width(c(industry) ~ px(145),c(med_rq) ~ px(70)) %>% 
  tab_options(
    column_labels.border.top.width = px(3),
    column_labels.border.top.color = "transparent",
    table.border.top.color = "transparent",
    table.border.bottom.color = "transparent",
    data_row.padding = px(3),
    source_notes.font.size = 12,
    heading.align = "left")

tbl_2017_ggplot <- bstfun::as_ggplot(tbl_2017)
tbl_2022_ggplot <- bstfun::as_ggplot(tbl_2022) 

tbl_2017_ggplot + lines + tbl_2022_ggplot


