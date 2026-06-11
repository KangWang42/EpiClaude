library(tidyverse)
library(vegan)
library(scico)


data("varechem")

df <- varechem %>% select(1:14) %>% select(-c(Humdepth,Baresoil))



# 使用Min-Max标准化方法
df_normalized <- as.data.frame(apply(df, 2, function(x) (x - min(x)) / (max(x) - min(x))))

varechem %>% rownames_to_column(var="id") %>% 
  select(id) %>% 
  bind_cols(.,df_normalized) %>% 
  pivot_longer(-id) %>% 
  ggplot(aes(name,id,fill=value))+
  geom_tile()+
  labs(x=NULL,y=NULL)+
  scale_fill_scico(palette="vik")+
  scale_y_discrete(expand=c(0,0),position = 'left')+
  scale_x_discrete(expand=c(0,0))+
  theme(plot.background = element_blank(),
        panel.background = element_blank(),
        axis.text=element_text(color="black",size=8),
        axis.ticks = element_blank(),
        legend.background = element_blank(),
        legend.text = element_text(color="black"),
        legend.title = element_blank(),
        legend.spacing.x = unit(0.1,"cm"))+
  guides(fill=guide_colorbar(direction="vertical",reverse=F,barwidth=unit(.5,"cm"),
                              barheight=unit(11,"cm")))



