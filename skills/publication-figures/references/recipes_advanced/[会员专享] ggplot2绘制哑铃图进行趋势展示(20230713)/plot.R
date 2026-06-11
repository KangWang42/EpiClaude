library(tidyverse)
library(ggh4x)

df1 <- read_tsv("data-1.xls")

df <- read_tsv("data.xls") %>%
  filter(!is.na(Raised))%>%
  select(Year,Accepted,Raised)%>%
  inner_join(df1,by="Year")%>%
  arrange(Year)%>%
  mutate(Nationality=as.factor(Nationality))%>%
  filter(Nationality%in%c("Kenya","United Kingdom","United States"))%>%
  mutate(Accepted=scale(Accepted,center = F, scale = TRUE),
         Raised=scale(Raised,center = F, scale = TRUE))


ridiculous_strips <- strip_themed(
  background_x = elem_list_rect(
    fill =  c("#DE9ED6FF","#709AE1FF","#E6956F")))


df %>% ggplot(aes(x=Year))+
  geom_point(aes(y=Accepted),shape=21,stroke=0.5,size=3,
             color="black",fill="#788FCE",key_glyph = draw_key_rect)+
  geom_point(aes(y=Raised),shape=21,stroke=0.5,size=3,fill="#E6956F",
             color="black",key_glyph = draw_key_rect)+
  geom_line(aes(y=Accepted,color="Accepted"),linewidth=1,key_glyph = draw_key_rect)+
  geom_line(aes(y=Raised,color="Raised"),linewidth=1,key_glyph = draw_key_rect)+
  geom_segment(aes(xend=Year,y=Accepted,yend=Raised),color="black")+
  facet_wrap2(~Nationality,strip = ridiculous_strips)+
  scale_x_continuous(breaks = c(2007,2010,2014,2017))+
  scale_colour_manual("",breaks = c("Accepted", "Raised"),
                      values = c("#788FCE", "#E6956F")) +
  guides(fill="none")+
  theme_minimal()+
  theme(text=element_text(size=10,color="black",face="bold"),
        strip.background = element_rect(color="#788FCE",fill="#788FCE"),
        strip.text = element_text(color="white",size=10,face="bold"),
        panel.spacing = unit(0,"cm"),
        legend.position = "top",
        axis.title= element_blank(),
        plot.margin = margin(0,10,10,10))

