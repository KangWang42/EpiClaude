library(tidyverse)
library(ggtext)

teams_off <- read_tsv("data.xls")

# 定义函数rect_mid，用于生成指定长度的一系列均匀分布的矩形的中点坐标
rect_mid <- function(width, x, xend, n) {
  seq(x + (width / 2), xend - (width / 2), length.out = n)
}

# 获取数据集teams_off的行数并计算相关比例
n <- nrow(teams_off) 
rw1 <- 1
rw2 <- (n - 1) / n

# 初始化x1、x2、y1、y2
x1 <- 0
x2 <- 0.5 
y1 <- 0
y2 <- 1 / (2 * tan(pi / 3))

# 生成矩形中点坐标数据
coords_df <- tibble(rw1, x1 = x1, x1_end = x1 + n,
  rw2, x2 = x2, x2_end = x2 + (n - 1),y1, y2, n) %>% 
  mutate(
    pt1_x = pmap(list(width = rw1, x = x1, xend = x1_end, n), rect_mid),
    pt2_x = pmap(list(width = rw2, x = x2, xend = x2_end, n), rect_mid)) %>% 
  unnest_longer(c(pt1_x, pt2_x)) %>% 
  mutate(group = as.factor(row_number()), height = teams_off$gs / 8.5)

# 为每组数据添加logo字段
coords_df <- coords_df %>% 
  mutate(row_num = row_number()) %>% 
  left_join(teams_off) %>% 
  mutate(logo = glue::glue("<img src='{logo_link}' width='35'/>"))

# 定义margin为15
margin <- 15

# 生成斜线形状的矩形坐标数据

inclined_ribbon_df <- coords_df %>% 
  mutate(ptx_1_borders = map2(pt1_x, rw1, \(x, y) {
    c(x - y / 2 + y / margin, x + y / 2 - y / margin)
  }),
  ptx_2_borders = map2(pt2_x, rw2, \(x, y) {
    c(x + y / 2 - y / margin, x - y / 2 + y / margin)
  })) %>% 
  unnest_longer(c(ptx_1_borders, ptx_2_borders)) %>% 
  pivot_longer(names_to = "pt_name",
               cols = c("ptx_1_borders", "ptx_2_borders"),
               values_to = "ptx") %>% 
  mutate(pty = ifelse(pt_name == "ptx_1_borders", y1, y2)) %>% 
  arrange(group, pt_name)


coords_df %>% ggplot(aes(fill = hex_code)) +
  geom_rect(aes(xmin = pt1_x - rw1 / 2 + rw1 / margin, ymin = y1 - 1,
                xmax = pt1_x + rw1 / 2 - rw1 / margin, ymax = y1)) +
  geom_rect(aes(xmin = pt2_x - rw2 / 2 + rw2 / margin, ymin = y2, 
                xmax = pt2_x + rw2 / 2 - rw2 / margin, ymax = y2 + height))+
  geom_polygon(data = inclined_ribbon_df, aes(x = ptx, y = pty, group = group),alpha = 0.6) +
  geom_text(aes(x = pt2_x, y = y2 + 1.5, label = team,color = after_scale(prismatic::best_contrast(fill))),
            angle = 90,size=4,hjust = 0) +
  geom_text(aes(x = pt2_x, y = y2 + height, label = gs),color = "black",size=4,vjust = -.5) +
  geom_richtext(aes(x = pt1_x, y = 0, label = logo),fill = NA,label.color = NA,vjust = 0)+
  scale_fill_identity() +
  labs(x=NULL,y=NULL)+
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.text = element_blank(),
        plot.background = element_rect(fill = "grey70", color = NA),
        plot.margin = margin(c(1, .5, .25, 1), unit = "cm"))

