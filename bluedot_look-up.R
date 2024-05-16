library(tidyverse)
library(httr)
library(jsonlite)

# Disease codes
url <- "https://developer.bluedot.global/lookups/diseases[?diseaseName][&includeCsv]&api-version=v1"
