####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggplot2")


#输入文件需要四列信息
#Term: GO或名称
#Ratio: 基因比例
#Count: 富集数目
#FDR: 矫正pֵ


library(ggplot2)          
inputFile="input.txt"      
outFile="bubble.pdf"       
setwd("D:\\biowolf\\bioR\\29.bubble")                
rt = read.table(inputFile, header=T, sep="\t", check.names=F)      

#按照Ratio对Term排序
labels=rt[order(rt$Ratio),"Term"]
rt$Term = factor(rt$Term,levels=labels)

#绘制
p = ggplot(rt,aes(Ratio, Term)) + 
    geom_point(aes(size=Count, color=FDR))
p1 = p + 
     scale_colour_gradient(low="red",high="blue") + 
     labs(color="FDR",size="Count",x="Gene ratio",y="Term")+
     theme(axis.text.x=element_text(color="black", size=10),axis.text.y=element_text(color="black", size=10)) + 
     theme_bw()
ggsave(outFile, width=7, height=5)      #保存



