remotes::install_local("eyedroppeR-main.zip",upgrade = F,dependencies = T)

library(eyedroppeR)

path <- "sunset-south-coast.jpg"
extract_pal(5, path, label = "Caye Caulker, Belize", sort = "auto")


path <- "heatmap.png"
extract_pal(10, path, label = "heatmap", sort = "auto")


path <- "cc7ec3a7-5891-4fd8-a8a8-4aafb5bbca0e.png"
extract_pal(12, path, label = "heatmap", sort = "auto")

