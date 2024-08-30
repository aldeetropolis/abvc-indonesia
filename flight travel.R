library(httr)
library(jsonlite)
library(tidyverse)

ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"

# Population Air Travel Historical Volumes
## Historical Air Travel Volumes
url <- paste0("https://developer.bluedot.global/travel/air/?destinationLocationIds=", 
              ams, 
              "&originAggregationType=6&destinationAggregatioType=6&startDate=2019-01&endDate=2019-02&api-version=v1")
res <- content(GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")))
data <- enframe(pluck(res, "data")) |> unnest_wider(value)
id <- data |> select(originCountryId, originCountryName) |> distinct()
df <- data |> group_by(destinationCountryName, originCountryName) |> 
  summarise(n = sum(nonstopPassengerVolume)) |> filter(n > 0) |> ungroup()
df_unique <- df |> select(originCountryName) |> distinct(originCountryName) |> 
  filter(!(originCountryName %in% c("Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam"))) |> 
  left_join(id, by = "originCountryName")

library(writexl)
write_xlsx(df_unique, "list of disease and country priority.xlsx")

# Historical Air Travel Volumes by Port of Exit, Entry, and Last Stop
url <- "https://developer.bluedot.global/travel/air/international[?originLocationIds][&destinationLocationIds][&originAggregationType][&destinationAggregationType][&startDate][&endDate][&includePortOfExit][&includeLastStopBeforeEntry][&includePortOfEntry][&includeCsv]&api-version=v1"

# Direct Flight Seating from Airtport to Airport
"https://developer.bluedot.global/travel-forecasted/air-direct-capacity/airport/origin/{originLocationId}/destination/{destinationLocationId}[?startDate][&endDate][&includeRouteDetails][&includeCsv]&api-version=v1"

# Direct Flight Seating from Country to Country
"https://developer.bluedot.global/travel-forecasted/air-direct-capacity/country/origin/{originLocationId}/destination/{destinationLocationId}[?startDate][&endDate][&includeCsv]&api-version=v1"

# Passenger Volume Forecast (Country to Country)
## Country to Country Passenger Volume Forecast
url <- "https://developer.bluedot.global/travel-forecasted/air-passenger-volume/country/origin/1605651/destination/1643084?api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)

## Country to/from Global Passenger Volume Forecast
url <- "https://developer.bluedot.global/travel-forecasted/air-passenger-volume/country/?destinationLocationIds=1643084&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)

# Passenger Volume Forecasts
passenger_vol_forecast <- function(origin, destination, startDate, endDate){
  url <- paste0("https://developer.bluedot.global/travel-forecasted/air-passenger-volume/?originLocationIds=", origin, "&destinationLocationIds=", destination, "&startDate=", startDate, "&endDate=", endDate, "&api-version=v1")
  res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
  enframe(pluck(res, "data")) |> unnest_wider(value)
}

data <- passenger_vol_forecast(1733045, 1643084, "2023-09", "2023-10")

data1 <- data |> group_by(destinationLocationName, originLocationName) |> summarise(n = sum(forecastedPassengerVolume))

# Airport to Airport Passenger Volume Forecast
url <- "https://developer.bluedot.global/travel-forecasted/air-passenger-volume/airport/origin/1605651/destination/1643084&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
data <- enframe(pluck(res, "data")) |> unnest_wider(value)

# from Africa with historical Mpox cases to ASEAN Member States
ams <- "1880251,1605651,1694008,1820814,1733045,1643084,1831722,1327865,1655842,1562822"
africa <- "239880,2260494,203312,192950,226074,2233387,2328926,2395170,357994,953987,433561,49518,2400553,2287781"

# Historical air travel passenger volume
url <- paste0("https://developer.bluedot.global/travel/air/?originLocationIds=", africa, "&destinationLocationIds=", ams, "&startDate=2023-01&endDate=2023-12&api-version=v1")
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "371e207132a2497f8e981a8d3264788b", "Cache-Control" = "no-cache")) |> content()
historical_flight_africa_asean <- enframe(pluck(res, "data")) |> unnest_wider(value) |> 
  group_by(originCountryName, destinationCountryName)

# Forecasted air travel passenger volume

# Sankey diagram of flight travel
library(tidygraph)
library(networkD3)

passenger_historical <- read_csv()

passenger_historical_tibble <- passenger_historical |> as_tibble() |> 
  mutate(row = row_number()) |> 
  pivot_longer(cols = c(-row, totalPassengerVolume))