library(tidyverse)
library(ggsci)
library(ggprism)
library(rstatix)
library(ggpubr)
library(magrittr)
library(MetBrewer)
library(patchwork)

df <- read_tsv("data.xls") %>% select(1:10,cluster) %>% 
  select(-ID) %>% 
  pivot_longer(-cluster)

df$name <- factor(df$name,levels = df$name %>% unique())

df_p_val1 <- df %>% group_by(name) %>%
  wilcox_test(value ~ cluster) %>%
  adjust_pvalue(p.col = "p", method = "bonferroni") %>%
  add_significance(p.col = "p.adj") %>% 
  add_xy_position(x = "name", dodge = 0.8)


p1 <- df %>% ggplot(aes(name,value))+
  stat_boxplot(geom="errorbar",aes(fill=cluster),
               position=position_dodge(width=0.6),width=0.1)+
  geom_boxplot(aes(fill=cluster),position=position_dodge(width =0.6),width=0.4)+
  stat_pvalue_manual(df_p_val1,label = "p.adj.signif",label.size=4,hide.ns = T,
                     tip.length = 0.01)+
  scale_size_continuous(range=c(1,3))+
  scale_fill_manual(values=c("#3CB2EC","#9C8D58"))+
  labs(x=NULL,y=NULL)+
  theme_test()+
  theme(plot.margin=unit(c(0,0.5,0.5,0.5),units=,"cm"),
        axis.line = element_line(color = "black",size = 0.3),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(size = 0.2,color = "#e5e5e5"),
        axis.text.y = element_text(color="black",size=8),
        axis.text.x = element_text(margin = margin(t = 2),color="black",size=8),
        legend.position = "none")+
  coord_cartesian()


df1 <- read_tsv("data.xls") %>%
  select(1:10,cluster) %>% select(-ID)

calculate_correlation <- function(df, cluster, column_index) {
  a <- df %>% filter(cluster == cluster) %>% select(column_index) %>% head(21)
  b <- df %>% filter(cluster == "B") %>% select(column_index)
  
  cor_value <- cor(a %>% pull(), b %>% pull())
  
  return(cor_value)
}

columns <- 1:9  # 列索引 1 到 9
cor_values <- map_dbl(columns, ~ calculate_correlation(df1, "A", .x))

p2 <- df %>% select(name) %>% unique() %>% bind_cols(cor_values) %>% 
  set_names(c("name","cor")) %>% 
  ggplot(.,aes(name,cor)) +
  geom_segment(aes(x=name,xend=name,y=0,yend=cor))+
  geom_point(aes(size=abs(cor)),shape=21,colour="black",fill="#3CB2EC")+
  labs(x=NULL,y=NULL)+
  geom_hline(yintercept = 0,color="grey50")+
  scale_fill_gradientn(colors=met.brewer("VanGogh2"))+
  scale_color_gradientn(colors=met.brewer("VanGogh2"))+
  scale_y_continuous(limits = c(-0.6,0.4))+
  theme_classic()+
  theme(legend.position = "non",
        plot.title=element_text(color="black",vjust=0.5,hjust=0.5),
        axis.text.y = element_text(color="black",size=8),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        plot.margin = unit(c(0,0,0,0),units="cm"),
        panel.grid = element_blank(),
        plot.background = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text.x.top = element_blank(),
        axis.ticks.x.top = element_blank())

p2/p1+plot_layout(heights = c(0.3,0.6))


