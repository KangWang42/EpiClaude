process_data <-
function(data) {
  df <- data %>% 
    clean_names() %>%
    group_by(taxonomic_group, common_name) %>%
    count(nc_status) %>%
    ungroup() %>%
    group_by(nc_status)
  
  return(df)
}
