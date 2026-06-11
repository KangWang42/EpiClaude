library(tidyverse)
library(ggh4x)
library(patchwork)
library(readxl)
library(scales)

df1 <- read_excel("data.xlsx") %>% select(1,3:8) %>% 
  head(1000) %>% 
  mutate_if(is.numeric,function(x) x+1) %>% 
  column_to_rownames(var="Name") %>% 
  log10() %>% as.data.frame()

group <- read_tsv("group.xls")

p1 <- df1 %>% rownames_to_column(var="Name") %>% 
  pivot_longer(-Name) %>% 
  left_join(.,group,by=c("name"="sample")) %>% 
  ggplot(aes(interaction(name,group),Name,fill=value,color=value))+
  geom_tile()+
  guides(x="axis_nested")+
  labs(x=NULL,y=NULL)+
  scale_color_gradientn(colours = (RColorBrewer::brewer.pal(11,"RdBu")))+
  scale_fill_gradientn(colours = (RColorBrewer::brewer.pal(11,"RdBu")))+
  scale_x_discrete(expand = c(0,0),position = 'top',labels = wrap_format(5))+
  theme(axis.text.x=element_text(color="black",angle = 90,vjust=0.5,hjust=0.5,size=8,face="bold"),
        plot.margin = unit(c(0,1.2,0.3,0.5),units="cm"),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        legend.background = element_blank(),
        legend.title = element_blank(),
        legend.position = c(1.13,0.5),
        ggh4x.axis.nestline.x = element_line(size=0.5),
        ggh4x.axis.nesttext.x = element_text(colour = "black",angle =0,size=10,face="bold",
                                             vjust=0,hjust=0.5,
                                             margin = margin(t =10,b=3)))+
  guides(color=guide_colorbar(direction="vertical",reverse=F,barwidth=unit(.5,"cm"),
                              barheight=unit(11,"cm")))


highlight <- c("A1BG","AC018638.5","C1orf43")

p2 <- read_excel("data.xlsx") %>% select(1,log2FoldChange) %>% head(1000) %>% 
  mutate(group="log2FC") %>% 
  ggplot(aes(group,Name,fill=log2FoldChange))+
  geom_raster() +
  guides(y.sec = guide_axis_manual(breaks = highlight,labels = highlight,color="red"))+
  labs(x=NULL,y=NULL)+
  scale_color_gradientn(colours = (RColorBrewer::brewer.pal(8,"RdBu")))+
  scale_fill_gradientn(colours = (RColorBrewer::brewer.pal(8,"RdBu")))+
  scale_y_dendrogram(labels = NULL) +
  theme(axis.text.x=element_text(color="black",angle = 0,vjust=0.5,hjust=0.5,size=8,face="bold"),
        axis.ticks.y=element_blank(),
        legend.background=element_blank(),
        legend.title = element_blank(),
        legend.key = element_blank(),
        legend.position = c(2,0.5),
        legend.spacing.x = unit(0.1,"cm"))


(p1+p2)+plot_layout(widths = c(2,0.3))




