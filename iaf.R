library(tidyverse)

data <- read_csv("~/Downloads/weekly AFR cases by country as of 25 August 2024.csv")

df <- data |> filter(country %in% c("Ghana", "Liberia", "Rwanda", "Eswatini", "Tanzania",
                                    "Zimbabwe", "Algeria", "Angola", "Cameroon",
                                    "Côte d’Ivoire", "Democratic Republic of the Congo", "Egypt",
                                    "Kenya", "Madagascar", "Mauritania", "Morocco", "Mozambique",
                                    "Namibia", "Nigeria", "Uganda", "South Africa", "Ethiopia", 
                                    "Botswana")) |> 
  arrange(week_end_date) |> 
  select(country, total_confirmed_cases, total_deaths) |> 
  group_by(country) |> 
  slice(n())

df_new <- data |> filter(country %in% c("Ghana", "Liberia", "Rwanda", "Eswatini", "Tanzania",
                                        "Zimbabwe", "Algeria", "Angola", "Cameroon",
                                        "Côte d’Ivoire", "Democratic Republic of the Congo", "Egypt",
                                        "Kenya", "Madagascar", "Mauritania", "Morocco", "Mozambique",
                                        "Namibia", "Nigeria", "Uganda", "South Africa", "Ethiopia", 
                                        "Botswana"),
                         week_end_date >= "2024-06-30") |> 
  arrange(week_end_date) |> 
  select(country, new_confirmed_cases, new_deaths) |> group_by(country) |> 
  summarise(new_cases = sum(new_confirmed_cases),
            new_death = sum(new_deaths))
