library(httr)
library(jsonlite)
library(tidyverse)
library(writexl)

# Nipah
url <- "https://developer.bluedot.global/diseases/?diseaseIds=41&includeDiseaseOverview=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
disease <- enframe(pluck(res, "data")) |> unnest_wider(value)
acquisition <- enframe(pluck(res, "data", 1, "acquisitionModeGroups")) |> unnest_wider(value)
disease_info <- enframe(pluck(res, "data", 1, "diseaseOverview")) |> unnest_wider(value)

View(disease)
View(acquisition)
View(disease_info)

# Dengue
url <- "https://developer.bluedot.global/diseases/?diseaseIds=65&includeDiseaseOverview=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
disease <- enframe(pluck(res, "data")) |> unnest_wider(value)
acquisition <- enframe(pluck(res, "data", 1, "acquisitionModeGroups")) |> unnest_wider(value)
disease_info <- enframe(pluck(res, "data", 1, "diseaseOverview")) |> unnest_wider(value)

View(disease)
View(acquisition)
View(disease_info)

# Malaria
url <- "https://developer.bluedot.global/diseases/?diseaseIds=141&includeDiseaseOverview=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache")) |> content()
disease <- enframe(pluck(res, "data")) |> unnest_wider(value)
acquisition <- enframe(pluck(res, "data", 1, "acquisitionModeGroups")) |> unnest_wider(value)
disease_info <- enframe(pluck(res, "data", 1, "diseaseOverview")) |> unnest_wider(value)

View(disease)
View(acquisition)
View(disease_info)