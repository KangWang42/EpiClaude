library(tidyverse)
library(readxl)
library(ggprism)
library(cowplot)

df <- read_excel("41467_2023_38611_MOESM4_ESM.xlsx",sheet=3) %>% 
  select(`PatientNumber.Inc`,MAX.CarTum_perc_change,PDL1_CPS_r2,ORR)

df$PatientNumber.Inc <- factor(df$PatientNumber.Inc,levels = df$PatientNumber.Inc)
  
plot <- df %>% ggplot(aes(`PatientNumber.Inc`,MAX.CarTum_perc_change,fill=ORR)) +
  geom_col()+
  geom_text(data=df %>% filter(MAX.CarTum_perc_change>0),
            aes(y=-7,label=PDL1_CPS_r2),vjust=0.5,hjust=0.5,size=5,color="blue")+
  geom_text(data=df %>% filter(MAX.CarTum_perc_change<0),
            aes(y=7,label=PDL1_CPS_r2),vjust=0.5,hjust=0.5,size=5,color="blue")+
  geom_hline(yintercept=0, color = "grey80", size=0.8)+
  scale_fill_manual(values = c("#B21B2B","#9ECAE1","#FFA500"))+
  scale_color_manual(values = c("#B21B2B","#9ECAE1","#FFA500"))+
  labs(x=NULL,y="% Maximum Change from baeline",title = "Lung NENs")+
  scale_y_continuous(limits = c(-100, 250),breaks = seq(-100,250,50),
    guide = "prism_offset")+
  theme_prism(base_size = 10)+
  theme(axis.text.x=element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(color="black",size=12),
        plot.title = element_text(vjust=0.5,hjust=0.5),
        legend.background = element_blank(),
        legend.text = element_text(color="black",size=9,face="bold"),
        legend.spacing.x = unit(0.1,"cm"),
        legend.key.height = unit(0.5,"cm"),
        legend.key.width = unit(0.5,"cm"),
        legend.position = c(0.9,0.8))


ggdraw(plot) +
  draw_text(text="ORR: 11.1%",size=9,x=0.2,y=0.8,color="black",fontface="bold")+
  draw_text(text="ORR PD-L1+:33.3%",size=9,x=0.236,y=0.768,color="black")+
  draw_text(text="ORR PD-L1-:0%",size=9,x=0.22,y=0.738,color="black")

