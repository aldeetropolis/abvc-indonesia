library(tidyverse)
library(lubridate)
library(jsonlite)
library(httr)
library(gt)

country <- c(2077456, 1814991, 1819730, 102358, 1835841, 1668284, 290557, 2635167, 1861060, 1821275, 289688, 337996, 1269750, 2750405, 2186224, 286963, 1168579, 2017370, 1227603, 1966436, 298795, 1210997, 2921044, 130758, 99237, 248816, 1522867, 1282028, 934292, 1282988, 6252001, 1512440, 290291, 6251999, 4043988, 285570, 1559582, 2088628, 1252634, 2623032, 2205218, 660013, 3017382, 390903, 3175395, 798544, 953987, 2510769, 2661886, 2658434, 2782113, 2802361, 357994, 294640, 192950, 2029969, 3144096, 935317, 1218197, 690791)
ams <- c(1880251, 1605651, 1694008, 1820814, 1733045, 1643084, 1831722, 1327865, 1655842,1562822)
disease <- "4,6,7,10,13,15,19,37,38,39,40,41,43,47,53,55,62,64,83,84,88,11,113,115,136,141,153,156,164,166,172,174,200,202,203,204,205,206,207,212,215,216,224,239,264,275,281"
ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"
startDate <- "2023-02-18"
endDate <- "2024-02-24"

# Bluedot - Human Disease Case & Death
url <- paste0("https://developer.bluedot.global/casecounts/?diseaseIds=", disease, "&locationIds=", ams, "&startDate=", startDate, "&endDate=", endDate, "&isAggregated=false&includeSources=true&api-version=v1")
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "52bd528ca9cd407394791ca418a7b409", "Cache-Control" = "no-cache")) |> content()
ams_ebs <- enframe(pluck(res, "data")) |> unnest_wider(value) |> mutate(date = as.Date(reportedDate)) |> 
  select(date, diseaseName, countryName, minSources) |> unnest(minSources) |> 
  unnest_wider(minSources)

ams_ebs <- data.frame()
for (i in ams){
  url <- paste0("https://developer.bluedot.global/casecounts/locations/", i, "?startDate=", startDate, "&endDate=", endDate, "&isAggregated=false&includeSources=true&api-version=v1")
  res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
  length_df <- length(res$data)
  ebs <- data.frame()
  for (i in 1:length_df){
    country_name <- pluck(res, "data", i, "countryName")
    disease_name <- pluck(res, "data", i, "diseaseName")
    vec <- enframe(pluck(res, "data", i, "sources")) |> unnest_wider(value)
    vec$name <- disease_name
    vec$country <- country_name
    ebs <- rbind(ebs, vec)
  }
  ams_ebs <- rbind(ams_ebs, ebs)
}

# Bluedot - Event Alert and Assessments
url <- paste0("https://developer.bluedot.global/assessments/?startDate=2024-01-01&api-version=v1")
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
length_df <- length(res$data)
event <- data.frame()
for (i in 1:length_df){
  data <- enframe(pluck(res, "data", i)) |> pivot_wider(names_from = name, values_from = value)
  diseases <- enframe(pluck(res, "data", i, "diseases")) |> unnest_wider(value)
  locations <- enframe(pluck(res, "data", i, "locations")) |> unnest_wider(value)
  species <- enframe(pluck(res, "data", i, "species")) |> unnest_wider(value)
  sources <- enframe(pluck(res, "data", i, "sources"))
  join <- cbind(event, data, diseases, species, locations, sources)
  event <- rbind(event, join)
}

data <- enframe(pluck(res, "data", 1)) |> pivot_wider(names_from = name, values_from = value)
disease_name <- pluck(res, "data", 1, "diseases", 1, "diseaseName")
locations <- enframe(pluck(res, "data", 1, "locations")) |> unnest_wider(value)
species <- enframe(pluck(res, "data", 1, "species")) |> unnest_wider(value)
sources <- enframe(pluck(res, "data", 1, "sources"))
join <- cbind(event, data, diseases, species, locations, sources)
event <- rbind(event, join)

# Bluedot - Newsfeed
url <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate, "&locationIds=", ams,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
data <- enframe(pluck(res, "data")) |> unnest_wider(value) |> unnest(diseases) |> unnest(locations)|> unnest_wider(diseases, names_sep = "_") |> unnest_wider(locations, names_sep = "_")
DT::datatable(data)

|> select(sourceUrl, sourceName, publishedTimestamp, articleHeadline, diseases, locations, articleSummary)
diseaseName <- enframe(pluck(res, "data", 10, "diseases")) |> select(-name) |> unnest_wider(value)

url <- paste0("https://developer.bluedot.global/daas/articles/infectious-diseases/?startDate=", startDate, "&locationIds=", ams,"&diseaseId=", disease, "&includeBody=false&includeDuplicates=false&excludeArticlesWithoutEvents=false&limit=1000&format=json&api-version=v1")
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
length_df <- length(res$data)
event <- data.frame()
for (i in 1:length_df) {
  data <- enframe(pluck(res, "data")) |> unnest_wider(value) |> select(sourceUrl, sourceName, publishedTimestamp, articleHeadline, diseases, locations, articleSummary)
  diseaseName <- diseaseName <- enframe(pluck(res, "data", i, "diseases")) |> select(-name) |> unnest_wider(value)
  join <- cbind(data, diseaseName)
  event <- rbind(event, join)
}

url <- "https://developer.bluedot.global/daas/lookup/articles/themes/?theme=INFECTIOUSDISEASES&api-version=v1"
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")))
data <- enframe(pluck(res, "data")) |> unnest_wider(value)

data |> map(diseases) |> reduce(diseases)

df <- unnest(data, diseases)









