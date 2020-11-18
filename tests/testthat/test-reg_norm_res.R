test_that("reg_norm_res returns correct type", {
  data("cts_matrix")
  data("sample_info")

  DE_convert <- DESeqDataSetFromMatrix(
         countData = cts_matrix,
        colData = sample_info,
     design = ~ condition)

  info_rows <- rowSums(counts(DE_convert)) > 1
  DE_convert <- DE_convert[info_rows,]
  DE_convert <- DESeq(DE_convert)

  reg_norm_res <- reg_norm_res(DE_convert)

  expect_type(reg_norm_res, "S4")
})
