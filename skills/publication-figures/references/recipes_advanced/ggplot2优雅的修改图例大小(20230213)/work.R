library(tidyverse)
library(ggpubr)
library(ggprism)
library(patchwork)
library(ggsci)

# 定义主题
my_theme <- theme_prism(border = TRUE,base_size = 5) +
  theme(legend.box.spacing = unit(1, "cm"),
        legend.text = element_text(size =8),
        legend.title = element_text(size =8,vjust=0.5,hjust=0.5),
        axis.text.y = element_text(size =10, angle = 0, vjust = 0.2),
        axis.text.x = element_text(size =10, angle = 45),
        axis.title = element_text(size=10),
        plot.margin = unit(c(1,1,1,1),units="cm"),
        panel.grid = element_line(color = "gray",size = 0.15,linetype = 2)) 


# 数据清洗
countries_only <- read_tsv("data.xls")

plot_df <- countries_only %>% 
  filter(entity %in% c(countries_only %>% distinct(entity) %>%.$entity),
         continent != "Antarctica") %>%
  group_by(continent, entity) %>%
  summarize(mean_death_perc = mean(deaths_percent, na.rm = TRUE),
            mean_access_perc = mean(access_to_clean_fuel_perc, na.rm = TRUE),
            mean_gdp_per_capita = mean(gdp_per_capita, na.rm = TRUE), .groups = "keep")

# 绘制点图
plot <- ggplot(plot_df, aes(x = log10(mean_gdp_per_capita), y = mean_access_perc)) + 
  geom_point(data = plot_df, aes(size = mean_death_perc, fill = continent), pch = 21) +
  geom_smooth(method = "loess") +
  scale_fill_npg()+
  ggpubr::stat_cor(method = "spearman", 
                   aes(label = paste(..rr.label.., ..p.label.., sep = "~")), 
                   color = "grey9", geom = "label", label.x = 4.1, label.y = 5) +
  scale_y_continuous(breaks = c(0, 25, 50, 75, 100)) + 
  my_theme

# 修改图例大小
plot + guides(fill = guide_legend(override.aes = list(size=5)))



