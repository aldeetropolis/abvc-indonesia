library(tidyverse)
library(jsonlite)
library(httr)

url <- paste0("https://developer.bluedot.global/assessments/?diseaseIds=", disease, "&locationIds=", varCountry, "&startDate=2023-01-01&formatWithHtml=TRUE&includeCsv=TRUE&api-version=v1")
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "52bd528ca9cd407394791ca418a7b409", "Cache-Control" = "no-cache")) |> content()
event <- enframe(pluck(res, "data")) |> unnest_wider(value) |> rowwise() %>% 
  mutate(across(where(is.list),
                ~paste0(.,collapse = ", ")))
View(event)

varCountry <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"
startDate <- "2024-07-01"
disease <- "15,141,83,164,84,166,55,53,88,38,63,13,4,205,10,43,26,153,156,162,6,110,113,136,212,215,216,224,264,200,41,40,39,37,64,239,47"
url1 <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate, "&locationIds=", varCountry,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
res1 <- content(GET(url1, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
data1 <- enframe(pluck(res1, "data")) |> unnest_wider(value) |> unnest(diseases) |> unnest(locations) |> 
  mutate(date = as.Date(publishedTimestamp)) |> select(sourceUrl, sourceName, date, diseases, locations, articleHeadline, articleSummary) |> 
  unnest_wider(diseases, names_sep = "_") |> unnest_wider(locations, names_sep = "_")

data <- enframe(pluck(res1, "data")) |> unnest_wider(value) |> rowwise() %>% 
  mutate(across(where(is.list),
                ~paste0(.,collapse = ", ")))

|> unnest(events) 


|> unnest(locations) |> 
  mutate(date = as.Date(publishedTimestamp)) |> select(sourceUrl, sourceName, date, diseases, locations, articleHeadline, articleSummary) |> 
  unnest_wider(diseases, names_sep = "_") |> unnest_wider(locations, names_sep = "_")