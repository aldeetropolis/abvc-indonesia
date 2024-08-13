library(tidyverse)
library(httr)
library(jsonlite)
library(curl)

# Disease codes
## List all disease codes
url <- "https://developer.bluedot.global/lookups/diseases?api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "85cf3f345ff343f1a0cebcc80feea87d", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)

## Look up specific disease code based on string
disease_search <- function(string) {
  url <- paste0("https://developer.bluedot.global/lookups/diseases?diseaseName=", string, "&api-version=v1")
  res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "85cf3f345ff343f1a0cebcc80feea87d", "Cache-Control" = "no-cache")) |> content()
  data <- enframe(pluck(res, "data")) |> unnest_wider(value)
  return(data)
}

disease_search("oropouche")

# Locations ID
## List all location and number of population (sub-national level)
url <- "https://developer.bluedot.global/vulnerability-indicator/population-density/?locationType=4&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)

## Look up specific location based on string
location_search <- function(country, level) {
  url <- paste0("https://developer.bluedot.global/lookups/locations?locationType=", level, "&countryName=", country, "&api-version=v1")
  res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "85cf3f345ff343f1a0cebcc80feea87d", "Cache-Control" = "no-cache")) |> content()
  data <- enframe(pluck(res, "data")) |> unnest_wider(value)
  return(data)
}

location_search(country = "indonesia", level = 6)

# Airport code search
airport_search <- function(locationId) {
  url <- paste0("https://developer.bluedot.global/lookups/locations/", locationId, "/airports?api-version=v1")
  res <- GET(url, add_headers("Cache-Control" = "no-cache", "Ocp-Apim-Subscription-Key" = "85cf3f345ff343f1a0cebcc80feea87d")) |> content()
  data <- enframe(pluck(res, "data")) |> unnest_wider(value)
  return(data)
}

airport_search("1648471")

# Airport information based on Airport code
airport_info <- function(airportCode) {
  url <- paste0("https://developer.bluedot.global/lookups/airports?airportCodes=", airportCode, "&api-version=v1")
  res <- GET(url, add_headers("Cache-Control" = "no-cache", "Ocp-Apim-Subscription-Key" = "85cf3f345ff343f1a0cebcc80feea87d")) |> content()
  data <- enframe(pluck(res, "data")) |> unnest_wider(value)
  return(data)
}

airport_info("CGK")

# Newsfeeds Look-up
url <-  "https://developer.bluedot.global/daas/lookup/articles/themes/?api-version=v1"
res <- GET(url, add_headers("Cache-Control" = "no-cache", "Ocp-Apim-Subscription-Key" = "ae0e017fd9b9419a927a00f3f1524edb")) |> content()
newsfeeds_theme <- enframe(pluck(res, "data")) |> unnest_wider(value) |> unnest(tags)

# Disease Knowledge
url <- https://developer.bluedot.global/diseases/[?diseaseIds][&includeDiseaseOverview][&includeAgentProperties][&includeCsv]&api-version=v1

disease_knowledge <- function(disease) {
  url <- paste0("https://developer.bluedot.global/diseases/?diseaseIds=", disease, "&includeDiseaseOverview=true&includeAgentProperties=true&includeCsv=false&api-version=v1")
  res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
  data <- enframe(pluck(res, "data")) |> unnest_wider(value)
  return(data)
}

covid <- disease_knowledge(12)
flextable::flextable(covid)

url <- paste0("https://developer.bluedot.global/diseases/?includeDiseaseOverview=true&includeAgentProperties=true&includeCsv=false&api-version=v1")
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)
