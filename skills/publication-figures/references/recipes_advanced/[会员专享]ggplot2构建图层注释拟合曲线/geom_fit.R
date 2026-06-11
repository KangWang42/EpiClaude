geom_fit <- function(data, x_var, y_var, group_var = NULL,
                     label_positions = NULL,
                     label_colors = NULL,
                     label_size = 3, digits = 3,
                     se = NULL, r_square = FALSE) {
  
  layers <- list()
  
  if (!is.null(group_var)) {
    group_colors <- unique(data[[group_var]])
    color_map <- setNames(rainbow(length(group_colors)), group_colors)
    data_by_group <- split(data, data[[group_var]])
    for (group_data in data_by_group) {
      if (nrow(group_data) <= 1) {
        next
      }
      group_name <- as.character(unique(group_data[[group_var]]))
      fit <- lm(formula(paste(y_var, "~", x_var)), data = group_data)
      r_value <- cor(group_data[[x_var]], group_data[[y_var]])
      r_square_value <- r_value^2
      p_value <- summary(fit)$coefficients[2, 4]
      stars <- if (p_value < 0.001) {
        "***"
      } else if (p_value < 0.01) {
        "**"
      } else if (p_value < 0.05) {
        "*"
      } else {
        "ns"
      }
      label_color <- if (!is.null(label_colors)) {
        label_colors[group_name]
      } else {
        color_map[group_name]
      }
      label_x <- if (!is.null(label_positions)) {
        label_positions[label_positions$group == group_name, "x"]
      } else {
        min(data[[x_var]])
      }
      label_y <- if (!is.null(label_positions)) {
        label_positions[label_positions$group == group_name, "y"]
      } else {
        max(data[[y_var]])
      }
      
      r_text <- if (r_square) {
        paste("R² =", round(r_square_value, digits))
      } else {
        paste("R =", round(r_value, digits))
      }
      
      layers <- append(layers, list(
        geom_smooth(data = group_data, aes_string(x = x_var, y = y_var),
                    method = "lm", se = se, linetype = "solid", show.legend = F),
        annotate("text",
                 x = label_x,
                 y = label_y,
                 label = paste(r_text, "P =", stars),
                 hjust = 0, vjust = 1, col = label_color, size = label_size)
      ))
    }
  } else {
    layers <- append(layers, list(
      geom_smooth(method = "lm", se = se, linetype = "solid", color = "blue",show.legend = F),
      annotate("text", x = min(data[[x_var]]), y = max(data[[y_var]]),
               label = paste("R =", round(r_value, 3),"P=",stars),
               hjust = 0, vjust = 1)
    ))
  }
  
  return(layers)
}