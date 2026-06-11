library(tidyverse)
library(readxl)
library(patchwork)

df <- read_excel("41467_2022_35431_MOESM8_ESM.xlsx",sheet = 4) %>% as.data.frame() 

df$ID <- factor(df$ID,levels = df$ID %>% unique())

p1 <- df %>% ggplot(aes(x=ID,y=`Pathological regression (%)`,
                  fill=group))+geom_col()+
  scale_y_continuous(expand = c(0,0))+
  scale_fill_manual(values=c("#FABE01","#74C6BC"))+
  geom_hline(yintercept=c(-50,-75,-90),linetype="dashed",color="grey")+
  theme_test()+
  theme(axis.title.y = element_text(color="black"),
        axis.title.x = element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = "non",
        plot.margin = unit(c(0,0,0,0),unit="cm"),
        axis.text = element_text(color="black",size=8))
  
df2 <- df %>% select(1:7) %>% pivot_longer(-ID) %>% 
  mutate(sign=case_when(value =="NA" ~ "X",TRUE ~ " "))
  
df2$name <- factor(df2$name,levels = df2$name %>% unique() %>% rev())

p2 <- df2 %>% ggplot(aes(ID,name,fill=value))+
  geom_tile(color=NA,width=.9,height=.9)+
  geom_text(aes(label=sign),size=8)+
  scale_fill_manual(values = c("Positive" = "#C64543", "Negative" = "#080922",
                               "MSS"="#080922","MSI-H"="#C64543",
                               "SD"="#080922","PR"="#C64543",
                               "Intestinal/mixed"="#842064","Diffused"="#E8E166",
                               "T4a"="#842064","T4b"="#E8E166"),na.value = "white")+
  theme(axis.title = element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_text(color="black"),
        axis.ticks=element_blank(),
        plot.background = element_blank(),
        panel.background = element_blank(),
        legend.position = "top",
        legend.title = element_blank(),
        legend.spacing.x=unit(0.1,'cm'),
        legend.key.width=unit(0.5,'cm'),
        legend.key.height=unit(0.5,'cm'),
        legend.text = element_text(color="black",size=8))  

(p2/p1)+plot_layout(ncol=1,heights = c(0.4,0.8))

