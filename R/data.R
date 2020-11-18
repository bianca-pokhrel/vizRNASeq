#' Matrix of read counts using the pasilla package
#'
#' This data has been extracted and is a count matrix which can be used for examples.
#' Data package with per-exon and per-gene read counts of RNA-seq samples of
#' Pasilla knock-down by Brooks et al., Genome Research 2011.
#'
#' @format A matrix with each row representing gene, and each column is a
#' sequenced RNA library. Values are estimated counts.
#' \describe{
#'     \item{Columns 1, 2, 3}{Treated samples}
#'     \item{Columns 4, 5, 6, 7}{Untreated samples}
#' }
#'
#' @references
#'
"cts_matrix"


#' Matrix of read counts using the pasilla package
#'
#' This data has been extracted and is contains sample information which can be used in
#' conjunction with the provided count matrix for examples.
#' Data package with per-exon and per-gene read counts of RNA-seq samples of
#' Pasilla knock-down by Brooks et al., Genome Research 2011.
#'
#' @format A matrix with each row representing gene, and each column is a
#' sequenced RNA library. Values are estimated counts.
#' \describe{
#'     \item{Columns 1}{Condition}
#'     \item{Columns 2}{Type}
#' }
"sample_info"
