library(tidyverse)
library(jsonlite)
library(httr)

url <- "https://developer.bluedot.global/assessments/?diseaseIds=4,13,10,15,172,174&locationIds=1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822&startDate=2023-01-01&formatWithHtml=TRUE&includeCsv=TRUE&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "52bd528ca9cd407394791ca418a7b409", "Cache-Control" = "no-cache")) |> content()
event <- enframe(pluck(res, "data")) |> unnest_wider(value)
View(event)
