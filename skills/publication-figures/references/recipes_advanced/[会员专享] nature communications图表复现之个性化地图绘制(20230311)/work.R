# install.packages("rnaturalearthdata")

# install.packages("tidygeocoder")
library(tidygeocoder)
library(tidyverse)
library(sf)
library(camcorder)
library(scico)
library(rnaturalearth)
library(terra)
library(tidyterra)
library(geodata)
library(patchwork)
library(ggsci)

#------------------------ 构建地图框架数据
lats <- c(90:-90, -90:90, 90)
longs <- c(rep(c(180, -180), each = 181), 180)
crs_wintri <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"

wintri_outline <- 
  list(cbind(longs, lats)) %>%
  st_polygon() %>%
  st_sfc(crs = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs") %>% 
  st_sf() %>%
  lwgeom::st_transform_proj(crs = crs_wintri) 
#--------------------------- 构建经纬度线条
grat_wintri <- st_graticule(lat = c(-89.9, seq(-80, 80, 20), 89.9)) %>%
  lwgeom::st_transform_proj(crs = crs_wintri)

#---------------------- 构建地图信息
robinson <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
map <- ne_countries(scale = 50, returnclass = 'sf') %>% 
  st_transform(graticules, crs = robinson)


#-------------------------- 构建经纬度文本信息
g <- st_graticule(ndiscr = 500)

labels_x_init <- g %>% filter(type == "N") %>% mutate(lab = paste0(degree, "°"))

labels_x <- st_as_sf(st_drop_geometry(labels_x_init), lwgeom::st_startpoint(labels_x_init))

labels_y_init <- g %>% filter(type == "E") %>% mutate(lab = paste0(degree, "°"))

labels_y <- st_as_sf(st_drop_geometry(labels_y_init),lwgeom::st_startpoint(labels_y_init)) %>% 
  filter(degree %in% c(180,120,80,40,-180,-120,-80,-40,0))

#------------- 绘制地图
p1 <- ggplot() +
  geom_sf(data = wintri_outline, fill = "#5BBCD6", color = NA,alpha=0.5)+
  geom_sf(data = grat_wintri, color = "grey", linewidth = 0.15)+
  geom_sf(data = map, size = 0.1, color = "#28282B")+
  # 筛选需要标记的地图
  geom_sf(data = map %>% filter(name %in% c("Australia","South Africa",
                                       "France","Germany","Russia","Egypt",
                                       "Hungary","Japan","Brazil","UK","United States","Canada")),
          size = 0.1, color = "#28282B",aes(fill=pop_est),show.legend = F)+
  geom_sf_text(data = labels_x, aes(label = lab), nudge_x = -600000, size = 2) +
  geom_sf_text(data = labels_y, aes(label = lab), nudge_y = -600000, size = 2) +
  scale_fill_gradientn(colours = alpha(RColorBrewer::brewer.pal(6,"RdBu"),0.5))+
  theme_void() +
  labs(x =NULL,y=NULL)+
  theme(plot.margin = margin(0,0.5,0,0.5,unit="cm"))


p2 <- ggplot() +
  geom_sf(data = wintri_outline, fill = "#5BBCD6", color = NA,alpha=0.5)+
  geom_sf(data = grat_wintri, color = "grey", linewidth = 0.15)+
  geom_sf(data = map, size = 0.1, color = "#28282B")+
  # 筛选需要标记的地图
  geom_sf(data = map %>% filter(name %in% c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                                "Czech Rep.","Denmark","Estonia","Finland","France",
                                "Germany","Greece")),
          size = 0.1, color = "#28282B",aes(fill=pop_est),show.legend = F)+
  geom_sf_text(data = labels_x, aes(label = lab), nudge_x = -600000, size = 2) +
  geom_sf_text(data = labels_y, aes(label = lab), nudge_y = -600000, size = 2) +
  scale_fill_gradientn(colours = alpha(RColorBrewer::brewer.pal(6,"RdBu"),0.5))+
  theme_void() +
  labs(x =NULL,y=NULL)+
  theme(plot.margin = margin(0,0.5,0,0.5,unit="cm"))

#-------------------------------------------------------------------------------------------

df1 <- read_tsv("data.xls") %>% filter(type=="Taxonomic richness") %>% 
  select(5:9) %>% 
  group_by(REALM) %>% 
  slice_head(n=1)

df1$REALM <- factor(df1$REALM,levels = c("Nearctic","Palearctic","Indomalayan","Neotropic","Afrotropic","Australasia"))  

plot1 <- df1 %>% ggplot(aes(y = fct_rev(REALM))) +
  theme_bw()+
  geom_errorbarh(aes(xmin=Lower_ci,xmax=Upper_ci),height=0.1) +
  geom_point(aes(x=visregFit,color=REALM),fill="black",size=3,show.legend = F) +
  labs(x="Taxonomic richness",y=NULL)+
  scale_color_npg()+
  theme(axis.ticks.y= element_blank(),
        axis.title.y= element_blank(),
        axis.title.x = element_text(color="black",size=8,face="bold"),
        axis.text.y=element_text(color="black",size=8,face="bold"),
        axis.text.x=element_text(color="black",size=8,face="bold"))


df2 <- read_tsv("data.xls") %>%
  filter(type=="Functional richness") %>% 
  select(5:9) %>% 
  group_by(REALM) %>% 
  slice_head(n=1)

df2$REALM <- factor(df2$REALM,levels = c("Nearctic","Palearctic","Indomalayan","Neotropic","Afrotropic","Australasia"))  

plot2 <- df2 %>% ggplot(aes(y = fct_rev(REALM))) +
  theme_bw()+
  geom_errorbarh(aes(xmin=Lower_ci,xmax=Upper_ci),height=0.1) +
  geom_point(aes(x=visregFit,color=REALM),fill="black",size=3,show.legend = F) +
  labs(x="Functional richness",y=NULL)+
  scale_color_npg()+
  theme(axis.ticks.y= element_blank(),
        axis.title.y= element_blank(),
        axis.title.x = element_text(color="black",size=8,face="bold"),
        axis.text.y=element_text(color="black",size=8,face="bold"),
        axis.text.x=element_text(color="black",size=8,face="bold"))

library(cowplot)

plot <- ggdraw()+  
  draw_plot(p1,scale=0.56,x=-0.25,y=0.24)+
  draw_plot(p2,scale=0.56,x=0.25,y=0.24)+
  draw_plot(plot1,scale=0.45,x=-0.27,y=-0.28)+
  draw_plot(plot2,scale=0.45,x=0.23,y=-0.28)

ggsave(plot,file="map.pdf",width=8.65,height=4.21,unit="in",dpi=300)

  
