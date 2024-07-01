library(tidyverse)
library(httr)
library(jsonlite)
library(flextable)
library(lubridate)
library(maps)

data <- read.csv("files/Avian Influenza.csv")
colnames(data) <- c("id", "disease", "serotype", "lat", "long", "location", "country", "region", "observation_date", 
                    "report_date", "species", "diag_source", "human_affected", "human_death", "diag_status")
data$animal_case <- if_else(is.na(data$human_affected), 1, 0)
data$human_case <- if_else(is.na(data$human_affected), 0, data$human_affected)
data$human_deaths <- if_else(is.na(data$human_death), 0, data$human_death)

globe_data <- data |> group_by(country) |> 
  summarise(n_case = sum(human_case),
            n_death = sum(human_deaths),
            n_animal = sum(animal_case))

avianUrl <- "https://developer.bluedot.global/casecounts/?diseaseIds=6&subLocationTypes=4&startDate=2015-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- content(GET(avianUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")))
avianData <- enframe(pluck(res, "data")) |> unnest_wider(value) |> 
  unnest(minSources) |> unnest_wider(minSources) |> select(!c(maxSources)) |> 
  group_by(countryName) |> 
  summarise(n_case = sum(maxTotalReportedCases),
            n_death = sum(maxTotalDeaths)) |> 
  rename("country" = "countryName")

globe_df <- full_join(globe_data, avianData)

worldmap <- map_data("world") |> rename("country" = "region")
globe_map_data <- left_join(worldmap, globe_data, by = "country")
ggplot(globe_map_data, aes(long, lat)) +
  geom_polygon(aes(group = group, fill = n_animal))

ggplot(worldmap) + geom_polygon(aes(long, lat, group = group))
