library(tidyverse)
library(scales)
library(patchwork)
library(ggsci)


df1 <- read_tsv("data1.xls")
df1$type2 <- factor(df1$type2,levels = df1$type2 %>% rev())

plot1 <- df1 %>% ggplot(aes(axis_label, total)) +
  geom_col(aes(fill = type2), width = 1) +
  geom_text(aes(x =0.2, y = textx , label = type2), hjust = 1,vjust=1,size = 3) +
  scale_fill_npg()+
  scale_x_discrete(expand = expansion(mult = c(5, 0))) +
  scale_y_continuous(limits = c(0,700000))+
  guides(fill = FALSE) +
  theme_void()+
  theme(axis.text.x = element_text(color="black",face="bold",size = 10))

poly <- tibble(x = c(0, 2, 2, 0),
               y = c(393153, 0, 560000, 506811))

zoom <-  ggplot() +
  geom_polygon(data = poly, aes(x, y), fill = "#41CFA0", alpha = 0.3) +
  annotate("segment", x = 0, xend = 2, y = 393153, yend = 0, color = "#41CFA0") +
  annotate("segment", x = 0, xend = 2, y = 506811, yend = 560000, color = "#41CFA0") +
  scale_y_continuous(limits = c(0, 700000))+
  scale_x_continuous(expand = expansion(mult = c(0, 0))) +
  guides(fill = FALSE) +
  theme_void()

df2 <- read_tsv("data2.xls")

df2$type <- factor(df2$type,levels = df2$type %>% rev())  
  
plot2 <- df2 %>% ggplot(aes(axis_label, production)) +
  geom_col(aes(fill = type), width = 1) +
  geom_segment(aes(x = 1.5, xend = 2, y = posy, yend = posy), size = 0.3) +
  geom_segment(aes(x = 2, xend = 2.3, y = posy, yend = posyend), linetype = "12", size = 0.3) +
  geom_segment(aes(x = 2.3, xend = 4, y = posyend, yend = posyend), linetype = "12", size = 0.3) +
  geom_text(aes(x = 4.1, y = posyend, label = label), hjust = 0, size = 3) +
  geom_text(aes(x = 2.4, y = textx, label = type), hjust = 0, size = 3) +
  scale_fill_jama() +
  scale_x_discrete(expand = expansion(mult = c(0, 5))) +
  guides(fill = FALSE) +
  theme_void()+
  theme(axis.text.x = element_text(color = "#183170", size = 10))

plot1 + zoom + plot2+
  plot_layout(ncol = 3, width = c(5, 2, 5)) 

