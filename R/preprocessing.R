## Documentation for this: this function takes a count matrix and a table of sample information
# it then creates an DESeqDataSet object. Using the DESeqDataSet object from Bioconudctor,
# we can extend its function to cluster and visualize

# each row represents gene
# each column is a sequenced RNA library
# values are the estimated counts


# sample_info data has metadata on count table columns

#relationship helps with design to create DESeqDataSet

#' Converts a count matrix and table of sample information to a DESeqDataSet object.
#'
#' A function that uses the DESeq pipeline to convert a count matrix and table of sample.
#' This is for preprocessing the data to get it ready for cluster analysis. Additionally, as of present release,
#' this function performs conversion of matrix with multiple variables- ~ group + condition
#'
#' @param RNA_count_data A matrix with each row representing gene, and each column is a sequenced RNA library.Values are estimated counts.
#' @param sample_info_data A table of sample information that has metadata on count table columns
#'
#' @return A DESeqDataSet object for cluster analysis
#'
#' @examples
#'
#'  # Example 1:
#'  # Using pasilla dataset available with package
#'
#'  mat_conversion <- mat_conversion(cts_matrix, sample_info)
#'
#' @export
#' @import DESeq2
#' @import dplyr

mat_conversion <- function(RNA_count_data, sample_info_data) {
      # perform a check to see if the columns of count matrix correspond to
      # the rows of the info table

    # now need to convert matrix into DESeqDataSet
  # need to hardcode example bc there is a bug
  data("sample_info")

  DE_convert <- DESeqDataSetFromMatrix(
      countData = RNA_count_data,
      colData = sample_info_data,
      design = ~ condition
    )


  #filter out rows with no important info- basic filtering process.
  #Will expand later

  info_rows <- rowSums(counts(DE_convert)) > 1
  DE_convert <- DE_convert[info_rows,]

  # run the DE pipeline from bioconductor
  DE_convert <- DESeq(DE_convert)

  return(DE_convert)

}


# reg_norm_res takes in a DESeqDataSet from which we can build a results table and then
# perform- helpful if already using Bioconductor and already have DESeqDataSet
# returns normalized log2-transformed data

#' Runs DESeq2 pipeline and returns both log2 and variance stabilized log2 transformed data
#'
#' A function that takes in a DESeqDataSet and builds a result table which can be used
#' to perform cluster analysis. This function is helpful if already using Bioconductor workflow
#'  and already have a DESeqDataSet object.
#'
#'
#' @param DE_convert A DESeqDataSet object
#'
#' @return A variance stabilized log2 transformed data as DESeqDataSet objects.
#'
#' @examples
#' # Example 1:
#'# Using pasilla dataset available with package
#'
#'  DE_convert <- DESeqDataSetFromMatrix(
#'          countData = cts_matrix,
#'                   colData = sample_info,
#'                         design = ~ condition)
#'
#'    info_rows <- rowSums(counts(DE_convert)) > 1
#'       DE_convert <- DE_convert[info_rows,]
#'          DE_convert <- DESeq(DE_convert)
#'
#'           reg_norm_res <- reg_norm_res(DE_convert)
#'
#'
#' @export
#' @import DESeq2
reg_norm_res<- function(DE_convert) {

  # normal result building
  res <- results(DE_convert)


  #normalized result building through variance stabilization
  res_vst <- varianceStabilizingTransformation(DE_convert)


  return (res_vst)
}
