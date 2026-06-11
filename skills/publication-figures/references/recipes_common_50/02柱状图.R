####公众号:医学学霸帮####

####公众号:医学学霸帮####


#设置工作目录
setwd("D:\\biowolf\\bioR\\02.barplotStat")

#读取输入文件
rt=read.table("input.txt", header=T, sep="\t",comment.char = "", check.names =FALSE)
tb=table(c(as.vector(rt[,1]),as.vector(rt[,2])))    #对两列进行统计
#tb=table(as.vector(rt[,1]))        #对一列进行统计//不用的代码加#
tb=sort(tb,decreasing =T) #频率高的排前面

#输入每个基因的邻接点节点数目
outTab=as.data.frame(tb)
colnames(outTab)=c("Gene","Count")
write.table(outTab,file="statResult.xls",sep="\t",quote=F,row.names=F)

#定义柱状图显示基因数目
showNum=30
if(nrow(tb)<showNum){
	showNum=nrow(outTab)
}
n=as.matrix(tb)[1:showNum,]

#绘制柱状图
pdf(file="barplot.pdf",width=7,height=6)
par(mar=c(5,7,2,3),xpd=T)
bar=barplot(n,horiz=TRUE,col="skyblue",names=FALSE,xlim=c(0,ceiling(max(n)/5)*5),xlab="Number of adjacent nodes")
text(x=n*0.95,y=bar,n)
text(x=-0.2,y=bar,label=names(n),xpd=T,pos=2)
dev.off()


