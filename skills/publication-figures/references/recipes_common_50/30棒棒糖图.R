####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("ggpubr")


#输入文件需要有三列信息
#ONTOLOGY: GO分类(BP, CC, MF)
#Term: GO名称
#Count: 富集在每个GO上的数目


library(ggpubr)            
inputFile="input.txt"       
outFile="Lollipop.pdf"     
setwd("D:\\biowolf\\bioR\\30.Lollipop")     
rt=read.table(inputFile,header=T,sep="\t",check.names=F)    #读取

#绘制棒棒糖图
pdf(file=outFile,width=7,height=6)
ggdotchart(rt, x="Term", y="Count", color = "ONTOLOGY",group = "ONTOLOGY", 
          palette = "aaas",     #配色方案
          legend = "right",     #图例位置
          sorting = "descending",   #上升排序，区别于desc
          add = "segments",    #增加线段
          rotate = TRUE,       #横向显示
          dot.size = 5,        #圆圈大小
          label = round(rt$Count),   #圆圈内数值
          font.label = list(color="white",size=9, vjust=0.5),   #圆圈内数值字体设置
          ggtheme = theme_pubr())
dev.off()



