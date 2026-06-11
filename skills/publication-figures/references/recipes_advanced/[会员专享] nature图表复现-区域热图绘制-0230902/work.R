install.packages("ggmagnify", repos = c("https://hughjonesd.r-universe.dev", 
                                        "https://cloud.r-project.org"))
library(tidyverse)
library(readxl)
library(magrittr)
library(ggtree)
library(ggmagnify)
library(grid)
library(patchwork)

df <- read_excel("F1.xlsx", sheet = "Fig 1c KEGG module") %>% 
  column_to_rownames(var="...1")

hc <- hclust(dist(t(df))) %>% ggtree() + layout_dendrogram()+
  theme_void()

df2 <- df %>% rownames_to_column(var="ID") %>% 
  pivot_longer(-1) %>% 
  set_colnames(c("ID","name","value"))


heatmap <- df2 %>% 
  ggplot(aes(name,ID,fill=value))+
  geom_tile()+
  labs(x=NULL,y=NULL)+
  scale_y_discrete(expand=c(0,0),position="left",breaks=c("M00001","M00002","M00015",
                                                          "M00028","M00032","M00038",
                                                          "M00044","M00060"))+
  scale_x_discrete(expand=c(0,0))+
  scale_fill_gradientn(colours = rev(RColorBrewer::brewer.pal(11,"RdBu")))+
  coord_cartesian(clip = "off") + 
  theme(axis.text.x=element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        legend.background = element_blank(),
        legend.text = element_text(size=8,color="black"),
        legend.position =c(1.2,0.8),
        plot.margin = ggplot2::margin(10,150, 10,1))

from3 <-  c(2,20,1,8)
to3 <- c(150,210,10,25)

p <- heatmap + 
  geom_magnify(from = from3, to = to3, axes = "y") +
  theme(axis.text.y=element_text(color="white"))


(hc/p)+plot_layout(ncol=1,height =c(0.35,1))+
  coord_cartesian(clip="off")+
  annotation_custom(grob=rectGrob(gp=gpar(col="#BDE7FF",fill="#BDE7FF")),
                    xmin=unit(0.3,"native"),xmax=unit(53,"native"),
                    ymin=unit(44,"native"),ymax=unit(46,"native"))+
  annotation_custom(grob=rectGrob(gp=gpar(col="#FFF2E7",fill="#FFF2E7")),
                    xmin=unit(53.5,"native"),xmax=unit(136,"native"),
                    ymin=unit(44,"native"),ymax=unit(46,"native"))+
  annotation_custom(grob = grid::textGrob(label = "COPD",hjust=0,
                                          gp=gpar(col="black",cex=1)),
                    xmin=20,xmax=30,ymin=44,ymax=46)+
  annotation_custom(grob = grid::textGrob(label = "Healthy",hjust=0,
                                          gp=gpar(col="black",cex=1)),
                    xmin=85,xmax=95,ymin=44,ymax=46)
