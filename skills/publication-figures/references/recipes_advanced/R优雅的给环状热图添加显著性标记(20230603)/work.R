library(ggtreeExtra)
library(ggtree)
library(treeio)
library(tidyverse)
library(ggnewscale)

df <- read.delim("genus.xls",sep="\t") %>% head(60) %>% 
  column_to_rownames(var="OTU.ID")

dat2 <- df %>% mutate_if(is.numeric,function(x) x+ 1) %>%
  log10() %>% 
  rownames_to_column(var="ID") %>% pivot_longer(-ID) %>% 
  mutate(name = trimws(str_remove(name,"(\\s+[A-Za-z]+)?[3-6-]+")))


p <- hclust(dist(df)) %>% ggtree(layout="fan", open.angle=10)

p + new_scale_fill() +
  geom_fruit(data=dat2, geom=geom_tile,
             mapping=aes(y=ID, x=name,alpha=value,fill=name),
             color = "grey50",offset = 0.04,size = 0.02)+
  geom_fruit(data=dat2 %>%
               mutate(text=case_when(value > 2.5 ~ "**",TRUE ~ " ")),
             geom=geom_text,
             mapping=aes(y=ID,x=name,label=text),
             color = "black",offset =0.01,size =2,vjust=0.5)+
  scale_alpha_continuous(guide=NULL)+
  scale_fill_manual(values=c("#FFC125","#87CEFA","#7B68EE",
                             "#9ACD32","#D15FEE","#FFC0CB",
                             "#EE6A50","#8DEEEE", "#006400","#800000",
                             "#B0171F","#191970"))+
  theme(legend.position="none")

