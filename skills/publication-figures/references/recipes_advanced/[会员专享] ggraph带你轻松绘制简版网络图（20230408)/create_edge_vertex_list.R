create_edge_vertex_list <-
function(df) {
  edge_list1 <- df %>% 
    select(taxonomic_group, nc_status) %>% 
    unique %>% 
    rename(from = taxonomic_group, to = nc_status) %>% 
    mutate(color = to)
  
  edge_list2 <- df %>% 
    select(nc_status, common_name) %>% 
    unique %>% 
    rename(from = nc_status, to = common_name) %>% 
    mutate(color = from)
  
  edge_list = rbind(edge_list1, edge_list2)
  
  vertices <- data.frame(
    name = unique(c(as.character(edge_list$from), as.character(edge_list$to))), 
    value = runif(57))
  
  vertices$group = edge_list$from[match(vertices$name, edge_list$to, edge_list$color)] %>% 
    replace_na("none")
  
  return(list(edge_list = edge_list, vertices = vertices))
}
