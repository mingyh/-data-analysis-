library(scran)
library(scater)
library(scRNAseq)

# 读取CSV文件
data <- read.csv("qc_data.csv",row.names=1,  header = TRUE)

sce.zeisel <- ZeiselBrainData(data)

lib.sf.zeisel <- librarySizeFactors(sce.zeisel)
summary(lib.sf.zeisel)

set.seed(100)
clust.zeisel <- quickCluster(sce.zeisel)
table(clust.zeisel)

deconv.sf.zeisel <- calculateSumFactors(sce.zeisel, cluster=clust.zeisel)
summary(deconv.sf.zeisel)
# deconv.sf.zeisel <- logNormCounts(deconv.sf.zeisel)

plot(lib.sf.zeisel, deconv.sf.zeisel, xlab="Size factor",
    ylab="Count depth", log='xy', pch=16,
    col=as.integer(factor(sce.zeisel$level1class)))
abline(a=0, b=1, col="red")

