####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


library("ggpubr")           
inputFile="input.txt"      
outFile="pairDiff.pdf"     
ylab="BRCA1 expression"      #y轴名称
setwd("D:\\biowolf\\bioR\\14.pairDiff")     

#读取输入文件
data=read.table(inputFile,sep="\t",header=T,check.names=F,row.names=1)
cond1=colnames(data)[1]
cond2=colnames(data)[2]

#绘制
pdf(file=outFile, width=5, height=4)
ggpaired(data, cond1 = cond1, cond2 = cond2, fill = "condition", palette = "jco",
	legend.title="Condition",xlab="",ylab = ylab)+
    #stat_compare_means(paired = TRUE, label = "p.format", label.x = 1.35)
    stat_compare_means(paired = TRUE, symnum.args=list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns")),label = "p.signif",label.x = 1.35)
dev.off()


