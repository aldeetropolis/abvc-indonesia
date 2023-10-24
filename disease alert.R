library(httr)
library(jsonlite)
library(tidyverse)
library(flextable)

url <- "https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=2023-09-01&locationIds=337996&includeBody=true&includeDuplicates=false&limit=1000&format=json&api-version=v1"
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
data <- enframe(pluck(res, "data")) |> unnest_wider(value) |> select(sourceUrl, sourceName, publishedDate, articleHeadline, articleBody)
flextable(data)
