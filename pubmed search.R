library(httr)
library(XML)

#
base <- "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/"
db <- "pubmed"
query <- "covid-19"
url <- paste(base, "esearch.fcgi?db=",db, "&term=", query, "&usehistory=y", sep = "")

res <- GET(url)

record <- xmlTreeParse(res, useInternalNodes = TRUE)
db_names <- xpathSApply(record, "//ResultItem/DbName", xmlValue)
