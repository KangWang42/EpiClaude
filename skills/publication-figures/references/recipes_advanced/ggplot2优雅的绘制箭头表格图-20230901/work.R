
pacman::p_load(tidyverse,ggfittext,ggtext,scales,ggtext)

data <- readr::read_csv('product_hunt.csv')

df <- data %>% select(upvotes, category_tags) %>%
  separate_rows(category_tags, sep = ", ") %>%
  mutate(name_2 = gsub("[^[:alnum:]]", " ",category_tags)) %>%
  mutate(name_2 = trimws(name_2))%>%
  group_by(name_2) %>%
  summarize(total=n()) %>%
  mutate(percentage = total/sum(total),
         percentage=percent(percentage,accuracy = 0.01)) %>%
  top_n(5) %>%
  arrange(desc(total))

df <- df %>% arrange(desc(total)) %>% select(2,1,3) %>%
  mutate(x_axis = rep(5, each = 10, length = n()),
         x_axis_2 = x_axis + 1.2,
         x_axis_3 = x_axis + 2.4,
         y_axis = rep(-1:-10, length = n()))

df$name_2 <- fct_relevel(df$name_2, c("ANDROID","DEVELOPER TOOLS","WEB APP",
                                      "IPHONE","PRODUCTIVITY"))

df %>% ggplot() +
  geom_text(aes(x = x_axis, y = y_axis, label = total), hjust = 0.5, fontface = "bold",
            color = "#000000",  size = 3.5) +
  geom_text(aes(x = x_axis_2, y = y_axis, label = name_2), hjust = 0.5, fontface = "bold",
            color = "#525252",  size = 3) +
  geom_text(aes(x = x_axis_3, y = y_axis, label = percentage), hjust = 0.5,fontface = "bold",
            color = "#ff0000",  size = 3.5) +
  geom_text(aes(x = 5, y = 0.2, label = "Total"), hjust = 0.5, fontface = "plain",
            color = "#000000",  size = 3.5) +
  geom_text(aes(x = 6.2, y = 0.2, label = "Category"), hjust = 0.5, fontface = "plain",
            color = "#525252",  size = 3.5) +
  geom_text(aes(x = 7.4, y = 0.2, label = "% Products \nwith tag"), hjust = 0.5,
            fontface = "plain", color = "#ff0000",  size = 3.5) +
  scale_x_continuous(limits = c(4.5,7.9)) +
  scale_y_continuous(limits = c(-6.55,0.5)) +
#  左侧方框
  geom_segment(aes(x = 4.7, xend = 4.7, y = -5.5, yend = -0.5), color="#000000")+
  geom_segment(aes(x = 4.7, xend = 5.3, y = -5.5, yend = -5.5), color="#000000") +
  geom_segment(aes(x = 4.7, xend = 5.3, y = -4.5, yend = -4.5), color="#000000") +
  geom_segment(aes(x = 4.7, xend = 5.3, y = -3.5, yend = -3.5), color="#000000") +
  geom_segment(aes(x = 4.7, xend = 5.3, y = -2.5, yend = -2.5), color="#000000") +
  geom_segment(aes(x = 4.7, xend = 5.3, y = -1.5, yend = -1.5), color="#000000") +
  geom_segment(aes(x = 4.7, xend = 5.3, y = -0.5, yend = -0.5), color="#000000") +
  # 右侧方框
  geom_segment(aes(x = 7.7, xend = 7.7, y = -5.5, yend = -0.5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 7.7, y = -5.5, yend = -5.5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 7.7, y = -4.5, yend = -4.5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 7.7, y = -3.5, yend = -3.5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 7.7, y = -2.5, yend = -2.5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 7.7, y = -1.5, yend = -1.5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 7.7, y = -0.5, yend = -0.5), color="#ff0000") +
# 左箭头
  geom_segment(aes(x = 5.3, xend = 5.5, y = -5.5, yend = -5), color="#000000") +
  geom_segment(aes(x = 5.3, xend = 5.5, y = -4.5, yend = -5), color="#000000") +
  geom_segment(aes(x = 5.5, xend = 5.8, y = -5, yend = -5), color="#000000") +
  
  geom_segment(aes(x = 5.3, xend = 5.5, y = -4.5, yend = -4), color="#000000") +
  geom_segment(aes(x = 5.3, xend = 5.5, y = -3.5, yend = -4), color="#000000") +
  geom_segment(aes(x = 5.5, xend = 5.8, y = -4, yend = -4), color="#000000") +
  
  geom_segment(aes(x = 5.3, xend = 5.5, y = -3.5, yend = -3), color="#000000") +
  geom_segment(aes(x = 5.3, xend = 5.5, y = -2.5, yend = -3), color="#000000") +
  geom_segment(aes(x = 5.5, xend = 5.8, y = -3, yend = -3), color="#000000") +
  
  geom_segment(aes(x = 5.3, xend = 5.5, y = -2.5, yend = -2), color="#000000") +
  geom_segment(aes(x = 5.3, xend = 5.5, y = -1.5, yend = -2), color="#000000") +
  geom_segment(aes(x = 5.5, xend = 5.8, y = -2, yend = -2), color="#000000") +
  
  geom_segment(aes(x = 5.3, xend = 5.5, y = -1.5, yend = -1), color="#000000") +
  geom_segment(aes(x = 5.3, xend = 5.5, y = -0.5, yend = -1), color="#000000") +
  geom_segment(aes(x = 5.5, xend = 5.8, y = -1, yend = -1), color="#000000") +
  # 右侧箭头
  geom_segment(aes(x = 7.1, xend = 6.9, y = -5.5, yend = -5), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 6.9, y = -4.5, yend = -5), color="#ff0000") +
  geom_segment(aes(x = 6.6, xend = 6.9, y = -5, yend = -5), color="#ff0000") +
  
  geom_segment(aes(x = 7.1, xend = 6.9, y = -4.5, yend = -4), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 6.9, y = -3.5, yend = -4), color="#ff0000") +
  geom_segment(aes(x = 6.6, xend = 6.9, y = -4, yend = -4), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 6.9, y = -3.5, yend = -3), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 6.9, y = -2.5, yend = -3), color="#ff0000") +
  geom_segment(aes(x = 6.6, xend = 6.9, y = -3, yend = -3), color="#ff0000") +
  
  geom_segment(aes(x = 7.1, xend = 6.9, y = -2.5, yend = -2), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 6.9, y = -1.5, yend = -2), color="#ff0000") +
  geom_segment(aes(x = 6.6, xend = 6.9, y = -2, yend = -2), color="#ff0000") +
  
  geom_segment(aes(x = 7.1, xend = 6.9, y = -1.5, yend = -1), color="#ff0000") +
  geom_segment(aes(x = 7.1, xend = 6.9, y = -0.5, yend = -1), color="#ff0000") +
  geom_segment(aes(x = 6.6, xend = 6.9, y = -1, yend = -1), color="#ff0000") +
  labs(y =NULL,x=NULL)+
  theme(
    axis.title.x = element_blank(), 
    axis.title.y = element_blank(), 
    axis.text.x    = element_blank(),
    axis.text.y    = element_blank(),
    panel.background = element_blank(), 
    panel.grid.major = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(), 
    plot.margin = unit(c(1,1,1, 1), "cm"),
    plot.background = element_rect(fill = "#fbfaf6", color = NA),  
    axis.ticks = element_blank(),
    legend.position = "none")

    



