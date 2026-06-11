library(tidyverse)
library(grid)
library(pBrackets)

testmap <- tribble(
  ~Models, ~Group, ~Brands, ~Presence, ~Country,
  "Xperia Z5", "A", "Sony", 1, "Japan",
  "Galaxy S20", "A", "Samsung", 1, "Korea",
  "Xperia XZ", "B", "Sony", 1, "Japan",
  "Galaxy Note FE", "B", "Samsung", 0, "Korea",
  "Nord","A", "OnePlus",1,"China")

ggplot(testmap, aes(x=Country, y=Models, fill=Presence))+
  geom_tile() + xlab(label="Country")+ ylab(label="Models\n\n")+
  scale_fill_gradient(name="Presence of Models", low="white",high="black")+
  theme_bw() + theme(legend.position="none")


grid.locator(unit = "native")

grid.brackets(60, 134, 60, 32, type = 1)
grid.brackets(60, 233, 60, 157, type = 1)
grid.brackets(60, 353, 60, 247, type = 1)


df <- read_tsv("F1.xls") %>% pivot_longer(-Sample)

ddf <- df %>% filter(name %in% c("IFNG","TBX21","CD8A","CD8B","IL12B",
                          "STAT1","IRF1","CXCL9","CXCL10","CCL5","GNLY","PRF1","GZMA",
                          "GZMB","GZMH","CD274","CTLA4","FOXP3","IDO1","PDCD1"))


ddf$name <- factor(ddf$name,levels = rev(c("IFNG","TBX21","CD8A","CD8B","IL12B",
                                       "STAT1","IRF1","CXCL9","CXCL10","CCL5","GNLY","PRF1","GZMA",
                                       "GZMB","GZMH","CD274","CTLA4","FOXP3","IDO1","PDCD1")))

ddf %>% ggplot(aes(Sample,name,fill=value))+ geom_tile()+
  scale_fill_gradientn(colours = (RColorBrewer::brewer.pal(11,"RdBu")))+
  theme(axis.text.x=element_blank(),
        axis.ticks=element_blank(),
        axis.text.y=element_text(color="black",size=8),
        legend.background = element_blank(),
        legend.title = element_blank())+
  labs(x=NULL,y="\n\n\n\n\n")+
  guides(fill=guide_colorbar(direction="vertical",reverse=F,barwidth=unit(.5,"cm"),
                              barheight=unit(9,"cm")))


grid.locator(unit="native")

# add bracket to plot area
grid.brackets(130,130,130,20,lwd=1, ticks=NA, type = 4)
grid.brackets(130,200,130,140,lwd=1, ticks=NA, type = 4)
grid.brackets(130,310,130,220, lwd=1, ticks=NA, type = 4)
grid.brackets(130,420,130,320, lwd=1, ticks=NA, type = 4)

grid.text(x=unit(32,'native'), y=unit(90,'native'),
          label=expression(paste('TH1 cell\nsignaling'),'type=4',size=5),
          gp=gpar(fontsize=10,col="black"),hjust = 0, vjust=0)

grid.text(x=unit(30,'native'), y=unit(170,'native'),
          label=expression(paste('CXCR3\nCCR5'),'type=4',size=5),
          gp=gpar(fontsize=10,col="black"),hjust = 0, vjust=0)

grid.text(x=unit(30,'native'), y=unit(270,'native'),
          label=expression(paste('Effector\nfunctions'),'type=4',size=5),
          gp=gpar(fontsize=10,col="black"),hjust = 0, vjust=0)

grid.text(x=unit(22,'native'), y=unit(370,'native'),
          label=expression(paste('Immune\nregulatory'),'type=4'),
          gp=gpar(fontsize=10,col="red"),hjust = 0, vjust=0)



