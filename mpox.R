library(tidyverse)
library(rio)
library(readxl)

data <- read_csv("owid-monkeypox-data.csv") |> filter(date >= "2023-01-01") |> 
  mutate(newCaseMA = round(zoo::rollmean(new_cases, k = 7, fill = NA), 2))

data_asean <- data |> 
  filter(location %in% c("Malaysia", "Philippines", "Singapore", "Thailand", "Vietnam"))

ggplot(data |> filter(location == "World"), aes(x = date, y = newCaseMA)) + geom_line()

