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
library(DT)

other_country <- "2077456,1814991,1819730,102358,1835841,1668284,290557,2635167,1861060,1821275,289688,337996,1269750,2750405,2186224,286963,1168579,2017370,1227603,1966436,298795,1210997,2921044,130758,99237,248816,1522867,1282028,934292,1282988,6252001,1512440,290291,6251999,4043988,285570,1559582,2088628,1252634,2623032,2205218,660013,3017382,390903,3175395,798544,953987,2510769,2661886,2658434,2782113,2802361,357994,294640,192950,2029969,3144096,935317,1218197,690791"
ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Disease Event"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(width = 2,
        selectInput("country", "Pilih region:",
                        choices = c("ASEAN" = ams, "Other country" = other_country)),
        dateInput("start_date", "Start Date:"),
        actionButton("run", "Update Data")),
      column(width = 10,
             tabBox(width = 12, height = "675px",
               tabPanel("Newsfeed API",
                        DTOutput(outputId = "table_newsfeed")),
               tabPanel("Human Disease Case & Death",
                        DTOutput(outputId = "table_ebs"))
               )
             )
      )
    )
  )

# Define server logic required to draw a histogram
server <- function(input, output) {
  data_tab1 <- reactiveVal(NULL)
  data_tab2 <- reactiveVal(NULL)
  
  observeEvent(input$run, {
    # Get data from Newsfeed API
    varCountry <- input$country
    startDate <- input$start_date
    disease <- "4,6,7,10,13,15,19,37,38,39,40,41,43,47,53,55,62,64,83,84,88,11,113,115,136,141,153,156,164,166,172,174,200,202,203,204,205,206,207,212,215,216,224,239,264,275,281"
    url <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate, "&locationIds=", varCountry,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
    res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
    data1 <- enframe(pluck(res, "data")) |> unnest_wider(value) |> unnest(diseases) |> unnest(locations) |> 
      mutate(date = as.Date(publishedTimestamp)) |> select(sourceUrl, sourceName, date, diseases, locations, articleHeadline, articleSummary) |> 
      unnest_wider(diseases, names_sep = "_") |> unnest_wider(locations, names_sep = "_")
    
    # Get data from Human Disease Case & Death API
    url <- paste0("https://developer.bluedot.global/casecounts/?diseaseIds=", disease, "&locationIds=", varCountry, "&startDate=", startDate, "&isAggregated=false&includeSources=true&api-version=v1")
    res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "52bd528ca9cd407394791ca418a7b409", "Cache-Control" = "no-cache")) |> content()
    data2 <- enframe(pluck(res, "data")) |> unnest_wider(value) |> mutate(date = as.Date(reportedDate)) |> 
      select(date, diseaseName, countryName, minSources) |> unnest(minSources) |> 
      unnest_wider(minSources)
    
    # Update table
    data_tab1(data1)
    data_tab2(data2)
  })
  
  output$table_newsfeed <- renderDT(data_tab1(),
                           options = list(
                             autoWidth = TRUE,
                             columnDefs = list(
                               list(width = "50px", targets = c(1)),
                               list(width = "100px", targets = c(8,9))),
                             pageLength = 10,
                             scrollX = TRUE,
                             scrollY = "500px"
                           ))
  
  output$table_ebs <- renderDT(data_tab2(),
                               options = list(
                                 autoWidth = TRUE,
                                 columnDefs = list(
                                   list(width = "50px", targets = c(1)),
                                   list(width = "100px", targets = c(8,9))),
                                 pageLength = 10,
                                 scrollX = TRUE,
                                 scrollY = "500px"
                                 ))
}

# Run the application 
shinyApp(ui = ui, server = server)