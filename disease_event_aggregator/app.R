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
library(kableExtra)
library(knitr)

other_country <- "2077456,1814991,1819730,102358,1835841,1668284,290557,2635167,1861060,1821275,289688,337996,1269750,2750405,2186224,286963,1168579,2017370,1227603,1966436,298795,1210997,2921044,130758,99237,248816,1522867,1282028,934292,1282988,6252001,1512440,290291,6251999,4043988,285570,1559582,2088628,1252634,2623032,2205218,660013,3017382,390903,3175395,798544,953987,2510769,2661886,2658434,2782113,2802361,357994,294640,192950,2029969,3144096,935317,1218197,690791"
ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Disease Event"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tabsetPanel(
        tabPanel(title = "Newsfeed API",
                 sidebarLayout(
                   sidebarPanel(width = 1,
                     selectInput("country_1", "Pilih region:",
                                 choices = c("ASEAN" = ams, "Other country" = other_country)),
                     dateInput("start_date_1", "Start Date:"),
                     actionButton("run_1", "Update Data")),
                   mainPanel(width = 11, htmlOutput("table_newsfeed")))),
        tabPanel(title = "Human Disease Case & Death",
                 sidebarLayout(
                   sidebarPanel(width = 1,
                     selectInput("country_2", "Pilih region:",
                                 choices = c("ASEAN" = ams, "Other country" = other_country)),
                     dateInput("start_date_2", "Start Date:"),
                     actionButton("run_2", "Update Data")),
                   mainPanel(width = 11, htmlOutput("table_ebs")))),
        tabPanel(title = "Event Assessment",
                 sidebarLayout(
                   sidebarPanel(width = 1,
                                selectInput("country_3", "Pilih region:",
                                            choices = c("ASEAN" = ams, "Other country" = other_country)),
                                dateInput("start_date_3", "Start Date:"),
                                actionButton("run_3", "Update Data")),
                   mainPanel(width = 11, htmlOutput("table_event"))))
               )
             )
      )

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  disease <- "15,141,83,164,84,166,55,53,88,38,63,13,4,205,10,43,26,153,156,162,6,110,113,136,212,215,216,224,264,200,41,40,39,37,64,239,47"
  data1 <- eventReactive(input$run_1, {
    # Get data from Newsfeed API
    varCountry <- input$country_1
    startDate <- input$start_date_1
    url1 <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate, "&locationIds=", varCountry,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
    res1 <- content(GET(url1, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
    data1 <- enframe(pluck(res1, "data")) |> unnest_wider(value) |> rowwise() %>% 
      mutate(across(where(is.list),
                    ~paste0(.,collapse = ", ")))
    return(data1)
  })
  data2 <- eventReactive(input$run_2, {
    # Get data from Human Disease Case & Death API
    varCountry <- input$country_2
    startDate <- input$start_date_2
    url2 <- paste0("https://developer.bluedot.global/casecounts/?diseaseIds=", disease, "&locationIds=", varCountry, "&subLocationTypes=6&startDate=", startDate, "&isAggregated=false&includeSources=true&api-version=v1")
    res2 <- content(GET(url2, add_headers("Ocp-Apim-Subscription-Key" = "52bd528ca9cd407394791ca418a7b409", "Cache-Control" = "no-cache")))
    data2 <- enframe(pluck(res2, "data")) |> unnest_wider(value) |> unnest(minSources) |> 
      unnest_wider(minSources) |> mutate(date = as.Date(publishedDate)) |> 
      select(date, diseaseName, countryName, sourceTitle, sourceUrl, sourceCategory)
    return(data2)
    })
  
  data3 <- eventReactive(input$run_3, {
    # Get data from Disease Events Assessments
    varCountry <- input$country_3
    startDate <- input$start_date_3
    url3 <- paste0("https://developer.bluedot.global/assessments/?diseaseIds=", disease, "&locationIds=", varCountry, "&startDate=", startDate, "&formatWithHtml=true&includeCsv=false&api-version=v1")
    res3 <- content(GET(url3, add_headers("Ocp-Apim-Subscription-Key" = "52bd528ca9cd407394791ca418a7b409", "Cache-Control" = "no-cache")))
    data3 <- enframe(pluck(res3, "data")) |> unnest_wider(value) |> rowwise() %>% 
      mutate(across(where(is.list),
                    ~paste0(.,collapse = ", ")))
    return(data3)
  })
  
  output$table_newsfeed <- renderText(data1() |> mutate(sourceUrl = paste0("<a href='", sourceUrl, "'target='blank_'>Full text</a>")) |> kable("html", escape = FALSE) |> kable_styling(bootstrap_options = c("hover", "condensed"), full_width = FALSE) |> column_spec(12, width = "30em") |> scroll_box(height = "650px"))
  output$table_ebs <- renderText(data2() |> mutate(sourceUrl = cell_spec("Full text", "html", link = sourceUrl)) |> kable("html", escape = FALSE) |> kable_styling(bootstrap_options = c("hover", "condensed")) |> scroll_box(height = "650px"))
  output$table_event <- renderText(data3() |> kable("html", escape = FALSE) |> kable_styling() |> scroll_box(height = "650px"))
}

# Run the application 
shinyApp(ui = ui, server = server)