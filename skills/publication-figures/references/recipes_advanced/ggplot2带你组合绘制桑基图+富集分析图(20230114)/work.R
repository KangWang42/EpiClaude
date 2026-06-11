library(tidyverse)
library(ggsankey)
library(RColorBrewer)
library(cowplot)

df <- read_tsv("DEG.Ko.enrich.xls") %>% 
  select(1,2,3,5,6,8) %>% 
  mutate(count=Input.number/Background.number) %>% 
  arrange(desc(count)) %>% head(20)

df$layer3 <- factor(df$layer3,levels = df$layer3 %>% unique() %>% rev())

p1 <- df %>% ggplot(aes(count,layer3,count))+
  geom_point(aes(size=Input.number,color=FDR,fill=FDR),shape=19)+
  scale_color_gradientn(colours =RColorBrewer::brewer.pal(6,"RdBu"))+
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(6,"RdBu"))+
  guides(size=guide_legend(title="Count"))+
  theme_bw()+
  theme(axis.title = element_blank(),
        axis.text.x=element_text(color="black",face="bold"),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        legend.key=element_blank(), 
        legend.title = element_text(color="black",size=10), 
        legend.text = element_text(color="black",size=8), 
        legend.spacing.x=unit(0.1,'cm'), 
        legend.key.width=unit(0.5,'cm'),
        legend.key.height=unit(0.5,'cm'), 
        legend.background=element_blank(), 
        legend.box.margin = margin(1,1,1,1))


dff2 <- read_tsv("DEG.Ko.enrich.xls") %>% 
  select(1,2,3,5,6,8) %>% 
  mutate(count=Input.number/Background.number) %>% 
  arrange(desc(count)) %>% head(20)

# 此处定义因子为将两幅图顺序调整一致
df2 <- dff2 %>% select(2,3) %>% make_long(layer2,layer3)
df2$node <- factor(df2$node,levels = c(dff2$layer2 %>% unique(),dff2$layer3 %>% unique() %>% rev()))

p2 <- df2 %>% 
  ggplot(aes(x=x,next_x=next_x,node=node,next_node=next_node,fill=node,
             label=node))+
  geom_sankey()+
  geom_sankey_text(size=3,color="black")+
  scale_fill_manual(values =colorRampPalette(brewer.pal(11,"Paired"))(30))+
  theme_void()+
  theme(legend.position = "non",
        plot.margin = unit(c(0,10,0,0),units="cm"))

ggdraw()+ draw_plot(p2)+
  draw_plot(p1,scale=0.5,x=0.4,y=-0.49,width=0.75,height=1.95)


