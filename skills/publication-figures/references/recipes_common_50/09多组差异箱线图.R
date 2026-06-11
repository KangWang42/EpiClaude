####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


library(ggpubr)           
inputFile="input.txt"      
outFile="boxplot.pdf"      
setwd("D:\\biowolf\\bioR\\09.boxplotClinical")    

#读取输入文件
rt=read.table(inputFile,sep="\t",header=T,check.names=F)
x=colnames(rt)[2]
y=colnames(rt)[3]
colnames(rt)=c("id","Type","Expression")

#设置比较租
group=levels(factor(rt$Type))
rt$Type=factor(rt$Type, levels=group)
comp=combn(group,2)
my_comparisons=list()
for(i in 1:ncol(comp)){my_comparisons[[i]]<-comp[,i]}

#绘制boxplot
boxplot=ggboxplot(rt, x="Type", y="Expression", color="Type",
		          xlab=x,
		          ylab=y,
		          legend.title=x,
		          add = "jitter")+ 
	    stat_compare_means(comparisons = my_comparisons)

#输出图片
pdf(file=outFile, width=5.5, height=5)
print(boxplot)
dev.off()


