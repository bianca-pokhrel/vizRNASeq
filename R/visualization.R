
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

  # to create histogram and heatmap of p-values if results is supplied (happens after pipeline is run)

  if (!(missing(result_table))) {
    hist(result_table$pvalue[result_table$baseMean > 1],
         breaks = 0:20/20,
         col = "pink", border = "white")

    pheatmap(cor(result_table), color = colors)
  }
}
