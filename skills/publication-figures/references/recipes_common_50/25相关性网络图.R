####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("igraph")


#引用包
library(igraph)
library(reshape2)

inputFile="input.txt"         
outFile="corNetwork.pdf"     
cutoff=0.4  #相关性阈值                  
setwd("D:\\biowolf\\bioR\\25.corNetwork")     

#读取输入文件
data=read.table(inputFile,header=T,sep="\t",row.names=1,check.names=F)
cordata=cor(t(data))

#保留相关性矩阵的一半
mydata = cordata
upper = upper.tri(mydata)
mydata[upper] = NA

#把相关性矩阵转换为数据框
df = data.frame(gene=rownames(mydata),mydata)
dfmeltdata = melt(df,id="gene")
dfmeltdata = dfmeltdata[!is.na(dfmeltdata$value),]
dfmeltdata = dfmeltdata[dfmeltdata$gene!=dfmeltdata$variable,]
dfmeltdata = dfmeltdata[abs(dfmeltdata$value)>cutoff,]

#定义网络图的节点和边
corweight = dfmeltdata$value
weight = corweight+abs(min(corweight))+5
d = data.frame(p1=dfmeltdata$gene,p2=dfmeltdata$variable,weight=dfmeltdata$value)
g = graph.data.frame(dfmeltdata,directed = FALSE)

#设置颜色，节点大小，字体大小
E(g)$color = ifelse(corweight>0,rgb(254/255,67/255,101/255,abs(corweight)),rgb(0/255,0/255,255/255,abs(corweight)))
V(g)$size = 8
V(g)$shape = "circle"
V(g)$lable.cex = 1.2
V(g)$color = "white"
E(g)$weight = weight

#可视化
pdf(outFile,width=7,height=6)
layout(matrix(c(1,1,1,0,2,0),byrow=T,nc=3),height=c(6,1),width=c(3,4,3))
par(mar=c(1.5,2,2,2))
vertex.frame.color = NA
plot(g,layout=layout_nicely,vertex.label.cex=V(g)$lable.cex,edge.width = E(g)$weight,edge.arrow.size=0,vertex.label.color="black",vertex.frame.color=vertex.frame.color,edge.color=E(g)$color,vertex.label.cex=V(g)$lable.cex,vertex.label.font=2,vertex.size=V(g)$size,edge.curved=0.4)

#绘制图例
color_legend = c(rgb(254/255,67/255,101/255,seq(1,0,by=-0.01)),rgb(0/255,0/255,255/255,seq(0,1,by=0.01)))
par(mar=c(2,2,1,2),xpd = T,cex.axis=1.6,las=1)
barplot(rep(1,length(color_legend)),border = NA, space = 0,ylab="",xlab="",xlim=c(1,length(color_legend)),horiz=FALSE,
        axes = F, col=color_legend,main="")
axis(3,at=seq(1,length(color_legend),length=5),c(1,0.5,0,-0.5,-1),tick=FALSE)
dev.off()



