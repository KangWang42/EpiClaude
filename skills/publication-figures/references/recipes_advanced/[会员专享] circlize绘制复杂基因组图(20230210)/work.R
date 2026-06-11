library(tidyverse)
library(circlize) 
library(ComplexHeatmap)

circos.clear()

bed <- read_tsv("bed.txt",col_names = F) %>% 
  separate(`X2`,into=c("chr","start"),sep=":") %>%
  separate(`start`,into=c("start","end"),sep="-") %>% 
  dplyr::rename(geneID="X1") %>% 
  mutate(start=as.numeric(start),end=as.numeric(end)) %>% select(2,3,4,1)

circos.par(gap.after = c(rep(1,23),80), start.degree = 90)

circos.initializeWithIdeogram(plotType = NULL)

circos.genomicLabels(bed,labels.column = 4,side = "outside",
                     connection_height=0.1,labels.side = side)

set_track_gap(mm_h(1))

ko_color <- c(rep('#FDDBC7',10), rep('#D1E5F0', 12), rep('#92C5DE', 2))

circos.trackPlotRegion(ylim = c(0,0.1),track.height = 0.05,bg.border="black",
                       bg.col=ko_color,
                       panel.fun = function(x, y) {
  xlim = CELL_META$xlim
  ylim = CELL_META$ylim
  })

circos.genomicIdeogram(track.height = mm_h(3))

load(system.file(package = "circlize", "extdata", "DMR.RData"))
bed_list = list(DMR_hyper, DMR_hypo)
circos.genomicRainfall(bed_list, pch = 16,cex=0.1,track.height=0.06,col = c("#FF000080", "#0000FF80"))
circos.genomicDensity(DMR_hyper,col = c("#FF000080"),track.height=0.05,bg.border="white")

bed = generateRandomBed(nr = 100, nc = 4)

col_fun <- colorRamp2(c(-1,-0.5,0,0.5,1),
                      c("#F4A582","#FDDBC7","#F7F7F7","#D1E5F0","#92C5DE"))

circos.genomicHeatmap(bed,col = col_fun, side = "inside",connection_height=NULL)

# circos.track(track.index = get.current.track.index(), panel.fun = function(x, y) {
#  if(CELL_META$sector.numeric.index == 5) { # the last sector
#    cn = colnames(bed %>% select(4:7))
#    n = length(cn)
  #  circos.text(rep(CELL_META$cell.xlim[2], n) + convert_x(1, "mm"), 
    #            1:n - 0.5, cn, 
    #            cex = 0.6, adj = c(2,43), facing = "inside")
#  }
# }, bg.border = NA)

region1 <- read_tsv("data-1.txt",col_names = F) %>%
  separate(`X2`,into=c("chr","start"),sep=":") %>%
  separate(`start`,into=c("start","end"),sep="-") %>% select(-1) %>% 
  mutate(start=as.numeric(start),end=as.numeric(end))

region2 <- read_tsv("data-2.txt",col_names = F) %>% 
  separate(`X2`,into=c("chr","start"),sep=":") %>%
  separate(`start`,into=c("start","end"),sep="-") %>% select(-1) %>% 
  mutate(start=as.numeric(start),end=as.numeric(end))

circos.genomicLink(region1 %>% head(6),region2 %>% head(6),col="#3B9AB2")
circos.genomicLink(region1 %>% tail(4),region2 %>% tail(4),col="#F21A00")

lgd = Legend(labels = c("TGFb Family","TNF Family","Other cytokines"),
             legend_gp = gpar(fill=c("#FDDBC7","#D1E5F0","#92C5DE")),
             grid_width = unit(8,"mm"),grid_height=unit(5,"mm"))

draw(lgd,x = unit(0.4,"npc"),y = unit(0.8,"npc"),just = c("right","top"))


circos.clear()




