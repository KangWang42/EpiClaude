####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggplot2")

library(ggplot2)
library(reshape2)
inputFile="input.txt"        
outFile="vioplot.pdf"       
setwd("D:\\biowolf\\bioR\\13.vioplotFacet")      

#读取输入文件

rt=read.table(inputFile, header=T,sep="\t",check.names=F,row.names=1)
x=colnames(rt)[1]
colnames(rt)[1]="Type"


#差异分析
geneSig=c("")
for(gene in colnames(rt)[2:ncol(rt)]){
	rt1=rt[,c(gene,"Type")]
	colnames(rt1)=c("expression","Type")
	p=1
	if(length(levels(factor(rt1$Type)))>2){
		test=kruskal.test(expression ~ Type, data = rt1)
		p=test$p.value
	}else{
		test=wilcox.test(expression ~ Type, data = rt1)
		p=test$p.value
	}
	Sig=ifelse(p<0.001,"***",ifelse(p<0.01,"**",ifelse(p<0.05,"*","")))
	geneSig=c(geneSig,Sig)
}
colnames(rt)=paste0(colnames(rt),geneSig)


#把数据转换成ggplot2文件
data=melt(rt,id.vars=c("Type"))
colnames(data)=c("Type","Gene","Expression")

#绘制
p1=ggplot(data,aes(x=Type,y=Expression,fill=Type))+
    guides(fill=guide_legend(title=x))+
    labs(x = x, y = "Gene expression")+
	geom_violin()+ geom_boxplot(width=0.2,position=position_dodge(0.9))+ 
	facet_wrap(~Gene,nrow =1)+ theme_bw()+
	theme(axis.text.x = element_text(angle = 45, hjust = 1))

#出图
pdf(file=outFile, width=9, height=5)
print(p1)
dev.off()


#把数据转换成ggplot2文件
#差异分析
#绘制
#输出
