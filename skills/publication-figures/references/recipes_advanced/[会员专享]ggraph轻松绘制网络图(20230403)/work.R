pacman::p_load("tidyverse","glue","ggtext","sf","tidygraph","ggraph")

nyc_trees_counts <- read_tsv("data.xls")

flora_palette <- c(
  "#BDA679", "#162231", "#6F7C47", "#8B7356", "#A1B36F", "#6E5542", 
  "#4F5F6F", "#3B191E", "#576148", "#30302E", "#8799A8", "#434318")


gattung_art_connections <- nyc_trees_counts %>% 
  select(from = gattung, to = gattung_art, size = n)

origin_gattung_connections <- data.frame(
  from = "origin",
  to = unique(gattung_art_connections$from))

edges <- bind_rows(gattung_art_connections, origin_gattung_connections) %>% 
  tibble()

nodes <- distinct(edges, name = to, group = from, size) %>% 
  mutate(
    is_main = group == "origin",
    label = ifelse(is_main | size > 1000, name, NA)) %>% 
  add_row(name = "origin", is_main = FALSE) %>% 
  arrange(group, name)

nodes$id <- NA
is_leaf <- nodes$group != "origin" & nodes$name != "origin"
is_leaf <- nodes$group != "origin" & nodes$name != "origin"
nleaves <- nrow(nodes[is_leaf, ])
nodes$id[is_leaf] <- seq_len(nleaves)
nodes$angle <- 90 - 360 * nodes$id / nleaves

nodes$hjust <- ifelse(nodes$angle < -90, 1, 0)

nodes$angle <- ifelse(nodes$angle < -90, nodes$angle + 180, nodes$angle)
nodes <- nodes %>% 
  mutate(angle = replace_na(angle, 0),
         hjust = replace_na(hjust, 0)
  )

graph <- igraph::graph_from_data_frame(edges, vertices = nodes)

plot <- ggraph(graph, layout = "dendrogram", circular = TRUE) +
  geom_edge_diagonal(color = "grey70", edge_width = 0.33) +
  geom_node_point(
    aes(fill = group, size = size), 
    shape = 21, color = "white", stroke = 0.2, alpha = 0.8,
    show.legend = TRUE) +
  geom_node_text(
    aes(filter = !is_main, label = label, angle = angle, hjust = hjust,
        fontface = ifelse(is_main, "bold", "plain")),
    size = 3.5) +
  geom_node_text(
    aes(filter = is_main, label = label, angle = angle, hjust = hjust,
        fontface = "bold"),size = 3.5, repel = TRUE) +
  scale_edge_color_manual(values = c(flora_palette, "grey40", "grey80")) +
  scale_fill_manual(values = c(flora_palette, "grey40", "grey80")) +
  scale_size_area(max_size =20) +
  coord_fixed(clip = "off") +
  guides( color = "none", fill = "none",
    size = guide_legend(override.aes = list(color = "grey50"))) +
  theme_void() +
  theme(
    plot.background = element_rect(color = "white", fill = "white"),
    plot.margin = margin(t = 100, r = 100,b = 100, l = 100),
    legend.position ="non")

plot
ggsave(plot,file="plot.pdf",width=12,height=12,unit="in",dpi=300)
