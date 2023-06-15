#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bs4Dash)
library(httr)
library(jsonlite)
library(tidyverse)

# Define UI for application that draws a histogram
header <- dashboardHeader(title = "Pengambilan Data")
sidebar <- dashboardSidebar()
body <- dashboardBody(
  fluidRow(selectInput("disease", "Choose disease: ",
                       choices = c(
                         "Dengue" = 55,
                         "COVID-19" = 200,
                         "Cholera" = 2,
                         "Diphteria" = 4,
                         "Highly Pathogenic Avian Influenza H5N1" = 6,
                         "Japanese Encephalitis" = 8,
                         "Measles" = 10,
                         "Mumps" = 12,
                         "Pertussis" = 13
                       )),
           selectInput("country", "Choose region: ",
                       choices = c(
                         "ASEAN" = "1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201966436",
                         "Indonesia" = "1643084",
                         "Brunei" = "1820814",
                         "Cambodia" = "1831722",
                         "Lao PDR" = "1655842",
                         "Malaysia" = "1733045",
                         "Myanmar" = "1327865",
                         "Singapore" = "1880251",
                         "Phillipines" = "1694008",
                         "Thailand" = "1605651",
                         "Vietnam" = "1562822"
                       )),
           selectInput("aggr", "Aggregate? ", choices = c("true", "false")),
           dateInput("startdate", "Start Date", format = "yyyy-mm-dd"),
           dateInput("enddate", "End date", format = "yyyy-mm-dd")
           ),
  fluidRow(actionButton("run", "Run")),
  fluidRow(dataTableOutput("table")),
  downloadButton('download',"Download the data")
)


ui <- dashboardPage(header, sidebar, body)


# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- eventReactive(input$run, {
    baseUrl <- "https://developer.bluedot.global/casecounts/diseases/" 
    headers = c(
      `Content-Type` = 'application/json',
      `Ocp-Apim-Subscription-Key` = '4b96d6008bfe499cbdf360de9890a080'
    )
    varDisease <- input$disease
    varCountry <- input$country
    varAggregate <- input$aggr
    startDate <- input$startdate
    endDate <- input$enddate
    full_url <- paste0(baseUrl, varDisease, "?locationIds=", varCountry, "&startDate=", startDate, "&endDate", endDate, "&isAggregated=", varAggregate, "&api-version=v1")
    res <- GET(full_url, add_headers(`Ocp-Apim-Subscription-Key` = '4b96d6008bfe499cbdf360de9890a080'))
    parse <- fromJSON(content(res, "text"))
    parse$data |> as_tibble()
  })
  output$table <- renderDataTable(data())
  output$download <- downloadHandler(
    filename = function(){"bluedot.csv"}, 
    content = function(fname){
      write.csv(data(), fname)
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)
