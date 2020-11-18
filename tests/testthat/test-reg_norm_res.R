test_that("reg_norm_res returns correct type", {
  data("cts_matrix")
  data("sample_info")
  data("DE_convert")
  reg_norm_res <- reg_norm_res(DE_convert)

  expect_type(reg_norm_res, "S4")
})
