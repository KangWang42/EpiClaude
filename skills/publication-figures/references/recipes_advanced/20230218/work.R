library(tidyverse)

# devtools::install_github("doehm/cropcircles")
# install.packages("cropcircles")

library(cropcircles)
library(dplyr)
library(ggimage)
library(magick)

img_path <- file.path(system.file(package = "cropcircles"), "images", "walter-jesse.png")
orig <- image_read(img_path)

center <- image_read(circle_crop(img_path, border_size = 4))
left <- image_read(circle_crop(img_path, border_size = 4, just = "left"))

right <- image_read(circle_crop(img_path, border_size = 4, just = "right"))

image_montage(c(orig, center, left, right))






plot <- image_read("1.jpg")
plot1 <- image_scale(plot, "x500") 

image_write(plot1, path = "plot1.png", format = "png")

plot2 <- image_read(circle_crop("plot1.png", border_size = 5,just = "top",border_colour="#788CAE"))

image_write(plot2, path = "plot2.png", format = "png")






