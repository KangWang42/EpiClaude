library(tidyverse)
library(data.table)
library(rworldmap)
library(maps)

# Figure 地图代码

world_map <- map_data("world")
map <- ggplot() + coord_fixed() +xlab("x") + ylab("y") + 
  geom_polygon(data=world_map, aes(x=long, y=lat, group=group), 
               fill="grey")

db<-read.csv('data.txt',sep=";")


db$alien_all<-with(db,alien_freq/pred_freq)
db<-db%>%mutate(PA=case_when(alien_freq>=1 ~1,
                             alien_freq<1 ~ 0))


all_perdata_all<-db %>% dplyr::select(Longitude,Latitude) %>%distinct()
all_perdata_alien<-db%>%filter(PA==1)%>%
  dplyr::select(Longitude,Latitude,alien_all)%>%distinct()

all_a_num<-map+ 
  geom_point(data=all_perdata_all,aes(x=Longitude, y=Latitude),
             shape=1,color='black',stroke=0.2)+
  geom_point(data=all_perdata_alien,aes(x=Longitude,y=Latitude,
                                        size=alien_all),color='blue',shape=1)+
  scale_y_continuous(name="Latitude°",breaks=seq(-80,80,40))+
  scale_x_continuous(name = "Longitude°",
                     breaks=seq(-160,160,80)) +
  scale_size_continuous(breaks =c(0.05,0.25,0.5,0.75,1),
                        name="Alien proportion")+
  theme_bw()+
  theme(
    panel.border=element_rect(fill=NULL,colour='black',linetype=1,size=0.5),
    axis.ticks.length=unit(0.08,"inch"),
    plot.title = element_text(size = 15),
    legend.text = element_text(colour="black", size = 10),
    legend.background = element_blank(),
    legend.key=element_blank(),
    axis.text.x = element_text(colour = "black", size = 12), 
    axis.text.y = element_text(colour = "black", size = 12),
    axis.title.x = element_text(colour='black',size=14,vjust=1),
    axis.title.y = element_text(colour='black',size=14,vjust=1),
    legend.position = c(0.15, 0.33))

#---------------------------------------------------------------
library(lme4)
library(data.table)
library(emmeans)
library(multcomp)
library(lme4)
library(tidyverse)
library(DHARMa)
library(stringr)

db<-read.csv(file ="data.txt",sep=";",stringsAsFactors=T)
db$alien_all<-with(db,alien_freq/pred_freq)

db$LU<- factor(db$LU,c("Primary","SV","Plantation","Pasture","Cropland","Urban"))

db$LUI<- factor(db$LUI,c("Cannot decide","Minimal use","Light use","Intense use"))

db$Alien.presence <- as.logical(db$alien_freq)
db.full.test <- subset(db,!(LU %in% "Urban" & LUI %in%"Intense use"))

db.full.test$LU = factor(db.full.test$LU, levels=c("Primary","SV","Plantation","Cropland","Pasture","Urban"))
db.full.test$LU = factor(db.full.test$LU, levels=c("Pasture","Urban","Cropland", "Plantation","SV", "Primary"))

db.full.test$LUI = factor(db.full.test$LUI, levels=c("Cannot decide","Minimal use","Light use","Intense use"))
db.full.test$LUI = factor(db.full.test$LUI, levels=c("Intense use", "Light use","Minimal use","Cannot decide"))

m <- glmer(Alien.presence ~ LU*LUI + (1|SS/SSB) , 
           data = db.full.test , family = binomial , 
           control = glmerControl(optimizer = "bobyqa" , 
                                  optCtrl = list(maxfun = 1e5)),
           nAGQ = 1 , subset = as.vector(db.full.test$LUI != "Cannot decide"))


m2 <- update(m , . ~ . -(1|SS/SSB) + (1|SS))
anova(m , m2) 

m2 <- update(m , . ~ . -LU:LUI)
anova(m , m2) 

pred.full<-m %>% emmeans(specs = ~LU+LUI , type = "response") %>%pairs(infer = T , adjust = "tukey")%>%as.data.frame()

