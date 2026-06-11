library(tidyverse)
library(ggtext)
library(showtext)
showtext_auto(enable = TRUE)

# https://www.fileformat.info/info/unicode/char/search.htm


scurvy2 <- read_tsv("data.xls") %>% 
  mutate(Frequency = str_replace(Frequency, "times", "times \n"))

ggplot(scurvy2, aes(x = Patient, y = Parameter)) +
    geom_tile(data = scurvy2, aes(fill = Value, height = 0.80, width = 0.8))+
    geom_point(data = scurvy2 |> filter(Parameter == "Fit for duty?" & Value == "Yes"),
               shape = "\u002B", size = 8, color = "#A88AD2") +
    geom_point(data = scurvy2 |> filter(Parameter == "Fit for duty?" & Value == "No"),
               shape = "\u2716", size = 8, color = "#60627C") +
    geom_text(aes(label = ifelse(Patient == "1", Frequency, NA), y = 6, x = 1.5), 
              size = 3, hjust = 0.5, check_overlap = TRUE,color = "black") +
    expand_limits(y = 6.5, x = c(-0.2, 1.5)) +
    facet_grid(. ~ Regimen,labeller = label_wrap_gen(16))+
    scale_fill_manual(values = c("#788FCE","#E6956F","#A6BA96","#BD8184", NA, NA), 
                      na.value = NA, breaks = c("None", "Mild", "Moderate", "Severe")) + 
    theme_classic()+
    theme(axis.title = element_blank(), 
        axis.ticks.x = element_blank(), 
        axis.text.x = element_blank(),
        panel.spacing.x = unit(0,"cm"),
        strip.text = element_text(color="black",size=8,face="bold"),
        legend.background = element_rect(fill = "white", color = NA), 
        axis.text.y = element_text(size =9, color = "black",face="bold"),
        legend.text = element_text(size =9,color="black"), 
        legend.title = element_blank())

