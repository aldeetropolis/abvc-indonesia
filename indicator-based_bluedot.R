library(tidyverse)
library(jsonlite)
library(httr)

sgpUrl <- "https://developer.bluedot.global/casecounts/indicator-based/?locationIds=1880251&startDate=2023-01&sourceOrgNames=Ministry%20of%20Health%20Singapore&api-version=v1"
res <- GET(sgpUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
sgpData <- enframe(pluck(res, "data")) |> unnest_wider(value) |> 
  select(diseaseName, totalReportedCases, totalConfirmedCases) |> 
  arrange(diseaseName) |> group_by(diseaseName) |> 
  summarise(n = sum(totalReportedCases)) |> filter(n > 0)
flextable(sgpData)
#View(sgpData)