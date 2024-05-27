library(tidyverse)
library(httr)
library(jsonlite)
library(flextable)

data <- read_csv("~/Downloads/Avian Influenza.csv")

ggplot(data, aes(x = ))

h5n1Url <- "https://developer.bluedot.global/casecounts/diseases/6?locationIds=1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201861060,%201835841,%201814991&startDate=2015-01-01&isAggregated=true&api-version=v1"
res <- GET(avianUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
avianData <- enframe(pluck(res, "data")) |> unnest_wider(value) |> select(diseaseName, countryName, totalReportedCases, totalConfirmedCases, totalSuspectedCases, totalDeaths)
flextable(avianData)

data_reg <- data |> group_by(Region, `report date`) |> 
  summarize(n_affected = sum(`Humans Affected`), n_deaths = sum(`Human Deaths`)) |> 
  filter(!is.na(n_affected), Region == "Asia")

data_asia <- data |> filter(Region == "Asia") |> group_by(Country, `report date`) |> 
  summarise(n_affected = sum(`Humans Affected`), n_deaths = sum(`Human Deaths`)) |> 
  filter(!is.na(n_affected))

ggplot(data_asia, aes(x = `report date`, y = n_affected, fill = Country)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(label = Country))
