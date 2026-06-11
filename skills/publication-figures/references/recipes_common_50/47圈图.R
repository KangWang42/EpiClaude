####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("circlize")


library(circlize)       
bedFile1="bed1.txt"      
bedFile2="bed2.txt"      
outFile="circos.pdf"      
setwd("D:\\biowolf\\bioR\\47.circos")                  
bed1 = read.table(bedFile1, header=T, sep="\t", check.names=F)        #读取输入文件1
bed2 = read.table(bedFile2, header=T, sep="\t", check.names=F)        #2

#绘制
pdf(file=outFile, width=7, height=7)
circos.par("track.height" = 0.2, cell.padding = c(0, 0, 0, 0))
circos.initializeWithIdeogram()
circos.genomicLink(bed1, bed2, col =rainbow(nrow(bed1)), border = NA)#连线
circos.clear()
dev.off()


