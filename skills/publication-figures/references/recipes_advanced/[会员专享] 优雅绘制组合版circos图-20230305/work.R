library(tidyverse)
library(circlize)
library(ggplotify)
library(grid)
library(cowplot)
library(patchwork)

df1 <- read_csv("loadouts.txt") %>% select(4,6) %>% 
  group_by(item) %>% count() %>% arrange(desc(n))
df1$item <- factor(df1$item,levels = df1$item %>% rev())
  
p1 <- df1 %>% ggplot(aes(n,item)) +
  geom_segment(aes(x=0, xend=n, y=item, yend=item))+
  geom_point( size=5, color="#92C5DE", fill="#92C5DE",shape=21, stroke=2)+
  scale_fill_gradient2(low = "#D12424", mid = "white", high = "#f28bd5") + #定义点填充颜色
  scale_color_manual(values = c("black", "black")) + # 设置字体颜色
  theme_minimal() + # 主题设置
  labs(x=NULL,y=NULL)+
  theme(legend.position = "none",
        text = element_text(color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text = element_text(color="grey20",size=10,face="bold"),
        axis.line.x = element_line(arrow = arrow(length = unit(.3, "cm"), ends = "both"),
                                   color = "black")) 

df <- read_csv("loadouts.txt") %>% select(2,6) %>% mutate(col="grey")

name <- df$col %>% head(27)
names(name) <- df$item %>% unique()

circos.par(canvas.xlim=c(-1,1),canvas.ylim=c(-1,1),start.degree =-90)

grid.col=c(`1`="#B2182B",`2`="#D6604D",`3`="#F4A582",`4`="#FDDBC7",
           `5`="#F7F7F7",`6`="#D1E5F0",`7`="#92C5DE",`8`="#4393C3",`9`="#2166AC",name)

set.seed(1234)
chordDiagram(df,grid.col=grid.col, 
             link.decreasing = TRUE, transparency = 0.1, 
             big.gap = 60,
             ink.sort = FALSE,annotationTrack = "grid",
             preAllocateTracks = list(track.height = .1))

for(si in get.all.sector.index()) {
  xlim = get.cell.meta.data("xlim",sector.index = si,track.index = 1)
  ylim = get.cell.meta.data("ylim",sector.index = si,track.index = 1)
  circos.text(mean(xlim), ylim[1],labels = si,sector.index = si,track.index = 1, 
              facing = "clockwise", cex=0.6,adj=c(0,.5),niceFacing = T)
}

circos.clear()

p2 <- recordPlot()
p3 <- as.ggplot(ggdraw(p2))

ggdraw()+  
  draw_plot(p3,scale=0.7,x=0.2,y=0)+
  draw_plot(p1,scale=0.7,height=1.2,width=0.5,x=-0.06,y=-0.1)

ggsave(plot,file="plot.pdf",width=10.93,height=8.75,unit="in",dpi=300)

