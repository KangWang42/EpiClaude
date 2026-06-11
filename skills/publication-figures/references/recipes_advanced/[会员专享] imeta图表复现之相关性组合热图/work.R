library(tidyverse)
library(readxl)
library(linkET)
library(RColorBrewer)
library(ggtext)
library(magrittr)
library(ggnewscale)
library(cowplot)

varechem <- read_excel("imt279-sup-0002-supplementary_tables_1.xlsx",skip = 1) %>% select(pH:DOC) %>% 
  dplyr::rename("NO<sub>3</sub>-"=`NO3-N`,
                "NO<sub>2</sub>-"=`NO2-N`,
                "NH<sub>4</sub>+"=`NH4-N`,
                "PO<sub>4</sub>3-"="PO4")
  
varespec <- read_excel("imt279-sup-0002-supplementary_tables_1.xlsx",skip = 1,sheet = 2) %>% 
  select(-1)

mantel <- mantel_test(varespec,varechem,
                      spec_select = list(" "= 1:9)) %>% 
  mutate(rd = cut(r, breaks = c(-Inf, 0.2, 0.4, Inf),
                  labels = c("< 0.2", "0.2 - 0.4", ">= 0.4")),
         pd = cut(p, breaks = c(-Inf, 0.01, 0.05, Inf),
                  labels = c("0.001-0.01","0.01-0.05", ">= 0.05")))

p1 <- qcorrplot(correlate(varechem,method = "pearson"),diag=T,type="upper")+
  geom_point(aes(size=abs(r)),shape=21)+
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(8,"RdYlBu"))+
  scale_color_gradientn(colours = RColorBrewer::brewer.pal(8,"RdYlBu"))+
  guides(size="none")+
  new_scale("size")+
  geom_couple(aes(colour=pd,size=rd),data=mantel,label.colour = "black",
              curvature=nice_curvature(0.1,by="from"),nudge_x=-1,
              offset_x=3,
              label.fontface=0,
              label.size =4,drop = T)+
  scale_size_manual(values = c(0.5, 1, 2)) +
  scale_colour_manual(values =c("#788CAE","#EA967B","#FBD4AA")) +
  guides(size = guide_legend(title = "Mantel's r",override.aes = list(colour = "grey35"), order = 2),
         color="none",
         fill = guide_colorbar(title = "pearson's r",order = 3))+
  theme(plot.margin = unit(c(-1.8,-2,1,-2),units="cm"),
        panel.background = element_blank(),
        axis.text=element_markdown(color="black",size=10),
        legend.key = element_blank(),
        legend.background = element_blank()) 

df <- mantel %>% arrange(desc(r))
df$env <- factor(df$env,levels = df$env)
p2 <- df %>% ggplot(aes(env,r,fill=pd))+
  geom_col(width=0.8)+
  scale_fill_manual(values =c("#788CAE","#EA967B","#FBD4AA")) +
  scale_y_continuous(expand = c(0,0))+
  theme_classic()+
  labs(x=NULL,y=NULL)+
  theme(axis.text.x = element_markdown(color="black",angle = 40,vjust =1,hjust = 1),
        axis.text.y=element_text(color="black"),
        panel.background = element_blank(),
        plot.background = element_blank(),
        legend.text = element_text(color="black"),
        legend.background = element_blank(),
        legend.title = element_blank(),
        legend.key = element_blank(),
        legend.position ="bottom",
        legend.key.height = unit(0.4,"cm"),
        legend.spacing.y = unit(0.4,"cm"))

ggdraw()+draw_plot(p1,scale=0.63,y=0.045,width = 1,height = 1)+
  draw_plot(p2,scale=0.6,x=-0.2,y=-0.15,width=1.2,height=0.7)

ggsave(plot,file="heatmap.pdf",width=4.7,height =4.98,unit="in",dpi=300)
