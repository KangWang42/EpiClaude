####公众号:医学学霸帮####

####公众号:医学学霸帮####


#install.packages("UpSetR")


library(UpSetR)
outFile="intersectGenes.txt"        #输出交集基因文件
outPic="upset.pdf"                  #输出图片
setwd("D:\\biowolf\\bioR\\21.UpSetR")      #设置工作目录

files=dir()                          #获取目录下所有文件
files=grep("txt$",files,value=T)     #提取.txt结尾的文件
geneList=list()

#获取所有txt文件中的基因信息，保存到geneList
for(i in 1:length(files)){
    inputFile=files[i]
	if(inputFile==outFile){next}
    rt=read.table(inputFile,header=F)         #读取输入文件
    geneNames=as.vector(rt[,1])               #提取基因名称
    geneNames=gsub("^ | $","",geneNames)      #去掉基因首尾的空格
    uniqGene=unique(geneNames)                #基因取unique，唯一基因列表
    header=unlist(strsplit(inputFile,"\\.|\\-"))
    geneList[[header[1]]]=uniqGene
    uniqLength=length(uniqGene)
    print(paste(header[1],uniqLength,sep=" "))
}

#绘制UpSetͼ
upsetData=fromList(geneList)
pdf(file=outPic,onefile = FALSE,width=9,height=6)
upset(upsetData,
      nsets = length(geneList),               #展示多少个数据
      nintersects = 50,                       #展示基因集数目
      order.by = "freq",                      #按照数目排序
      show.numbers = "yes",                   #柱状图上方是否显示数值
      number.angles = 20,                     #字体角度
      point.size = 2,                         #点的大小
      matrix.color="red",                     #交集点颜色
      line.size = 0.8,                        #线条粗细
      mainbar.y.label = "Gene Intersections", 
      sets.x.label = "Set Size")
dev.off()

#保存交集文件
intersectGenes=Reduce(intersect,geneList)
write.table(file=outFile,intersectGenes,sep="\t",quote=F,col.names=F,row.names=F)


