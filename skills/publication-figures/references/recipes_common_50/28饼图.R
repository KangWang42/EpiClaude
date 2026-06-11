####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("plotrix")


library("plotrix")         
inputFile="input.txt"      
outFile="pie.pdf"          
setwd("D:\\biowolf\\bioR\\28.pie")     

#读取文件，整理
rt=read.table(inputFile,header=T,sep="\t",check.names=F)
x=rt[,2]
labels=as.character(rt[,1])

#求个部分百分率
piepercent=paste(round(100*x/sum(x), 2), "%")
labels=paste0(labels,"\n",piepercent)

#绘制饼图
pdf(file = outFile,width=7,height=6)            #保存图片
pie3D(x, labels = labels, height=0.1, labelcex=0.8,
      explode =0.1, theta=0.85)   #explode:离中心距离  theta:观看角度    
dev.off()



