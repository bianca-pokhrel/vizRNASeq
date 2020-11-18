test_that("mat-conversion returns DESeqDataSet", {

  data("cts_matrix")
  data("sample_info")

  mat_conversion <- mat_conversion(
    RNA_count_data = cts_matrix,
    sample_info_data = sample_info
  )
  expect_type(mat_conversion, "S4")
})

context("testing for invalid user input for count matrix")
test_that("mat-conversion error upon invalid user input", {
  data("sample_info")
  wrong_matrix = c(1, 5, 6, 8, 4)

  expect_error(mat_conversion <- mat_conversion(
    RNA_count_data = wrong_matrix,
    sample_info_data = sample_info
  ) )

})

context("testing for invalid user input for sample data")
test_that("mat-conversion error upon invalid user input", {
  wrong_info = c(1, 2, 3, 4,5)
  data("cts_matrix")

  expect_error(mat_conversion <- mat_conversion(
    RNA_count_data = cts_matrix,
    sample_info_data = wrong_info
  ) )

})

# [END]
