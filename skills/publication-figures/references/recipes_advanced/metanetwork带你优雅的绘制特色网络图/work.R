library(tidyverse)
library(devtools)
install.packages("metanetwork")
install_github("MarcOhlmann/metanetwork")
library(metanetwork)
library(igraph)
library(ggimage)

data("meta_angola")
ggmetanet(meta_angola,beta = 0.05,legend = "Phylum")

#-------------------------------------------------------------------------------
data("meta_vrtb")

beta = 0.005
ggnet.custom = ggnet.default
ggnet.custom$label = T
ggnet.custom$edge.alpha = 0.5
ggnet.custom$alpha = 0.7
ggnet.custom$arrow.size = 1
ggnet.custom$max_size = 12

net_groups <-  ggmetanet(meta_vrtb,g = meta_vrtb$metaweb_group,flip_coords = T,
                       beta = beta,legend = "group",
                       ggnet.config = ggnet.custom,edge_thrs = 0.1)
net_groups
#------------------------------------------------------------------------------
beta = 0.005
ggnet.custom = ggnet.default
ggnet.custom$label = F
ggnet.custom$edge.alpha = 0.02
ggnet.custom$alpha = 0.7
ggnet.custom$arrow.size = 1
ggnet.custom$max_size = 3
ggnet.custom$palette = "Set2"

net_group_layout <- ggmetanet(meta_vrtb,flip_coords = T,mode = "group-TL-tsne",
                             beta = beta,legend = "group",ggnet.config = ggnet.custom)

net_group_layout
#------------------------------------------------------------------------------
beta = 0.005
mammals_names = names(which(meta_vrtb$trophicTable[,"Class"] == "Mammal"))
ggnet.custom$label = F
ggnet.custom$label.size = 2
net_mammals = ggmetanet(meta_vrtb,flip_coords = T,mode = "group-TL-tsne",
                        beta = beta,legend = "group",ggnet.config = ggnet.custom,
                        alpha_per_node = list(nodes = mammals_names,
                                              alpha_focal = 0.7,
                                              alpha_hidden = 0.1))+
  ggtitle("Mammals")

net_mammals
