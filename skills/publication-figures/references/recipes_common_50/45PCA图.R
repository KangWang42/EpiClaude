####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggplot2")


library(ggplot2)          #???ð?
inputFile="input.txt"     #?????ļ?????
outFile="PCA.pdf"         #?????ļ?????
setwd("D:\\biowolf\\bioR\\45.PCA")    #???ù???Ŀ¼


rt=read.table(inputFile,header=T,sep="\t",check.names=F,row.names=1)
data=rt[,c(2:ncol(rt))]
Type=rt[,1]
var=colnames(rt)[1]

#PCA分析
data.pca=prcomp(data, scale. = TRUE)
pcaPredict=predict(data.pca)
PCA = data.frame(PC1=pcaPredict[,1], PC2=pcaPredict[,2], Type=Type)

#定义颜色
col=c("red","blue")
if(length(levels(factor(Type)))>2){
	col=rainbow(length(levels(factor(Type))))}

#绘制PCA
pdf(file=outFile, height=4.5, width=5.5)       #???????????ļ?
p=ggplot(data = PCA, aes(PC1, PC2)) + geom_point(aes(color = Type)) +
		 scale_colour_manual(name=var,  values =col)+
	     theme_bw()+
	     theme(plot.margin=unit(rep(1.5,4),'lines'))+
	     theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
print(p)
dev.off()

