####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("plyr")
#install.packages("ggpubr")


#引用包
library(plyr)
library(ggpubr)
inputFile="input.txt"     #输入
outFile="boxplot.pdf"     #输出
setwd("D:\\biowolf\\bioR\\06.boxplotSort")       
rt=read.table(inputFile, sep="\t", header=T, check.names=F)    #读取输入文件
x=colnames(rt)[2]
y=colnames(rt)[3]
colnames(rt)=c("id","Type","expression")

#定义输出图片的排序方式
med=ddply(rt,"Type",summarise,med=median(expression))
rt$Type=factor(rt$Type, levels=med[order(med[,"med"],decreasing = T),"Type"])

#绘制
col=rainbow(length(levels(factor(rt$Type))))
p=ggboxplot(rt, x="Type", y="expression", color = "Type",
       palette = col,
       ylab=y,
       xlab=x,
       #add = "jitter",                                            #绘制每个样品的散点
       legend = "right")
pdf(file=outFile, width=10, height=6) #输出图片文件
p+rotate_x_text(60) #倾斜角度
dev.off()


