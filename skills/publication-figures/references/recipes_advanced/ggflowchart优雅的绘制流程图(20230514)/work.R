# install.packages("ggflowchart")
library(tidyverse)
library(ggflowchart)

data <- tibble::tibble(from = c("A", "A", "A", "B", "C", "F"),
                       to = c("B", "C", "D", "E", "F", "G"))

ggflowchart(data)

ggflowchart(data,
            colour = "black",
            text_colour = "red",
            arrow_colour = "blue",
            family = "serif",
            x_nudge = 0.25)

node_data <- tibble::tibble(
  name = c("A", "B", "C", "D", "E", "F", "G"),
  type = c("Type 1", "Type 1", "Type 1", "Type 1", 
           "Type 2", "Type 2", "Type 2")
)

ggflowchart(data, node_data, fill = type)



goldilocks <- tibble::tibble(
  from = c(
    "Goldilocks",
    "Porridge", "Porridge", "Porridge",
    "Just right",
    "Chairs", "Chairs", "Chairs",
    "Just right2",
    "Beds", "Beds", "Beds",
    "Just right3"
  ),
  to = c(
    "Porridge",
    "Too cold", "Too hot", "Just right",
    "Chairs",
    "Still too big", "Too big", "Just right2",
    "Beds",
    "Too soft", "Too hard", "Just right3",
    "Bears!"
  )
)

node_data <- tibble::tibble(name = c(
  "Goldilocks", "Porridge", "Just right", "Chairs",
  "Just right2", "Beds", "Just right3", "Too cold",
  "Too hot", "Still too big", "Too big", "Too soft",
  "Too hard", "Bears!"
)) %>%
  dplyr::mutate(label = gsub("\\d+$", "", name))

ggflowchart(goldilocks, node_data)

node_data <- node_data %>%
  dplyr::mutate(
    type = c("Character", "Question", "Answer",
             "Question", "Answer", "Question",
             "Answer", "Answer", "Answer",
             "Answer", "Answer", "Answer",
             "Answer", "Character")
  )

ggflowchart(goldilocks, node_data, fill = type)

library(rcartocolor)
ggflowchart(goldilocks,
            node_data,
            fill = type,
            colour = "#585c45",
            text_colour = "#585c45",
            arrow_colour = "#585c45"
) +
  scale_x_reverse() +
  scale_fill_carto_d(palette = "Antique") +
  labs(title = "The Goldilocks Decision Tree") +
  theme(
    legend.position = "none",
    plot.background = element_rect(
      colour = "#f2e4c1",
      fill = "#f2e4c1"
    ),
    plot.title = element_text(
      size = 20,
      hjust = 0.5,
      face = "bold",
      colour = "#585c45"
    )
  )
