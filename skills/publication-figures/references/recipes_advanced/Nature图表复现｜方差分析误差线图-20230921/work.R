  library(tidyverse)
  library(ggtext)
  library(ggprism)
  library(ggsignif)
  library(rstatix)
  library(ggpubr)
  
  df <- read_tsv("data.txt") %>% pivot_longer(-Type) %>% 
    dplyr::filter(Type=="Day 5") %>% select(-Type)
  
  result.aov <- aov(value ~ name, data = df)
  result.tukey <- TukeyHSD(result.aov)
  
  aov_pvalue <- result.tukey$name %>% as.data.frame() %>% 
    rownames_to_column(var="group") %>% 
    dplyr::select(1,`p adj`) %>% 
    separate(`group`, into=c("group2", "group1"), sep="CAR T-", convert = TRUE) %>% 
    mutate(group1=str_replace_all(`group1`, "CAR T","")) %>% 
    select(2,1,3) %>% 
    select(-1,-2) %>% 
    mutate(p_signif=symnum(`p adj`, corr = FALSE, na = FALSE,  
                           cutpoints = c(0, 0.01, 0.05,1), 
                           symbols = c("**", "*", "ns")))
  df_pvalue <- df %>% 
    mutate(`name`=str_replace_all(`name`, "CAR T","")) %>% 
    mutate(name=str_trim(name)) %>% 
    wilcox_test(value ~ name) %>% 
    add_significance(p.col="p.adj") %>% 
    add_xy_position(x="name") %>% select(-p.adj) %>% 
    bind_cols(aov_pvalue)
  
  df %>%
    mutate(`name`=str_replace(`name`, "CAR T","")) %>% 
    ggplot(aes(name,value))+
    stat_summary(aes(color=name),fun = mean,geom = "errorbar", width=.2,
                 fun.max = function(x) mean(x) + sd(x),
                 fun.min = function(x) mean(x) - sd(x)) +
    stat_summary(fun = mean, geom = "crossbar",width = 0.4,color = "black",size=0.5) +
    geom_jitter(aes(fill=name,color=name,shape=name),width = 0.1, height = 0)+
    stat_pvalue_manual(df_pvalue,label="p_signif",label.size=5,hide.ns=T)+
    scale_shape_manual(values = c(21,22,23,24)) +
    scale_fill_manual(values=c("#679289","#ee2e31","#c9cba3","#f4c095"))+
    scale_color_manual(values=c("#679289","#ee2e31","#c9cba3","#f4c095"))+
    scale_y_continuous(guide = "prism_minor",
                       limits = c(0, 40),
                       expand = c(0, 0))+
    labs(x=NULL,y="CAR T cells x (10<sup>3</sup>/g)")+
    theme_prism()+
    theme(strip.background = element_blank(),
          legend.background = element_rect(color=NA),
          legend.key = element_blank(),
          legend.spacing.x = unit(-0.09,"in"),
          legend.spacing.y = unit(-0.09,"in"),
          legend.text = element_text(color="black",size=6,face="bold"),
          legend.position = "top",
          axis.text.x=element_blank(),
          axis.text.y=element_text(color="black",size=8),
          axis.title.y = element_markdown(color="black",face="bold",size=10),
          axis.ticks.x = element_blank())+
    guides(shape = guide_legend(override.aes = list(size=3),
                                direction = "horizontal",
                                nrow=3, byrow=TRUE))
  
  
  
