library(tidyverse)
library(readxl)
library(ggsci)
library(patchwork)
library(ggnewscale)

df1 <- read_excel("41564_2023_1355_MOESM5_ESM.xlsx",sheet = 4) %>% 
  select(-Abs.cliff,-Cliff.delta,-Trend) %>% 
  pivot_longer(-c("id")) %>% 
  mutate(text=case_when(value < 0 ~ "+"))


df2 <- read_excel("41564_2023_1355_MOESM5_ESM.xlsx",sheet = 4) %>% select(id,Trend) %>% 
  mutate(name="Trend",value=0) %>% 
  dplyr::rename(text="Trend")

df <- bind_rows(df1,df2)

x_cols <- rep(c("red","blue","black"),times=c(3,9,1))

plot <- ggplot()+
  geom_tile(data=df,aes(name,id),color="black",fill="white",size=0.1)+
  geom_point(data=df %>% filter(text=="+"),aes(name,id,fill=value,color=value),shape=22,size=5.7)+
  geom_text(data=df %>% filter(text=="+"),aes(name,id,fill=value,color=value,label=text),color="black")+
  scale_color_gradientn(colours = (RColorBrewer::brewer.pal(11,"RdBu")))+
  scale_fill_gradientn(colours = (RColorBrewer::brewer.pal(11,"RdBu")))+
  new_scale_color()+
  new_scale_fill()+
  guides(color=guide_colorbar(direction="vertical",reverse=F,barwidth=unit(.5,"cm"),
                             barheight=unit(15,"cm")))+
  geom_point(data=df %>% filter(text!="+"),aes(name,id,fill=text,color=text),shape=22,size=5.7)+
  scale_fill_jama()+
  scale_color_jama()+
  theme(panel.background = element_blank(),
        plot.background = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text.x=element_text(color=x_cols,size=8,angle = 90,vjust=0.5,hjust=1),
        axis.text.y=element_text(color="black",size=8),
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.spacing.x = unit(0.1,"cm"),
        legend.title = element_blank(),
        legend.text = element_text(color="black",size=8))

ggsave(plot,file="heatmap.pdf",width=4.75,height =11.84 ,unit="in",dpi=300)


