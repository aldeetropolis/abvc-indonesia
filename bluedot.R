library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)

# Variables
disease <- "200"
country <- "1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201966436"
startDate <- "2020-01"
endDate <- "2023-06-11"
aggregate <- "true"
sources <- "false"

# Human Disease Cases and Deaths based on Diseases

diseaseUrl <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201966436&startDate=2020-01&endDate=2023-06-01&isAggregated=true&api-version=v1" 
res <- GET(diseaseUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
data <- data.frame(t(sapply(parse$data,c)))
View(data)

# Human Disease Cases and Deaths based on Location

locationUrl <- "https://developer.bluedot.global/casecounts/locations/1643084?diseaseIds=200,%2055&startDate=2023-01&endDate=2023-06&isAggregated=true&api-version=v1"
res <- GET(locationUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
locationData <- data.frame(t(sapply(parse$data,c)))
View(locationData)

# Population Air Travel Historical Volumes
flightUrl <- "https://developer.bluedot.global/travel/air/?originLocationIds=1643084&destinationLocationIds=1643084&originAggregationType=4&destinationAggregationType=4&startDate=2022-06&endDate=2022-12&api-version=v1"
res <- GET(flightUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
data <- data.frame(t(sapply(parse$data,c)))
View(data)

# Vaccine Coverage
vaccUrl <- "https://developer.bluedot.global/vulnerability-indicator/vaccination/diseases/200/?countryIds=1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201966436&endDate=2023-06-11&&api-version=v1"
res <- GET(vaccUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
data <- data.frame(t(sapply(parse$data,c)))
data_edit <- data |> group_by(countryName) |> arrange(desc(reportedDate)) |> filter(row_number()==1)
data_edit$cumulativePeopleVaccinated <- as.numeric(data_edit$cumulativePeopleVaccinated)
data_edit$vaccinatedPercentage <- (data_edit$cumulativePeopleVaccinated*270203900)*100
data$reportedDate <- ymd(substr(data$reportedDate, 1, 10))
View(data)

# Look Up

url <- "https://developer.bluedot.global/lookups/diseases?api-version=v1"
res <- GET(locationUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))

url <- "https://developer.bluedot.global/assessments/55?startDate=2023-02-1&api-version=v1"
res <- GET(locationUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
data <- data.frame(t(sapply(parse$data,c)))