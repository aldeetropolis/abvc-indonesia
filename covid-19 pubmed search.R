library(RISmed)
library(writexl)

topic <- "covid-19"
query <- EUtilsSummary(topic, retmax = 100, mindate = "2023-06-28", maxdate = "2023-06-30")
summary(query)

records <- EUtilsGet(query)
data <- data.frame("Title"=ArticleTitle(records),"Abstract"=AbstractText(records), "PMID"=PMID(records))
write_xlsx(data, "pubmed covid-19 30 june 2023.xlsx")
