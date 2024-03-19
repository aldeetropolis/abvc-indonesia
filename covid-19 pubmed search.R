library(RISmed)
library(writexl)
library(DT)
library(shiny)

topic <- "covid-19"
query <- EUtilsSummary(topic, type="esearch", db="pubmed", reldate = 7)
summary(query)

records <- EUtilsGet(query)
data <- data.frame("Title"=ArticleTitle(records),"Abstract"=AbstractText(records), "PMID"=PMID(records))
#write_xlsx(data, "pubmed covid-19 30 june 2023.xlsx")
renderDataTable(data)

ui <- shinyUI(fluidPage(
  title = 'Covid-19 related publication for the past 7 days',
  fluidRow(
    column(2),
    column(8, DT::dataTableOutput('tbl_a')),
    column(2)
  )
))

server <- shinyServer(function(input, output, session) {
  output$tbl_a = DT::renderDataTable(data)
})

shinyApp(ui, server)