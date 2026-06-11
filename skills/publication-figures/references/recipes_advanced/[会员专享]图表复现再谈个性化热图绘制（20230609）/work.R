library(tidyverse)
library(linkET)
library(RColorBrewer)
library(ggtext)
library(magrittr)
library(psych)
library(reshape)
library(cowplot)

table1 <- read.delim("env.xls",header =T,sep="\t",row.names = 1,check.names = F)

table2 <- read.delim("genus.xls",header =T,sep="\t",row.names = 1,check.names = F) %>% 
  t() %>% as.data.frame()

pp <- corr.test(table1,table2,method="pearson",adjust = "fdr")

cor <- pp$r
pvalue <- pp$p

df <- melt(cor) %>% mutate(pvalue=melt(pvalue)[,3],
                     p_signif=symnum(pvalue, corr = FALSE, na = FALSE,  
                                     cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                                     symbols = c("***", "**", "*", "", " "))) %>% 
  set_colnames(c("env","genus","r","p","p_signif"))

cordata <- df %>% left_join(.,read_tsv('annotation.xls'),by=c("genus")) %>% 
  select(group,env:p,-genus) %>% 
  set_colnames(c("spc","env","r","p")) %>% 
  mutate(rd = cut(r, breaks = c(-Inf, 0, 0.4, Inf),
                  labels = c("< 0", "0 - 0.4", ">= 0.4")),
         pd = cut(p, breaks = c(-Inf, 0.05, Inf),
                  labels = c("< 0.05",">= 0.05")))

plot <- qcorrplot(correlate(table1,method = "pearson"),diag=F,type="lower")+
  geom_square()+
#  geom_tile()+
#  geom_mark(size=2.5,sig.thres=0.05,sep="\n")+
  geom_couple(aes(colour=pd,size=rd),data=cordata,label.colour = "black",
              curvature=nice_curvature(0.1),nudge_x=0.2,
              label.fontface=2,
              label.size =3,drop =F)+
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(11,"RdBu"))+
  scale_size_manual(values = c(0.2,0.8, 1)) +
  scale_colour_manual(values =c("#D95F02","#1B9E77")) +
  guides(size = guide_legend(title = "Mantel's r",override.aes = list(colour = "grey35"), order = 2),
         colour = guide_legend(title = "Mantel's p",override.aes = list(size = 3), order = 1),
         fill = guide_colorbar(title = "Pearson's r",order = 3))+
  theme(plot.margin = unit(c(0,0,0,2),units="cm"),
        panel.background = element_blank(),
        plot.background = element_blank(),
        axis.text=element_markdown(color="black",size=10),
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.title = element_text(margin = margin(b= 5)),
        legend.spacing.y = unit(0,"cm"),
        legend.key.height = unit(0.6,"cm"))

ggdraw()+ draw_plot(plot,x =0, y =0,scale=1) +
  draw_grob(grid::grid.rect(gp=grid::gpar(fill="grey90",col="grey90")),
            x=0.04,y=0.11,height = 0.8,width=0.05)+
  draw_text(text="ECS",size=18,x=0.065, y =0.5,angle=90,color="black")