data.2<-pred.full[grepl("Primary Minimal use",pred.full$contrast),]
data.2$contrast<-as.character(data.2$contrast)

data.2[18,]<-c("Primary Minimal / Primary Minimal use",1, NA,NA,NA,NA,NA,NA,NA)
library(stringr)
data.2[c('name1', 'name2')] <- str_split_fixed(data.2$contrast, '/', 2)
data.2[c('LU', 'LUI',"Use")] <- str_split_fixed(data.2$name1, ' ', 3)
data.2$LUI<-paste(data.2$LUI,data.2$Use)

data.3<-data.2[,c(1:9,12,13)]
data.3$LUI<-as.factor(data.3$LUI)

levels(data.3$LUI)[1:4]<-c("Intense use","Light use","Minimal use","Minimal use")
data.3$LU<-as.factor(data.3$LU)
levels(data.3$LU)[4:5]<-c("Primary","Secondary")

data.3$LU = factor(data.3$LU, levels=c("Primary","Secondary",
                                       "Plantation","Pasture","Cropland","Urban"))
data.3$LUI = factor(data.3$LUI, levels=c("Minimal use","Light use","Intense use"))

names(data.3)
data.3$odds.ratio<-as.numeric(data.3$odds.ratio)
data.3$SE<-as.numeric(data.3$SE)

ggplot(data.3 , aes(LU , odds.ratio,shape=LUI,color=LU))+
  geom_errorbar(aes(ymin = odds.ratio-SE , ymax = odds.ratio+SE) ,width=0.4, 
                position = position_dodge(width=.6))+
  scale_y_continuous(name="Odds ratio of alien occurrence",
                     limits=c(0,48),breaks=seq(0,45,15))+
  geom_point(aes(shape=LUI),position = position_dodge(width=.6),size=3.5)+
  scale_shape_manual(name="LU-intensity",values=c(16, 17, 15))+
  scale_color_manual(name='LU-types',
                     values = c("#2166AC","#4393C3","#92C5DE",
                                "#F4A582","red","#B2182B"),
                     label=c('Primary','Secondary','Plantation',
                             'Pasture','Cropland','Urban'))+
  guides(color=FALSE)+
  annotate(geom="text", x=1.2, y=7, label="*",size=7,color="#2166AC")+
  annotate(geom="text", x=1.81, y=7.5, label="***",size=7,color="#4393C3")+
  annotate(geom="text", x=2.2, y=10, label="***",size=7,color="#4393C3")+
  annotate(geom="text", x=2.81, y=11, label="**",size=7,color="#92C5DE")+
  annotate(geom="text", x=3, y=17, label="***",size=7,color="#92C5DE")+
  annotate(geom="text", x=3.22, y=11, label="***",size=7,color="#92C5DE")+ 
  annotate(geom="text", x=3.81, y=21, label="**",size=7,color="#F4A582")+
  annotate(geom="text", x=4, y=10, label="***",size=7,color="#F4A582")+
  annotate(geom="text", x=4.2, y=15, label="***",size=7,color="#F4A582")+
  annotate(geom="text", x=4.81, y=15, label="***",size=7,color="red")+
  annotate(geom="text", x=5.2, y=46, label="***",size=7,color="red")+
  annotate(geom="text", x=5.81, y=16, label="***",size=7,color="#B2182B")+ 
  annotate(geom="text", x=6, y=21, label="***",size=7,color="#B2182B")+ 
  theme_bw()+
  theme(panel.grid.major.x = element_blank() , 
        axis.ticks.length=unit(0.08,"inch"),
        panel.grid.major.y = element_line(size = 0.6 , colour = "grey90") ,
        panel.spacing = unit(0,"lines") , 
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_text(colour = "black",angle = 25,size = 12,vjust = 0.6) ,
        axis.text.y = element_text(colour = "black",  size = 12),
        legend.title = element_text(face = 'bold'),
        legend.background = element_blank(),
        legend.box.background = element_blank(),
        legend.key = element_blank(),
        legend.direction =  "horizontal",legend.position = c(0.4,0.9)) 

