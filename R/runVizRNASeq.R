#' Launch Shiny App for vizRNASeq
#'
#' A function that launches the Shiny app for vizRNASeq
#' The purpose of this app is
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'
#' vizRNASeq::runVizRNASeq()
#' }
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials. \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp
runVizRNASeq <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "vizRNASeq")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
# [END]
