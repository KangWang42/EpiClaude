####公众号:医学学霸帮####

####公众号:医学学霸帮####



#if (!require("BiocManager"))
#    install.packages("BiocManager")
#BiocManager::install("maftools") #百度下载即可


library(maftools)            
inputFile='input.maf'        
outFile="waterfall.pdf"     
setwd("D:\\biowolf\\bioR\\50.waterfall")   
maf=read.maf(maf = inputFile )          

#绘制
pdf(file=outFile,width=7,height=6)
oncoplot(maf = maf, top = 30, fontSize = 0.8 ,showTumorSampleBarcodes = F )
dev.off()


