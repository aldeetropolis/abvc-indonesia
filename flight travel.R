library(httr)
library(jsonlite)
library(tidyverse)

# Historical Air Travel Volumes
url <- "https://developer.bluedot.global/travel/air/?originLocationIds=1269750&destinationLocationIds=1643084&originAggregationType=4&destinationAggregationType=4&startDate=2019-01-01&endDate=2019-12-31&api-version=v1"
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")))

# Historical Air Travel Volumes by Port of Exit, Entry, and Last Stop
https://developer.bluedot.global/travel/air/international[?originLocationIds][&destinationLocationIds][&originAggregationType][&destinationAggregationType][&startDate][&endDate][&includePortOfExit][&includeLastStopBeforeEntry][&includePortOfEntry][&includeCsv]&api-version=v1

# Direct Flight Seating from Airtport to Airport
https://developer.bluedot.global/travel-forecasted/air-direct-capacity/airport/origin/{originLocationId}/destination/{destinationLocationId}[?startDate][&endDate][&includeRouteDetails][&includeCsv]&api-version=v1

# Direct Flight Seating from Country to Country
https://developer.bluedot.global/travel-forecasted/air-direct-capacity/country/origin/{originLocationId}/destination/{destinationLocationId}[?startDate][&endDate][&includeCsv]&api-version=v1