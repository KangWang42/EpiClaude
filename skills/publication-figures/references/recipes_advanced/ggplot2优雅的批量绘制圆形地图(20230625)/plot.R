library(tidyverse)
library(maps)
library(sf)
library(tidygeocoder)
library(camcorder)
library(scico)
library(rnaturalearth)
library(terra)
library(tidyterra)
library(geodata)
library(ggh4x)


lats <- c(90:-90, -90:90, 90)
longs <- c(rep(c(180, -180), each = 181), 180)
crs_wintri <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

# 创建一个窗口三角形的轮廓，用于绘制地图边界
wintri_outline <- 
  list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") %>% 
  st_sf() %>%
  lwgeom::st_transform_proj(crs = crs_wintri) 

# 创建窗口三角形的经纬网格
grat_wintri <- st_graticule(lat = c(-89.9, seq(-80, 80, 20), 89.9)) %>%
  lwgeom::st_transform_proj(crs = crs_wintri)

robinson <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
# 获取世界国家边界数据
map <- ne_countries(scale = 50, returnclass = 'sf') %>% 
  st_transform(graticules, crs = robinson)

g <- st_graticule(ndiscr = 500)

# 读取数据集 df
df <- read_tsv("df.xls")

ggplot() + 
  # 绘制窗口三角形轮廓
  geom_sf(data = wintri_outline, fill = "white", color = NA,alpha=0.5)+
  # 绘制窗口三角形的经纬网格
  geom_sf(data = grat_wintri, color = "grey", linewidth = 0.15)+
  # 绘制世界国家边界
  geom_sf(data = map, size = 0.1, color = "#28282B")+
  # 绘制六边形图层，用于展示数据分布
  geom_hex(data = df %>% drop_na(), aes(x = longitude, y = latitude),
           binwidth = c(2.5, 2.5), color = "grey96", linewidth = .01)+
  # 设置填充颜色的渐变和标签
  scale_fill_gradient2(midpoint = 1000, labels = scales::comma,
                       guide = guide_colorbar(
                         title = "x......x",
                         title.position = "left",
                         title.theme = element_text(angle = 90),
                         barwidth = unit(.75, "lines"),
                         barheight = unit(10, "lines"))) +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0)) +
  facet_wrap2(vars(day_part)) +
  theme_minimal() +
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        panel.spacing = unit(1.5, "lines"),
        strip.text = element_text(face = "bold", hjust = 0,size = 11),
        plot.background = element_rect(fill = "grey96", color = NA),
        plot.margin = margin(0.1,0.1,0.1,0.1))

                                       





