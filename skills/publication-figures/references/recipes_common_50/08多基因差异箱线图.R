####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


#引用包
library(reshape2)
library(ggpubr)
inputFile="input.txt"      #输入文件
outFile="boxplot.pdf"      #输出文件
setwd("D:\\biowolf\\bioR\\08.boxplotMulti")     #修改工作目录

#读取输入文件
rt=read.table(inputFile,sep="\t",header=T,check.names=F,row.names=1)
x=colnames(rt)[1]
colnames(rt)[1]="Type"

#把数据转换成gglpot2输入文件
data=melt(rt,id.vars=c("Type"))
colnames(data)=c("Type","Gene","Expression")

#绘制boxplot
p=ggboxplot(data, x="Gene", y="Expression", color = "Type", 
	     ylab="Gene expression",
	     xlab="",
	     legend.title=x,
	     palette = c("blue","red"),
	     width=0.6, add = "none")
p=p+rotate_x_text(60)
p1=p+stat_compare_means(aes(group=Type),
	      method="wilcox.test",
	      symnum.args=list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", " ")),
	      label = "p.signif")

#输出图片
pdf(file=outFile, width=6, height=5)
print(p1)
dev.off()

