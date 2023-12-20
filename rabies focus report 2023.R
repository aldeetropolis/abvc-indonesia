library(tidyverse)
library(lubridate)

data <- read_csv("data rabies GHO.csv") |> filter(SpatialDimValueCode %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"))
