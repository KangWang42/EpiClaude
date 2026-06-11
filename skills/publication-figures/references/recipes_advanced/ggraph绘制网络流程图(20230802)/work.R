library(tidyverse)
library(tidygraph)
library(ggraph)
library(ggtext)
library(glue)

df <- read_csv("data.csv")

nodes <- tibble(
  node = c("root", unique(df$category), unique(df$category_continent))) %>% 
  mutate(
    levels = case_when(
      node == "root" ~ 1,
      node %in% unique(df$category) ~ 2,
      node %in% unique(df$category_continent) ~ 3,
      TRUE ~ 4)) %>% 
  left_join(
    count(df, category, continent, name = "number") %>% 
      mutate(category_continent = as.character(glue("{category}_{continent}"))),
    by = c("node" = "category_continent")) %>% 
  mutate(
    continent = factor(continent, levels = c("Africa", "Asia", "Europe", "North\nAmerica", "South\nAmerica", "Oceania")),
    continent = fct_rev(continent)) %>% arrange(levels, category, continent)

edges_level_1 <- df %>% distinct(category) %>% 
  mutate(from = "root") %>% 
  rename(to = category)

edges_level_2 <- df %>%
  distinct(category, category_continent) %>% 
  arrange(category, category_continent) %>%
  select(from = category, to = category_continent)

color_edges <- tibble(
  category = c("Identity", "Knowledge", "Creativity" , "Leadership"),
  color = c("#99B898", "#019875", "#FF847C", "#C0392B")
)

edges <- 
  bind_rows(edges_level_1, edges_level_2) %>% 
  left_join(color_edges, by = c("to" = "category")) %>% 
  left_join(color_edges, by = c("from" = "category")) %>% 
  mutate(color = coalesce(color.x, color.y)) %>% 
  select(-color.x, -color.y)

graph_data <- tbl_graph(nodes, edges)

ggraph(graph_data, layout = "partition") +
  geom_edge_diagonal(aes(color = color), alpha = 0.5) +
  geom_node_text(aes(x = x, y = y, label = continent, filter = levels == 3, color = category), 
                 size = 3,hjust = 1, vjust = 0.5, lineheight = 0.9) +
  geom_node_text(aes(label = node, filter = levels == 2, color = node),
                 size =3,vjust = 0.5, hjust=0.5,fontface = "bold") +
  geom_node_point(aes(filter = levels == 2, color = node), size = 3, alpha = 0.40) +
  geom_node_point(aes(filter = levels == 2, color = node), size = 3, shape = 1) +
  geom_node_range(aes(y = y + 0.02, yend = y + 1.5 * number/max(nodes$number, na.rm = TRUE), 
                      x = x, xend = x, filter = levels == 3, color = category), size = 3) +
  geom_node_text(aes(x = x, y = y + 1.5 * number/max(nodes$number, na.rm = TRUE),
                     label = number, filter = levels == 3, color = category), nudge_y = 0.025, size = 3,
                 fontface = "bold", hjust = 0, vjust = 0.5) +
  scale_color_manual(values = c("Identity" = "#99B898", "Knowledge" = "#019875", "Creativity" = "#FF847C", "Leadership" = "#C0392B")) +
  scale_edge_color_identity() +
  coord_flip() +
  theme(plot.margin = margin(10,10,10,10),
    panel.background = element_rect(fill = "white", color = "white"),
    legend.position = "none") 

