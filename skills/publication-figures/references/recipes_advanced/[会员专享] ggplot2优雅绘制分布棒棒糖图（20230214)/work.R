library(tidyverse)
library(magrittr)
library(ggprism)
library(MetBrewer)
library(ggh4x)
library(cowplot)

df_cor <- read_tsv("data.xls") %>% column_to_rownames(var="TCGA_id") %>% 
  pivot_longer(-B2M) %>% 
  pivot_longer(names_to = "name_2", values_to = "value_2",B2M) %>%
  group_by(name_2,name) %>% 
  summarise(cor= cor.test(value_2,value,method="spearman")$estimate,
            p.value = cor.test(value_2,value,method="spearman")$p.value) %>% 
  set_colnames(c("gene_1","gene_2","cor","pvalue")) %>% 
  filter(pvalue < 0.05) %>% 
  arrange(desc(abs(cor)))%>% 
  dplyr::slice(1:500)

df <- df_cor %>% sample_frac(.1) %>% sample_frac(.4) %>% arrange(desc(cor)) 

df$gene_2 <- factor(df$gene_2,levels = df$gene_2 %>% rev())

pvalue <- df$pvalue %>% round(.,digits = 4)

df %>% ggplot(aes(cor,gene_2,fill=cor,color=cor))+
  geom_segment(aes(yend=gene_2,xend=0),size=0.8,color="black")+
  geom_point(aes(size=abs(cor)),pch=21)+
  labs(x=NULL,y=NULL)+
  geom_vline(xintercept = 0,color="grey50")+
  scale_fill_gradientn(colors=met.brewer("VanGogh2"))+
  scale_color_gradientn(colors=met.brewer("VanGogh2"))+
  ggtitle(label="B2M")+
  theme(legend.box.spacing = unit(1, "cm"),
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.spacing.x = unit(0.05,"cm"),
        legend.text = element_text(size =8),
        plot.title=element_text(color="black",vjust=0.5,hjust=0.5),
        axis.text.y = element_text(size =8,angle = 0, vjust = 0.5,color="black"),
        axis.text.x = element_text(size =8, angle = 0,color="black"),
        axis.title = element_text(size=10),
        plot.margin = unit(c(1,1,1,1),units="cm"),
        panel.grid = element_line(color = "grey40",size = 0.2,linetype = 2),
        plot.background = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = "black"),
        axis.text.x.top = element_blank(),
        axis.ticks.x.top = element_blank())+
  scale_x_continuous(guide = guide_axis(angle=0))+
  guides(y.sec = guide_axis_manual(labels = pvalue,color="grey20"),x.sec="axis",
         color="none",
         fill=guide_colorbar(reverse = F,barwidth = unit(0.5,"cm"),
                             barheight = unit(8,"cm"),title =NULL))



