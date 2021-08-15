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

deconv.sf.zeisel <- computeSumFactors(sce.zeisel, cluster=clust.zeisel)
summary(deconv.sf.zeisel)

sce.pbmc <- logNormCounts(deconv.sf.zeisel)

dec.pbmc <- modelGeneVar(sce.pbmc)

# Visualizing the fit:
fit.pbmc <- metadata(dec.pbmc)
plot(fit.pbmc$mean, fit.pbmc$var, xlab="Mean of log-expression",
    ylab="Variance of log-expression")
curve(fit.pbmc$trend(x), col="dodgerblue", add=TRUE, lwd=2)

