#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyWidgets)
source("finance_utils.R")
source("server_utils.R")
source("ui_utils.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinythemes::shinytheme("flatly"),
  # shinythemes::themeSelector(),
  titlePanel("Car Cost Calculator"),
  fluidRow(
    column(
      width = 6,
      wellPanel(
        shinyWidgets::currencyInput(
          "sticker_price",
          "Sticker Price",
          value = 19056,
          format = "NorthAmerican",
          align = "left"
        ),
        shinyWidgets::currencyInput(
          "down_payment",
          "Down Payment",
          value = 5000,
          format = "NorthAmerican",
          align = "left"
        ),
        formatNumericInput(
          "interest_rate",
          "Interest Rate",
          value = 0.0775,
          format = "percentageUS2dec",
          align = "left"
        ),
        numericInput(
          "number_of_months",
          "Loan Term (months)",
          value = 36
        ),
        shinyWidgets::currencyInput(
          "offered_monthly_payment",
          "Monthly Payment",
          value = 498,
          format = "NorthAmerican",
          align = "left"
        ),
        shinyWidgets::currencyInput(
          "registration_fees",
          "Additional Financed Costs",
          value = 225,
          format = "NorthAmerican",
          align = "left"
        ),
        formatNumericInput(
          "tax_rate",
          "Sales Tax Rate",
          value = 0.09,
          format = "percentageUS2dec",
          align = "left"
        )
      )
    ),
    column(
      width = 6,
      fluidRow(
        column(
          width = 12,
          wellPanel(
            outputDiv("total_cost", "Total Cost"),
            outputDiv("total_payments", "Total of Monthly Payments"),
            div(
              style = "margin-left: 10%",
              outputDiv("total_interest", "Total Interest"),
              outputDiv("amount_financed", "Total Financed")
            )
          )
        )
      ),
      fluidRow(
        column(
          width = 12,
          wellPanel(
            outputDiv("amount_financed2", "Amount Financed"),
            div(
              style = "margin-left: 10%",
              outputDiv("principal_amount_financed", "Sticker Price Financed"),
              outputDiv("total_tax", "Total tax"),
              outputDiv("additional_fees", "Additional Financed Costs")
            ),
            outputDiv("cost_difference", "Unexplained Cost")
          )
        )
      )
    )
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  
  values <- reactiveValues(
    amount_financed = 0,
    total_tax = 0,
    total_interest = 0,
    total_cost = 0,
    cost_difference = 0,
    principal_amount_financed = 0,
    total_payments = 0
  )
  
  observe({
    values$amount_financed <- amount_financed(
      input$offered_monthly_payment,
      input$interest_rate,
      input$number_of_months
    )
  })
  observe({
    values$total_tax <- input$sticker_price * input$tax_rate
  })
  observe({
    values$total_payments <- input$offered_monthly_payment * input$number_of_months
  })
  observe({
    values$total_interest <- values$total_payments - values$amount_financed
  })
  observe({
    values$total_cost <- values$total_payments + input$down_payment
  })
  observe({
    values$principal_amount_financed <- input$sticker_price - input$down_payment
  })
  observe({
    values$cost_difference <- (
      values$amount_financed - 
        values$principal_amount_financed - 
        input$registration_fees - 
        values$total_tax
    )
  })
  
  output$amount_financed <- renderCurrency(values$amount_financed)
  output$amount_financed2 <- renderCurrency(values$amount_financed)
  output$total_tax <- renderCurrency(values$total_tax)
  output$total_interest <- renderCurrency(values$total_interest)
  output$cost_difference <- renderCurrency(values$cost_difference)
  output$total_cost <- renderCurrency(values$total_cost)
  output$principal_amount_financed <- renderCurrency(values$principal_amount_financed)
  output$total_payments <- renderCurrency(values$total_payments)
  output$additional_fees <- renderCurrency(input$registration_fees)
}

# Run the application 
shinyApp(ui = ui, server = server)
