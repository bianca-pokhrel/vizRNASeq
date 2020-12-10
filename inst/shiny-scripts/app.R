library(shiny)
source("../../R/visualization.R")
load("../../data/cts_matrix.rda")
load("../../data/sample_info.rda")
load("../../data/DE_convert.rda")

ui <- fluidPage(
  titlePanel("Visualization of Clustering Methods"),

  sidebarLayout(
    sidebarPanel(
      helpText("Choose between different clustering methods to see the fit of the data"),

      selectInput(inputId = "var",
                  label = "Choose a clustering method:",
                  choices = list("Hierarchal Clustering (heatmap)",
                                 "K-means Clustering"
                                 ),
                  selected = "Hierarchal Clustering (heatmap)"),

      sliderInput(inputId = "num",
                  label = "Number of clusters",
                  value = 5, min = 1, max = 10),
    ),


    mainPanel(plotOutput("Cluster"))
  )
)

# typeCluster, DESeqObj, numClust)
server <- function(input, output) {
  output$Cluster <- renderPlot({
    data <- switch(input$var,
                   "Hierarchal Clustering (heatmap)" = "hier",
                   "K-means Clustering" = "km"
                   )

    visualizeRes <- cluster_map(
      typeCluster = input$var,
      DESeqObj = DE_convert,
      numClust = input$num
      )

    print(visualizeRes)

  })
}
shiny::shinyApp(ui = ui, server = server)
# [END]
