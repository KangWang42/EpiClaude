# install.packages("mapdata_2.2-6.tar.gz",repos = NULL)
library(mapdata)
library(viridis)
library(phytools)
library(tidyverse)
library(RColorBrewer)
library(ggtree)

# 案例一
load("World.Rdata")

obj<-phylo.to.map(World.tree,World,plot=FALSE)

nb.cols <- 20
cols <- colorRampPalette(brewer.pal(8, "Set3"))(nb.cols)
names(cols) <- World.tree$tip.label

plot(obj,colors=cols,ftype="i",fsize=0.62,cex.points=c(0.7,1.2))

# 案例二
load("data.Rdata")
obj <- phylo.to.map(canada.tree,canada,database="worldHires",
                    regions="canada",plot=F)

cols <-setNames(sample(viridis(n=Ntip(canada.tree))),
                canada.tree$tip.label)
plot(obj,
    # direction="rightwards",
     colors=cols,ftype="i",fsize=0.65,
     cex.points=c(0.7,1.2),pts=F,lwd=c(3,1))


# 导入外部数据

tree <- read.tree("word.newick")
ggtree(tree)+ geom_tiplab(offset=4) +xlim(NA,150)

World2 <- read_tsv("data.xls") %>% 
  separate(`sample`,into="sample",sep="\\.") %>% 
  group_by(sample) %>% 
  slice_head(n=1) %>% ungroup() %>% column_to_rownames(var="sample")

obj <- phylo.to.map(tree,World2,plot=FALSE)

nb.cols <- 20
cols2 <- colorRampPalette(brewer.pal(8,"Set1"))(nb.cols)
names(cols2) <- tree$tip.label


cols2 <-setNames(sample(viridis(n=Ntip(tree))),tree$tip.label)


plot(obj,colors=cols2,
     ftype="i",
     fsize=0.65,
     cex.points=c(0.7,1.2),pts=F,lwd=c(2,1))




