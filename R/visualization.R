# this function is for exploratory analysis

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
    scale_y_log10() + geome_point(size = 5) + geom_line()

  ggplot(gCount,
         aes(x = group_over[1],
             y = group_over[2],
             color = group_over[2])) +
    scale_y_log10() + geome_point(size = 5) + geom_line()

  # to create histogram of p-values if results is supplied (happens after pipeline is run)

  if (!(missing(result_table))) {
    hist(result_table$pvalue[result_table$baseMean > 1],
         breaks = 0:10/20,
         col = "pink", border = "white")
  }
}
