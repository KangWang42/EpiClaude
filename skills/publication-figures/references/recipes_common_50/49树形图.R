####公众号:医学学霸帮####

####公众号:医学学霸帮####




#install.packages("colorspace")
#install.packages("ggplot2")

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("ggtree")



library("ggplot2")
library("ggtree")
library("colorspace")
treFile="input.tre"           #进化树文件
groupFile="group.txt"         #树枝分类
outFile="tree.pdf"            #输出
setwd("D:\\biowolf\\bioR\\49.ggtree")     

#读取属性文件，把属性信息保存到list
cls=list()
rt=read.table(groupFile,sep="\t",header=T)
for(i in 1:nrow(rt)){
	otu=as.character(rt[i,1])
	phylum=as.character(rt[i,2])
	cls[[phylum]]=c(cls[[phylum]], otu)
}
phylumNames=names(cls)
phylumNum=length(phylumNames)

#读取进化树文件，和属性文件合并
tree=read.tree(treFile)
tree=groupOTU(tree, cls)

#绘制
pdf(file=outFile, width=7, height=7)
ggtree(tree, 
       layout="circular", 
       ladderize = F, 
       branch.length="none", 
       aes(color=group)) + 
       scale_color_manual(values=c(rainbow_hcl(phylumNum+1)),breaks=phylumNames, labels=phylumNames ) + 
       theme(legend.position="right") + 
       geom_text(aes(label=paste("                ",label,sep=""), 
       angle=angle+45), 
       size=2)
dev.off()


