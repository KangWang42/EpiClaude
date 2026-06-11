library(tidyverse)
devtools::install_github("ricardo-bion/ggradar",dependencies = TRUE)
library(ggtext)
library(ggradar)

df <- survivalists <- read_csv("survivalists.txt") %>% 
  inner_join(loadouts <- read_csv('loadouts.txt'), by = c("name", "season")) %>%
  mutate(result = ifelse(result == 7 & season == 4, 10, result)) %>%
  filter(result == 1 | result == 10) %>%
  count(result, item) %>%
  complete(result, item) %>%
  mutate(result =ifelse(result==1, "Winner", "First tapped out"),
         n = ifelse(is.na(n), 0, n),
         n = ifelse(n > 10, 10, n),
         n = n/10) %>%
  pivot_wider(names_from = item, values_from = n) %>%
  rename(group = result)

plot <- df %>% ggradar(font.radar = "secularone", # 设置字体样式
                       group.colours = c("#3e363f", "darkgreen"), # 设置颜色
                       grid.label.size = 5, # 设置网格标签字体大小
                       axis.label.size = 5, # 设置坐标轴标签字体大小
                       group.point.size = 2, # 设置组点大小
                       group.line.width = 0.6, # 设置组线条宽度
                       fill = TRUE, # 是否填充颜色
                       fill.alpha = 0.5, # 设置填充颜色的透明度
                       background.circle.colour = "#547C73", # 设置背景圆圈颜色
                       axis.line.colour = "grey", # 设置坐标轴线条颜色
                       gridline.min.colour = "black", # 设置最小网格线颜色
                       gridline.mid.colour = "black", # 设置中间网格线颜色
                       gridline.max.colour = "red", # 设置最大网格线颜色
                       legend.position = "bottom", # 设置图例位置
                       plot.extent.x.sf=1) # 设置图形范围

plot <- df %>% ggradar(font.radar = "secularone",
          group.colours = c("#3e363f", "darkgreen"),
          grid.label.size = 6,
          axis.label.size = 6,
          group.point.size = 2,
          group.line.width = 0.6,
          fill = TRUE,
          fill.alpha = 0.4,
          background.circle.colour = "#547C73",
          axis.line.colour = "grey",
          gridline.min.colour = "black",
          gridline.mid.colour = "black",
          gridline.max.colour = "black",
          legend.position = "bottom",
          plot.extent.x.sf = 1.1)+
  theme(plot.margin = margin(5,5,5,5))



#plot$layers[[1]]$aes_params 意思是获取第一个图层（layer）的aes_params参数,
# aes_params是ggplot2图形中用于控制图形外观的参数，如颜色、大小等.

plot$layers[[1]]$aes_params <- c(plot$layers[[1]]$aes_params, colour = "grey")
plot$layers[[5]]$aes_params <- c(plot$layers[[5]]$aes_params, colour = "black")
plot$layers[[6]]$aes_params <- c(plot$layers[[6]]$aes_params, colour = "red")
plot$layers[[12]]$aes_params <- c(plot$layers[[12]]$aes_params, colour = "black")
plot$layers[[13]]$aes_params <- c(plot$layers[[13]]$aes_params, colour = "black")
plot$layers[[14]]$aes_params <- c(plot$layers[[14]]$aes_params, colour = "black")

plot


