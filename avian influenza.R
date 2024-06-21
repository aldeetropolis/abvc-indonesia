library(tidyverse)
library(httr)
library(jsonlite)
library(flextable)
library(writexl)
library(lubridate)

data <- read_csv("~/Downloads/Avian Influenza.csv")

avianUrl <- "https://developer.bluedot.global/casecounts/?diseaseIds=6&subLocationTypes=4&startDate=2015-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(avianUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
avianData <- enframe(pluck(res, "data")) |> unnest_wider(value) |> 
  unnest(minSources) |> unnest_wider(minSources) |> select(!c(maxSources))

data_reg <- avianData |> group_by(Region, `report date`) |> 
  summarize(n_affected = sum(`Humans Affected`), n_deaths = sum(`Human Deaths`)) |> 
  filter(!is.na(n_affected), Region == "Asia")

data_asia <- data |> filter(Region == "Asia") |> group_by(Country, `report date`) |> 
  summarise(n_affected = sum(`Humans Affected`), n_deaths = sum(`Human Deaths`)) |> 
  filter(!is.na(n_affected))

data_global <- avianData |> mutate(year = year(reportedDate)) |> 
  group_by(countryName, year)  |> 
  summarise(jumlahKasus = sum(minTotalReportedCases),
            jumlahKematian = sum(minTotalDeaths))

ggplot(data_asia, aes(x = `report date`, y = n_affected, fill = Country)) + 
  geom_bar(stat = "identity") +
  geom_text(aes(label = Country))

write_xlsx(data_global, "data avian influenza H5N1 global Bluedot 2020-2024.xlsx")
