knit <- function(x, max_yard_r, ymax) {
  expand.grid(x = (2 * x - 1):(2 * x) + 0.7 * x - 1, y = max_yard_r - 1:ymax) %>% 
    mutate(scale_p = 0.5, tiles = "dl") %>%
    st_truchet_ms() %>% 
    st_truchet_dissolve()
}