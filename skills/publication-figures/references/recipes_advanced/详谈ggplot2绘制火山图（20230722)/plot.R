library(tidyverse)
library(ggrepel)


df <- read.delim("data.xls",header = TRUE,sep = "\t") 

plot_data <- df %>% janitor::clean_names()  %>% 
  mutate(fold_change = 2^log_fc) %>%
  select(entrezid, symbol,fold_change,adj_p_val) %>% 
  mutate(gene_type = case_when(fold_change >= 2 & adj_p_val <= 0.05 ~ "up",
                               fold_change <= 0.5 & adj_p_val <= 0.05 ~ "down",
                               TRUE ~ "ns"))   

plot_data %>% count(gene_type)

sig_genes <- plot_data %>% filter(symbol %in% c("Il15", "Il34", "Slc22a3"))
up_genes <- plot_data %>% filter(symbol == "Slc22a3")
down_genes <- plot_data %>% filter(symbol %in% c("Il15", "Il34"))

plot_data %>% 
  ggplot(aes(x = log2(fold_change),y = -log10(adj_p_val))) + 
  geom_point(aes(color = gene_type), alpha=0.6, shape = 16,size = 1) + 
  geom_point(data = up_genes,shape = 21,size = 2,fill = "red", colour = "black") + 
  geom_point(data = down_genes,shape = 21,size = 2,fill = "steelblue",colour = "black") + 
  geom_hline(yintercept = -log10(0.05),linetype = "dashed") + 
  geom_vline(xintercept = c(log2(0.5), log2(2)),linetype = "dashed") +
  geom_label_repel(data = sig_genes,aes(label = symbol),force = 2,nudge_y = 1) +
  scale_color_manual(values = c("up" = "#ffad73", "down" = "#26b3ff", "ns" = "grey"),
                     labels = c('down 1245','ns 12578',"up 981")) + 
  scale_x_continuous(breaks = c(seq(-10, 10, 2)),limits = c(-10, 10)) +
  labs(x = "log2(fold change)",
       y = "-log10(adjusted P-value)",colour = "Expression change") +
  guides(color=guide_legend(override.aes = list(size=5)))+
  theme_bw() +   
  theme(panel.border = element_rect(colour = "black", fill = NA, size= 0.5),    
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        panel.background = element_blank(),
        plot.background = element_blank(),
        axis.title = element_text(face="bold",color="black",size=10),
        axis.text=element_text(color="black",size=9,face="bold"),
        legend.background = element_blank(),
        legend.title = element_text(face="bold",color="black",size=10),
        legend.text =element_text(face="bold",color="black",size=9),
        legend.spacing.x = unit(0,"cm"),
        legend.position = c(0.88,0.89)) 
