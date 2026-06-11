library(tidyverse)
library(readxl)
library(ggprism)
library(ggtree)
library(cowplot)
library(patchwork)

df <- read_excel("41587_2023_1675_MOESM4_ESM.xlsx",sheet = 1)

tree <- hclust(dist(df %>% column_to_rownames(var="Bacteria"))) %>% 
  ggtree(layout="rectangular", branch.length="none")+
  geom_tiplab(size=3.5,family="Times",fontface="italic",color="black")+
  xlim(0,20)

group <- read_excel("41587_2023_1675_MOESM4_ESM.xlsx",sheet = 2)

df1 <- df %>% pivot_longer(-Bacteria) %>% filter(value !=0) %>% 
  mutate(type=case_when(value > 0.5 ~">50% bacteria",
                        value <=0.5 ~"<=50% bacteria")) %>% 
  left_join(.,group,by="name")

df1$group <- factor(df1$group,levels = group$group %>% unique())

plot1 <- df1 %>% 
  ggplot(aes(name,Bacteria,fill=type,color=group))+
  geom_point(data=df1 %>% filter(type==">50% bacteria"),size=4.5,show.legend = F)+
  geom_point(data=df1 %>% filter(type!=">50% bacteria"),size=3,show.legend = F)+
  scale_x_discrete(position = "top",limits=group$name %>% unique())+
  scale_y_discrete(limits = get_taxa_name(tree) %>% rev())+
  scale_color_manual(values =c("#55BF93","#E9972A","#205FA7","#DD5AA3","#F9CC13","#91409A","black"))+
  labs(x=NULL,y=NULL)+
  annotate("rect",xmin=-Inf,xmax=14.5,ymin=-Inf,ymax=Inf,alpha=0.2,fill="#55BF93")+
  annotate("rect",xmin=14.5,xmax=18.5,ymin=-Inf,ymax=Inf,alpha=0.2,fill="#E9972A")+
  annotate("rect",xmin=18.5,xmax=20.5,ymin=-Inf,ymax=Inf,alpha=0.2,fill="#205FA7")+
  annotate("rect",xmin=20.5,xmax=30.5,ymin=-Inf,ymax=Inf,alpha=0.2,fill="#DD5AA3")+
  annotate("rect",xmin=30.5,xmax=34.5,ymin=-Inf,ymax=Inf,alpha=0.2,fill="#F9CC13")+
  annotate("rect",xmin=34.5,xmax=43.5,ymin=-Inf,ymax=Inf,alpha=0.2,fill="#91409A")+
  annotate("rect",xmin=43.5,xmax=Inf,ymin=-Inf,ymax=Inf,alpha=0.2,fill="black")+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90,color="black",vjust=0.5,hjust=0),
        axis.ticks = element_blank(),
        axis.text.y=element_blank())

plot2 <- read_excel("41587_2023_1675_MOESM4_ESM.xlsx",sheet = 3) %>% 
  pivot_longer(-Bacteria) %>% 
  ggplot(aes(value,Bacteria,fill=name))+
  geom_col(show.legend = F,width=0.8)+
  labs(x=NULL,y=NULL)+
  scale_fill_manual(values = c("#006533","black"))+
  scale_y_discrete(limits = get_taxa_name(tree) %>% rev())+
  scale_x_continuous(guide = "prism_offset_minor",position = "top")+
  theme_prism()+
  theme(axis.text.y=element_blank(),
        axis.text.x =element_text(color="black",size=8),
        axis.line.y = element_blank(),
        axis.ticks.y=element_blank(),
        axis.ticks.x =element_line(size=0.5),
        axis.line.x = element_line(size=0.5))

plot <- (tree+plot2+plot1)+plot_layout(widths = c(1,0.5,4))

# 图形注释
ggdraw(plot)+
  draw_text(text="Total number\nof pathways",size=10,x=0.24,y=0.68,color="black")+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#55BF93",col="#55BF93",alpha=0.2)),x=0.08,y=0.81,height=0.03,width=0.08)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#E9972A",col="#E9972A",alpha=0.2)),x=0.08,y=0.78,height=0.03,width=0.08)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#205FA7",col="#205FA7",alpha=0.2)),x=0.08,y=0.75,height=0.03,width=0.08)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#DD5AA3",col="#DD5AA3",alpha=0.2)),x=0.08,y=0.72,height=0.03,width=0.08)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#F9CC13",col="#F9CC13",alpha=0.2)),x=0.08,y=0.69,height=0.03,width=0.08)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#91409A",col="#91409A",alpha=0.2)),x=0.08,y=0.66,height=0.03,width=0.08)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="grey",col="grey",alpha=0.2)),x=0.08,y=0.63,height=0.03,width=0.08)+
  draw_text(text="SCFA",size=10,x=0.12,y=0.825,color="black")+
  draw_text(text="SCFA-Others",size=10,x=0.12,y=0.795,color="black")+
  draw_text(text="Aliphatic amines",size=10,x=0.12,y=0.765,color="black")+
  draw_text(text="Aromatic",size=10,x=0.12,y=0.735,color="black")+
  draw_text(text="npAA",size=10,x=0.12,y=0.705,color="black")+
  draw_text(text="Other",size=10,x=0.12,y=0.675,color="black")+
  draw_text(text="Energy-MGCs",size=10,x=0.12,y=0.645,color="black")+
  # 绘图图例框-1
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="white",col="black")),x=0.18,y=0.81,height=0.02,width=0.12)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="white",col="black")),x=0.18,y=0.79,height=0.02,width=0.12)+
  draw_line(x=c(0.2,0.2),y=c(0.79,0.83),size=0.5,color="black")+
  draw_text(text=">50% bacteria",size=10,x=0.255,y=0.82,color="black")+
  draw_text(text="<=50% bacteria",size=10,x=0.255,y=0.8,color="black")+
  # 绘图图例框-2
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="white",col="black")),x=0.18,y=0.75,height=0.02,width=0.12)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="white",col="black")),x=0.18,y=0.73,height=0.02,width=0.12)+
  draw_line(x=c(0.2,0.2),y=c(0.73,0.77),size=0.5,color="black")+
  draw_text(text="Primary metabolism",size=10,x=0.254,y=0.758,color="black")+
  draw_text(text="Energy-MGCs",size=10,x=0.254,y=0.738,color="black")+
  
  # 注释图例点
  draw_grob(grid::grid.circle(gp=grid::gpar(fill="black",col="black")),x=0.13,y=0.812,height=0.016,width=0.12)+
  draw_grob(grid::grid.circle(gp=grid::gpar(fill="black",col="black")),x=0.13,y=0.792,height=0.013,width=0.12)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="#006533",col="black")),x=0.18,y=0.75,height=0.02,width=0.02)+
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="black",col="black")),x=0.18,y=0.73,height=0.02,width=0.02)
  
# 14.56,9.56
