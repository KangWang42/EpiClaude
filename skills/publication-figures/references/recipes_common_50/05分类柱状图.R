####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


#输入文件需要有3列信息
#ONTOLOGY: GO分类,BP/CC/MF
#Term: GO名称
#Count: 富集在每个Term上基因数目


library(ggpubr)             #引用包
inputFile="input.txt"       #输入
outFile="barplot.pdf"       #输出
setwd("D:\\biowolf\\bioR\\05.barplotGroup")     
rt=read.table(inputFile,header=T,sep="\t",check.names=F)      #读取输入文件

#绘制
pdf(file=outFile,width=7,height=5)
ggbarplot(rt, x="Term", y="Count", fill = "ONTOLOGY", color = "white", 
          orientation = "horiz",   #横向显示
          palette = "aaas",    #配色方案
          legend = "right",    #图例位置
          sort.val = "asc",    #上升排序，区别于desc
          sort.by.groups=TRUE)+    #按组排序
          scale_y_continuous(expand=c(0, 0)) + scale_x_discrete(expand=c(0,0))
dev.off()


