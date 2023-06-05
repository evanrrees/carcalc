library(shiny)

outputDiv <- function(outputId, label, colorId = NULL) {
  div(
    tags$label(`for` = outputId, label),
    textOutput(outputId),
    style = "padding-bottom: 0.5em"
  )
}