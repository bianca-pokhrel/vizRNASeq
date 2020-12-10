
#' Simple exploratory visualizations of RNASeq data from a DESeqDataSet object
#'
#' A function that uses the DESeq pipeline to convert a count matrix and table of sample.
#' This is for preprocessing the data to get it ready for cluster analysis. Additionally, as of present release,
#' this function performs conversion of matrix with multiple variables- ~ group + condition
#'
#' @param DE_seq_obj A DESeqDataSet object
#' @param gene_name The gene name for a single gene to explore
#' @param group_over A vector containing variables to group by to visualize plots.
#' @param result_table An optional parameter containing results table for respective DESeqDataSet.
#' This is used to create histograms and heatmaps. Can be transformed data as well ie. variance transformed
#'
#'
#' @export
#' @import DESeq2
#' @import pheatmap
#' @import ggplot2
#' @import grDevices
#' @import graphics
#' @import stats
#' @import utils
#'
#' @references
#'
#' R Core Team (2020). R: A language and environment for statistical computing.
#' R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.
#'
#'
#' Wolfgang Huber and Alejandro Reyes (2020). pasilla: Data
#' package with per-exon and per-gene read counts of RNA-seq
#' samples of Pasilla knock-down by Brooks et al., Genome
#' Research 2011.. R package version 1.18.0.
#'
#' Michael I. Love, S. (2020, October 27). Analyzing RNA-seq data with DESeq2.
#' Retrieved November 18, 2020,
#' from http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
#'
#' Love, M.I., Huber, W., Anders, S. Moderated estimation of
#' fold change and dispersion for RNA-seq data with DESeq2
#' Genome Biology 15(12):550 (2014)
#'
base_plots <- function(DE_seq_obj, gene_name, group_over, result_table) {
  # to create a plot of counts for a particular gene
  plotCounts(DE_seq_obj,
             gene = gene_name,
             intgroup = group_over)

  # to create a plot for normalized counts for a single gene over group
  # use library ggbeeswarm

  gCount <- plotCounts(DE_seq_obj,
                       gene = gene_name,
                       intgroup = group_over,
                       returnData = TRUE)
  ggplot(gCount,
         aes(x = group_over[1],
             y = group_over[2],
             color = group_over[1])) +
    scale_y_log10() + geom_point(size = 5) + geom_line()

  ggplot(gCount,
         aes(x = group_over[1],
             y = group_over[2],
             color = group_over[2])) +
    scale_y_log10() + geom_point(size = 5) + geom_line()

  # to create histogram of p-values if results is supplied (happens after pipeline is run)

  if (!(missing(result_table))) {
    hist(result_table$pvalue[result_table$baseMean > 1],
         breaks = 0:20/20,
         col = "pink", border = "white")
  }
}


#' Simple cluster visualizations of RNASeq data from a DESeqDataSet object. Standalone or interactive through ShinyApp
#'
#' A function that uses a DESeqDataSet object to produce beautiful visualizations of clustering with the option of either
#' hierarchal clustering or clustering by k-means. The default setting is hierarchical. For k-means clustering, there is also
#' an option to change the number of clusters
#'
#' @param typeCluster either "hier" for hierarchical clustering or "km" for k-means clustering
#' @param DESeqObj DESeqDataSet object to use for clustering
#' @param numClust number of clusters for k-means cluster modeling
#' @return a plot that is either a heatmap for hierarchical clustering or for k-means clustering
#'
#' @examples
#' # To be used with the Pasilla dataset provided
#' cluster_map<- cluster_map(typeCluster ="km",DESeqObj = DE_convert, numClust = 4)
#' @export
#'
#' @import DESeq2
#' @import edgeR
#' @import graphics
#' @import stats
#' @import reshape
#' @import gplots
#' @import DEFormats
#'
#' @references
#'
#' R Core Team (2020). R: A language and environment for statistical computing.
#' R Foundation for Statistical Computing, Vienna, Austria. URL https://www.R-project.org/.
#'
#'
#' Wolfgang Huber and Alejandro Reyes (2020). pasilla: Data
#' package with per-exon and per-gene read counts of RNA-seq
#' samples of Pasilla knock-down by Brooks et al., Genome
#' Research 2011.. R package version 1.18.0.
#'
#' Michael I. Love, S. (2020, October 27). Analyzing RNA-seq data with DESeq2.
#' Retrieved November 18, 2020,
#' from http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
#'
#' Love, M.I., Huber, W., Anders, S. Moderated estimation of
#' fold change and dispersion for RNA-seq data with DESeq2
#' Genome Biology 15(12):550 (2014)
#'
#' Warner, J. (n.d.). BitBio. Retrieved December 10, 2020,
#' from https://2-bitbio.com/2017/10/clustering-rnaseq-data-using-k-means.html
#'
#'  Andrzej Oleś (2020). DEFormats: Differential gene expression data formats converter. R package version
#'  1.18.0. https://github.com/aoles/DEFormats
cluster_map <- function(typeCluster, DESeqObj, numClust){


  # first need to convert DESeqObj into a DGEList and use edgeR, then normalizing data so we can cluster!
  # following is from edgeR
  dge = as.DGEList(DESeqObj)
  y <- calcNormFactors(dge)
  z <- cpm(dge, normalized.lib.size=TRUE)

  scaledata <- t(scale(t(z)))

  if (numClust < 1 | numClust > 10)
    return (NULL)
  if (typeCluster == "hier"){
    #plot a hierarchal cluster

    scaledata <- scaledata[complete.cases(scaledata),]

    hier_rows <- hclust(as.dist(1-cor(t(scaledata), method="pearson")), method="complete") # Cluster rows by Pearson correlation.
    hier_cols <- hclust(as.dist(1-cor(scaledata, method="spearman")), method="complete") # Clusters columns by Spearman correlation.

    # heatmap generated using BitBio reference: https://2-bitbio.com/2017/04/clustering-rnaseq-data-making-heatmaps.html
    plot1 <- heatmap.2(z,
              Rowv=as.dendrogram(hier_rows),
              Colv=as.dendrogram(hier_cols),
              col=redgreen(100),
              scale="row",
              margins = c(7, 7),
              cexCol = 0.7,
              labRow = F,
              main = "Heatmap.2",
              trace = "none")

    return(plot1)

  }
  else{
    #plot a k-means cluster

    set.seed(416)
    clusts <- kmeans(scaledata, centers=numClust, nstart = 1000, iter.max = 20)
    clusters <- clust$cluster

    clustcent <- sapply(levels(factor(clusters)), clust.centroid, scaledata, clusters)

    clustViz <- melt(clustcent)
    colnames(clustViz) <- c('sample','cluster','value')

    #plot
    kmeansPlot <- ggplot(clustViz, aes(x=sample,y=value, group=cluster, colour=as.factor(cluster))) +
      geom_point() +
      geom_line() +
      xlab("Sample") +
      ylab("Expression") +
      labs(title= "Cluster Expression",color = "Cluster")
    return(kmeansPlot)

  }
}

# small function to get the centroids for clusters- see BitBio reference
clust.centroid = function(i, dat, clusters) {
  ind = (clusters == i)
  colMeans(dat[ind,])
}
