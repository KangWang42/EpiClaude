library(tidyverse)
library(psych)
library(pheatmap)
library(magrittr)
# devtools::install_github("thomasp85/scico")
library(scico)

env <- read.delim("env.xls",header =T,sep="\t",row.names = 1,check.names = F)
genus <- read.delim("genus.xls",header =T,sep="\t",row.names = 1,check.names = F) %>% 
  t() %>% as.data.frame()

pp <- corr.test(env,genus,method="pearson",adjust = "fdr")

cor <- pp$r
pvalue <- pp$p

df <- melt(cor) %>% mutate(pvalue=melt(pvalue)[,3],
                           p_signif=symnum(pvalue, corr = FALSE, na = FALSE,  
                                           cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1), 
                                           symbols = c("***", "**", "*", "", " "))) %>% 
  set_colnames(c("env","genus","r","p","p_signif"))


rvalue <- df %>% select(1,2,3) %>% pivot_wider(names_from = "genus",values_from = r) %>% 
  column_to_rownames(var="env")

pvalue <- df %>% select(1,2,5) %>% pivot_wider(names_from = "genus",values_from = p_signif) %>% 
  column_to_rownames(var="env")


mycol<- scico(100,palette="vik")


pheatmap(rvalue,scale = "none",cluster_row = T, cluster_col = T, border=NA,
         display_numbers =pvalue,fontsize_number = 12, number_color = "white",
         main = " ",
         cellwidth = 21, cellheight =20,color=mycol)

