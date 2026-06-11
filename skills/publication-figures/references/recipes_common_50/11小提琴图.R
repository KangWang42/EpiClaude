####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


library(ggpubr)           
inputFile="input.txt"      
outFile="vioplot.pdf"      
setwd("D:\\biowolf\\bioR\\11.vioplot")    

#读取
rt=read.table(inputFile,header=T,sep="\t",check.names=F)
x=colnames(rt)[2]
y=colnames(rt)[3]
colnames(rt)=c("id","Type","Expression")

#s设置比较组
group=levels(factor(rt$Type))
rt$Type=factor(rt$Type, levels=group)
comp=combn(group,2)
my_comparisons=list()
for(i in 1:ncol(comp)){my_comparisons[[i]]<-comp[,i]}

#绘制
pdf(file=outFile, width=6, height=5)
ggviolin(rt, x="Type", y="Expression", fill = "Type", 
         xlab=x, ylab=y,
         legend.title=x,
         add = "boxplot", add.params = list(fill="white"))+ 
         stat_compare_means(comparisons = my_comparisons)
         #stat_compare_means(comparisons = my_comparisons,symnum.args=list(cutpoints = c(0, 0.001, 0.01, 0.05, 1), symbols = c("***", "**", "*", "ns")),label = "p.signif")
dev.off()

