library(httr)
library(jsonlite)
library(tidyverse)
library(flextable)

ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"
startDate <- "2024-02-21"
endDate <- "2024-02-21"
disease <- "4,6,7,10,13,15,19,37,38,39,40,41,43,47,53,55,62,64,83,84,88,11,113,115,136,141,153,156,164,166,172,174,200,202,203,204,205,206,207,212,215,216,224,239,264,275,281"

url <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate, "&locationIds=", ams,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
data <- enframe(pluck(res, "data")) |> unnest_wider(value) |> select(sourceUrl, sourceName, publishedTimestamp, articleHeadline, diseases, locations, articleSummary)

url <- "https://developer.bluedot.global/daas/lookup/articles/themes/?theme=INFECTIOUSDISEASES&api-version=v1"
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
data <- enframe(pluck(res, "data")) |> unnest_wider(value)