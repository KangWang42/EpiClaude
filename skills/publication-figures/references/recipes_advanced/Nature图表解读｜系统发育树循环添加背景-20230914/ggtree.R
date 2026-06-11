library(tidyverse)
library(treeio)
library(ape)
library(magrittr)
library(ggtree)

otu <- read.delim('otu.xls',row.names=1) %>%
  select_if(is.numeric) %>% rownames_to_column(var="OTU") %>% 
  left_join(.,read_tsv("otu.xls") %>% select_if(~!is.numeric(.)),
            by="OTU") %>%
  separate(taxonomy,
           into=c("domain","phylum","class","order","family","genus","species"),sep=";") %>%
  mutate_at(vars(c(`domain`:`species`)),~str_split(.,"__",simplify=TRUE)[,2]) %>% 
  column_to_rownames("OTU") %>% 
  select(where(is.numeric),phylum) %>% head(200)

tree <- hclust(dist(otu %>% select(where(is.numeric)),method="canberra")
               )
ggtree(tree, layout = "circular", branch.length = "none")


# 定义函数用于绘制条带并返回绘图对象
draw_strips <- function(p, labels, color) {
  for (label in labels) {
    p <- p + geom_strip(label, label, extend = 0.5, color = color,
                        offset = 2.1, barsize = 22, alpha = 0.5)
  }
  return(p)
}


df <- otu %>% rownames_to_column(var="ASV") %>% select(ASV,phylum)

df %>% pull(phylum) %>% unique()

# 使用 filter 和 pull 从 df 中提取标签
labels_to_group <- df %>% filter(phylum == "Proteobacteria") %>% pull(ASV)
labels_to_group2 <- df %>% filter(phylum == "Gemmatimonadetes") %>% pull(ASV)
labels_to_group3 <- df %>% filter(phylum == "Actinobacteria") %>% pull(ASV)
labels_to_group4 <- df %>% filter(phylum == "Chloroflexi") %>% pull(ASV)
labels_to_group5 <- df %>% filter(phylum == "Acidobacteria") %>% pull(ASV)
labels_to_group6 <- df %>% filter(phylum == "Rokubacteria") %>% pull(ASV)

# 创建绘图对象
p <- ggtree(tree, layout = "circular", branch.length = "none")

# 绘制不同组的条带
p <- draw_strips(p, labels_to_group, "#4DBBD5FF")
p <- draw_strips(p, labels_to_group2, "#00A087FF")
p <- draw_strips(p, labels_to_group3, "#F39B7FFF")

p + 
  geom_strip("ASV_101653","ASV_56052",extend=0.5,color="yellow",
               offset = 2.1, barsize = 22, alpha = 0.5)+
  geom_tiplab(size = 2, color = "black",offset = 3)
 


