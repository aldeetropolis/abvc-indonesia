library(RISmed)
library(writexl)
library(DT)

topic <- "covid-19"
query <- EUtilsSummary(topic, type = "esearch", db = "pubmed", retmax = 100, reldate = 6)
summary(query)

records <- EUtilsGet(query)
data <- data.frame("Title"=ArticleTitle(records),"Abstract"=AbstractText(records), "PMID"=PMID(records))
#write_xlsx(data, "pubmed covid-19 30 june 2023.xlsx")
datatable(data)
