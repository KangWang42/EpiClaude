####公众号:医学学霸帮####

####公众号:医学学霸帮####



#install.packages("colorspace")
#install.packages("stringi")
#install.packages("ggplot2")
#install.packages("digest")
#install.packages("GOplot")

#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("org.Hs.eg.db")
#BiocManager::install("DOSE")
#BiocManager::install("clusterProfiler")
#BiocManager::install("enrichplot")


library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(ggplot2)
library(GOplot)

#过滤
pFilter=0.05
adjPfilter=0.05

setwd("D:\\biowolf\\bioR\\32.KEGGcircos")          #设置工作目录
rt=read.table("input.txt",sep="\t",header=T,check.names=F)       #读取id.txt文件
genes=as.vector(rt[,1])                                          #提取基因列表
entrezIDs=mget(genes, org.Hs.egSYMBOL2EG, ifnotfound=NA)         #找出基因对应id
entrezIDs=as.character(entrezIDs)
rt=cbind(rt,entrezID=entrezIDs)
rt=rt[is.na(rt[,"entrezID"])==F,]                                #去除id为NA的基因
gene=rt$entrezID

#KEGG富集分析
kk=enrichKEGG(gene = gene, organism = "hsa", pvalueCutoff =1, qvalueCutoff =1)
KEGG=as.data.frame(kk)
KEGG=KEGG[(KEGG$pvalue<pFilter & KEGG$p.adjust<adjPfilter),]
KEGG$geneID=as.character(sapply(KEGG$geneID,function(x)paste(rt$gene[match(strsplit(x,"/")[[1]],as.character(rt$entrezID))],collapse="/")))
write.table(KEGG,file="KEGG.txt",sep="\t",quote=F,row.names = F)       #保存富集结果

#获取KEGG信息
kegg=data.frame(Category = "ALL",ID = KEGG$ID,Term = KEGG$Description, Genes = gsub("/", ", ", KEGG$geneID), adj_pval = KEGG$p.adjust)
#读取基因的logFC
genelist <- data.frame(ID = rt$gene, logFC = rt$logFC)
row.names(genelist)=genelist[,1]

circ <- circle_dat(kegg, genelist)
termNum = 5                                              #限定Term数
termNum=ifelse(nrow(kegg)<termNum,nrow(kegg),termNum)
geneNum = nrow(genelist)                                 #限定基因数目

#绘制圈图
chord <- chord_dat(circ, genelist[1:geneNum,], kegg$Term[1:termNum])
pdf(file="KEGGcircos.pdf",width = 11,height = 11.2)
GOChord(chord, 
        space = 0.001,           #基因之间的间距
        gene.order = 'logFC',    #按照logFC对基因排序
        gene.space = 0.25,       #基因名跟圆圈的相对距离
        gene.size = 4,           #基因名字体大小
        border.size = 0.1,       #线条粗细
        process.label = 7)       #term字体大小
dev.off()

#绘制聚类圈图
pdf(file="KEGGcluster.pdf",width = 12,height = 9)
GOCluster(circ, as.character(kegg[1:termNum,3]))
dev.off()

