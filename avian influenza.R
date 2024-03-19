library(tidyverse)
library(httr)
library(jsonlite)
library(flextable)

data <- read_csv("~/Downloads/FAOSTAT_data_en_11-8-2023.csv")

ggplot(data, aes(x = ))

h5n1Url <- "https://developer.bluedot.global/casecounts/diseases/6?locationIds=1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201861060,%201835841,%201814991&startDate=2015-01-01&isAggregated=true&api-version=v1"
res <- GET(avianUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
avianData <- enframe(pluck(res, "data")) |> unnest_wider(value) |> select(diseaseName, countryName, totalReportedCases, totalConfirmedCases, totalSuspectedCases, totalDeaths)
flextable(avianData)


