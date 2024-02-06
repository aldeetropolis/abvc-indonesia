library(tidyverse)
library(httr)
library(jsonlite)

ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"
disease <- "141,55,53,88,38,63,13,4,205,10,43,26,153,156,162,6,110,113,136,212,215,216,224,264,200,41,40,39,37,64,239,47"
url <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=2023-02-03&locationIds=", ams, "&diseaseIds=", disease, "&includeBody=false&includeDuplicates=true&excludeArticlesWithoutEvents=false&format=json&api-version=v1")
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)