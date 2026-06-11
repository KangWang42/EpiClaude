library(tidyverse)
library(igraph)
library(ggraph)
library(graphlayouts)
library(ggforce)
library(scatterpie)
library(ggsci)

set.seed(1439)
g <- sample_pa(20, 1)
V(g)$A <- abs(rnorm(20, sd = 1))
V(g)$B <- abs(rnorm(20, sd = 2))
V(g)$C <- abs(rnorm(20, sd = 3))

xy <- layout_with_stress(g)
V(g)$x <- xy[, 1]
V(g)$y <- xy[, 2]

ggraph(g, "manual", x = V(g)$x, y = V(g)$y) +
  geom_edge_link0() +
  geom_scatterpie(cols = c("A", "B", "C"),
    data = as_data_frame(g, "vertices"),
    colour = NA,pie_scale = 2) +
  coord_fixed() +
  theme_graph() +
  theme(legend.position = "bottom")

g <- sample_islands(9, 40, 0.4, 15)
g <- igraph::simplify(g)
V(g)$grp <- as.character(rep(1:9, each = 40))
V(g)$cat <- sample(c("A", "B", "C"), vcount(g), replace = T)

g_clu <- contract(g, V(g)$grp, vertex.attr.comb = "concat")
E(g_clu)$weight <- 1
g_clu <- simplify(g_clu, edge.attr.comb = "sum")

V(g_clu)$A <- sapply(V(g_clu)$cat, function(x)
  sum(x == "A"))
V(g_clu)$B <- sapply(V(g_clu)$cat, function(x)
  sum(x == "B"))
V(g_clu)$C <- sapply(V(g_clu)$cat, function(x)
  sum(x == "C"))

xy <- layout_with_stress(g_clu)
V(g_clu)$x <- xy[, 1]
V(g_clu)$y <- xy[, 2]

ggraph(g_clu, "manual", x = V(g_clu)$x, y = V(g_clu)$y) +
  geom_edge_link0() +
  geom_scatterpie(cols = c("A", "B", "C"),
    data = as_data_frame(g_clu, "vertices"),
    colour = "white",pie_scale = 3) +
  scale_fill_npg()+
  coord_fixed() +
  theme_graph() +
  theme(legend.position = "bottom")
