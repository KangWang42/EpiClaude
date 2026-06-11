library(tidyverse)
library(gt)
library(patchwork)

df <- read_csv("AKT3_mRNA_OS_pancan_unicox.csv") %>% head(10)

p_mid <- df %>% 
  ggplot(aes(y = fct_rev(cancer))) +
  theme_classic() +
  geom_point(aes(x=HR_log,size=HR_log),shape=23,fill="black",show.legend = F) +
  geom_errorbarh(aes(xmin=lower_95_log, xmax=upper_95_log),height=0.3) +
  labs(x="Hazard Ratio")+
  coord_cartesian(ylim=c(1,11),xlim=c(-0.6,0.8))+
  geom_vline(xintercept = 0, linetype="dashed") +
  theme(axis.line.y = element_blank(),axis.ticks.y= element_blank(),
        axis.text.y= element_blank(),axis.title.y= element_blank(),
        axis.text.x=element_text(color="black"))

plot <- df %>% 
  mutate(across(c(HR_log,lower_95_log,upper_95_log), ~str_pad(round(.x, 2),width=4, pad="0", side="right")),
         HR_lab = paste0(HR_log, " (",lower_95_log, "-",upper_95_log,")")) %>% 
  mutate(p.value = case_when(p.value < .01 ~ "<0.01", TRUE ~ str_pad(as.character(round(p.value, 2)),width=4,pad="0",side="right"))) %>%
  bind_rows(data.frame(cancer = "Cancer", HR_lab= "Hazard Ratio \n   (95% CI)",lower_95_log = "", upper_95_log="",p.value="p-value")) %>% 
  mutate(cancer = fct_rev(fct_relevel(cancer, "Cancer")))

p_left <- plot %>% 
  ggplot(aes(y = cancer)) + 
  geom_text(aes(x=0, label=cancer), hjust=0, fontface = "bold",size=4) +
  geom_text(aes(x=1, label=HR_lab), hjust=0,size=4,
            fontface = ifelse(plot$HR_lab == "Hazard Ratio \n   (95% CI)", "bold", "plain")) +
  theme_void() +coord_cartesian(xlim=c(0,4))

p_right <- plot %>% ggplot() +
  geom_text(aes(x=0, y=cancer, label=p.value), hjust=0,
            fontface = ifelse(plot$p.value == "p-value", "bold", "plain"),size=4) +
  theme_void() 

layout <- c(
  area(t = 0, l = 0, b = 30, r =4),
  area(t = 0, l = 4, b = 30, r = 9),
  area(t = 0, l = 9, b = 30, r = 11))

p_left + p_mid + p_right + plot_layout(design = layout)
  
