#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(bs4Dash)
library(httr)
library(jsonlite)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Disease Event"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      dateInput("start_date",
                "Start Date:"),
    fluidRow(actionButton("run", "Run")),
    fluidRow(
      dataTableOutput('table')
    )
  )
  ))

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- eventReactive(input$run, {
    ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"
    startDate <- input$start_date
    endDate <- input$end_date
    disease <- "4,6,7,10,13,15,19,37,38,39,40,41,43,47,53,55,62,64,83,84,88,11,113,115,136,141,153,156,164,166,172,174,200,202,203,204,205,206,207,212,215,216,224,239,264,275,281"
    url <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate,"&endDate=", endDate, "&locationIds=", ams,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
    res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
    data <- enframe(pluck(res, "data")) |> unnest_wider(value) |> select(sourceUrl, sourceName, publishedTimestamp, articleHeadline, articleSummary) |> as_tibble()
    return(data)
    })

  output$table <- renderDataTable(data())
}

# Run the application 
shinyApp(ui = ui, server = server)