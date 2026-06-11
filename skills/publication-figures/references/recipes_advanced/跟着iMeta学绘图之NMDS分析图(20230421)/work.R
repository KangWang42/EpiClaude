library(vegan)
library(tidyverse)
library(NST)
library(ggsci)
library(patchwork)


# Fig2AB NMDS 

# 读取18S V4 OTU丰度表和元数据
otu.18.v4 = read.table(file = "18SV4.norm.txt",sep="\t",row.names=1,header=T,check.names=F)
g.18.v4 = read.table(file = "group.v4.txt",sep="\t",row.names=1,header=T,check.names=F)

# 读取18S V9 OTU丰度表和元数据
otu.18.v9 = read.table(file = "18SV9.norm.txt",row.names=1,header=T,check.names=F)
g.18.v9 = read.table(file = "group.v9.txt",sep="\t",row.names=1,header=T,check.names=F)

# 对18S V4 OTU丰度表进行Hellinger标准化
otu.18.v4 = decostand(otu.18.v4,method = "hellinger")
x = otu.18.v4
group = g.18.v4

# 对18S V9 OTU丰度表进行Hellinger标准化
otu.18.v9 = decostand(otu.18.v9,method = "hellinger")
x = otu.18.v9
group = g.18.v9

# 定义一个NMDS分析函数
nmds <- function(x,group,dis="bray",try=100){
  
  # 判断使用的距离度量
  if (dis=="bray"){
    mds<-metaMDS(t(x), distance="bray", k=2, trymax=100) ;mds
  } else if(dis=="jaccard"){
    x = decostand(x,"pa")
    mds<-metaMDS(t(x), distance="jaccard", k=2, trymax=100) ;mds
  }
  
  # 获取NMDS分数
  out = mds$points
  out12 = out[,1:2]
  stress = round(mds$stress,4);stress
  stress<<-stress
  
  # 根据行名称匹配元数据
  rowgroup = rownames(group)
  rowsam = rownames(out12)
  mat = match(rowgroup,rowsam)
  sam = out12[mat,] 
  
  # 组合NMDS分数和元数据
  data.plot = cbind(sam,group)
}

# 对丰度表进行NMDS分析，返回NMDS分数和元数据的组合
data.plot = nmds(x,group,dis="bray",try=100)

# 设置ggplot2主题
plot_theme = theme(panel.background=element_blank(),
                   panel.grid=element_blank(),
                   axis.line.x=element_line(size=.5, colour="black"),
                   axis.line.y=element_line(size=.5, colour="black"),
                   axis.ticks=element_line(color="black"),
                   axis.text=element_text(color="black", size=10),
                   legend.position="right",
                   legend.background=element_blank(),
                   legend.key=element_blank(),
                   legend.text= element_text(size=10),
                   text=element_text(family="sans", size=10)
)

# 创建NMDS图p1
p1 <- ggplot(data.plot,aes(MDS1,MDS2))+
  geom_point(aes(colour = habitat),alpha=1,size = 2)+
  xlab("MDS1")+ylab("MDS2")+ labs(title = paste(dis,"\nstress =",stress,sep=" "))+
  plot_theme +
  theme_bw()+
  theme(axis.text= element_text(size=10, color="black", family  = "serif",
                                face= "bold", vjust=0.5, hjust=0.5),
        axis.title = element_text(size=10, color="black", family  = "serif",
                                  face= "bold", vjust=0.5, hjust=0.5),
        legend.text = element_text(colour = 'black', size = 10, 
                                   family  = "serif",face = 'bold'),
        legend.title=element_blank(),
        panel.grid.major=element_blank(),panel.grid.minor=element_blank(),
        plot.title=element_text(hjust=0.5))+
  scale_color_npg()


# 读取数据并计算距离矩阵
m4 = read.csv("parkv4.moss.txt", header = T, row.names = 1) %>%
  t() %>% vegdist(method = "bray") %>% dist.3col()

# v9
m9 = read.csv("parkv9.moss.txt", header = T, row.names = 1) %>%
  t() %>% vegdist(method = "bray") %>% dist.3col()

# 合并两个距离矩阵并准备绘图
m = cbind(m4[,1:2], v4 = m4$dis, v9 = m9$dis)
theme = theme(plot.title = element_text(hjust = 0.5, size = 10),
              axis.text = element_text(size = 10), axis.title = element_text(size = 10),
              legend.text = element_text(size = 10), legend.title = element_text(size = 10),
              legend.position = "NULL") +
  theme(axis.ticks = element_line(size = 0.2)) +  
  theme(axis.ticks.length = unit(0.1, "lines")) +  
  theme(panel.grid = element_blank()) +  
  theme(legend.position = "NULL")

# 绘制散点图并添加对角线

p.m <- ggplot(data=m,aes(x=v4,y=v9))+
  geom_point(color = "#00D200",size=2)+
  geom_abline(intercept = 0, slope = 1,size=0.2)+
  labs(x = "Dissimilarity (V4)",y = "Dissimilarity (V9)")+
  scale_y_continuous(limits = c(0,1),breaks=seq(0,1,0.2))+
  scale_x_continuous(limits = c(0,1),breaks=seq(0,1,0.2))+
  theme_bw()+theme

p1+p.m




