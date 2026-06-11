####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")



library(reshape2)
library(ggpubr)
inputFile="input.txt"      
outFile="vioplot.pdf"     
setwd("D:\\biowolf\\bioR\\12.vioplotMulti")    

#读取文件
rt=read.table(inputFile,header=T,sep="\t",check.names=F,row.names=1)
x=colnames(rt)[1]
colnames(rt)[1]="Type"

#把数据转换成ggplot2数据文件
data=melt(rt,id.vars=c("Type"))
colnames(data)=c("Type","Gene","Expression")

#绘制小提琴图
p=ggviolin(data, x="Gene", y="Expression", color = "Type", 
	     ylab="Gene expression",
	     xlab=x,
	     legend.title=x,
	     add.params = list(fill="white"),
	     palette = c("blue","red"),
	     width=1, add = "boxplot")
p=p+rotate_x_text(60)
p1=p+stat_compare_means(aes(group=Type),
	      method="wilcox.test",
	      symnum.args=list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", " ")),
	      label = "p.signif")

#输出
pdf(file=outFile, width=6, height=5)
print(p1)
dev.off()


