context("testing for invalid cluster type")
test_that("cluster error upon invalid cluster type input", {
  data("DE_convert")

  expect_null(cluster_map<- cluster_map(
    typeCluster =  "PAM",
    DESeqObj = DE_convert,
    numClust = 4
  ) )

})

context("testing for invalid cluster number")
test_that("cluster error upon invalid cluster number input", {
  data("DE_convert")

  expect_null(cluster_map<- cluster_map(
    typeCluster =  "km",
    DESeqObj = DE_convert,
    numClust = -3
  ) )

})

context("testing for valid cluster type")
test_that("no cluster error upon valid cluster type input", {
  data("DE_convert")

  cluster_map<- cluster_map(
    typeCluster =  "km",
    DESeqObj = DE_convert,
    numClust = 4
  )

  expect_s3_class(cluster_map, c("gplots", "ggplot"))

})

