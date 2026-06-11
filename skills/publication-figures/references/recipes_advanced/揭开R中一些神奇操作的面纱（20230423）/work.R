library(tidyverse)
library(ggforce)
library(ggbeeswarm)
library(ggtext)
# install.packages("palmerpenguins")
library(palmerpenguins)

histogram <- gss_cat %>% 
  nest(data=-marital) %>% 
  mutate(histogram=pmap(
    .l=list(marital,data),
    .f=\(marital,data){
      ggplot(data,aes(x=tvhours))+
        geom_histogram(binwidth = 1)+
        labs(title=marital)
    }
  )
)

histogram %>% class()


histogram$histogram[1]


Species <- iris %>% 
  nest(data=-Species) %>% 
  mutate(Species=pmap(
    .l=list(Species,data),
    .f=\(Species,data){
      ggplot(data,aes(x=Petal.Length,y=Sepal.Width,fill=Species))+
        geom_point(size=4,pch=21,color="purple",fill="grey90")+
        labs(title=Species)+
        theme_bw()
    }
  )
  )



Species$Species[3]




Species <- penguins %>% 
  pivot_longer(cols = bill_length_mm:body_mass_g) %>% 
  mutate(species = factor(species, levels = c("Chinstrap", "Gentoo", "Adelie"))) %>% 
  select(1,5,6)

color_scale <- c("Adelie" = "darkorange", "Chinstrap" = "purple","Gentoo" = "cyan4")


species <- Species %>% 
  nest(data = -name) %>% 
  mutate(name = pmap(
    .l = list(name, data),
    .f = \(name, data) {
      ggplot(data, aes(species, value, color = species)) +
        geom_violin(aes(fill = species), alpha = 0.40) +
        geom_beeswarm() +
        scale_color_manual(values = color_scale) +
        scale_fill_manual(values = color_scale) +
        theme_bw() +
        labs(x=NULL,y=NULL)+
        theme(legend.position = "none",
              axis.text = element_text(color = "black",face="bold"),
              plot.margin = margin(5, 5, 5, 5),
              panel.spacing = unit(0.2, "lines"),
              panel.background = element_rect(color = "black", fill = NA))
    }
  )
  )


species$name[1]

species$name[2]

