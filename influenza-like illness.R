library(tidyverse)
library(lubridate)
library(zoo)
library(jsonlite)
library(httr)
library(highcharter)
library(curl)

# COVID-19 data from OWID
owid_link <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"
curl_download(owid_link, "files/owid-covid-data.csv")
covid_data <- read_csv("files/owid-covid-data.csv") |> 
  filter(iso_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"),
         date >= "2021-01-01") |> 
  mutate(location = replace(location, location == "Laos", "Lao PDR"),
         location = replace(location, location == "Brunei", "Brunei DS"),
         week = floor_date(date, "week"))

covid_asean <- covid_data |> group_by(week) |> summarise(n = sum(new_cases, na.rm = TRUE))

# Confirmed Influenza data from FluNet
fluUrl <- "https://developer.bluedot.global/casecounts/indicator-based/diseases/influenza/?locationIds=1880251,%201605651,%201694008,%201820814,%201733045,%201643084,%201831722,%201327865,%201655842,1562822&startDate=2018-01-01&api-version=v1"
res <- GET(fluUrl, add_headers("Ocp-Apim-Subscription-Key" = "3f8e179c7c584514aa97faff3187df7d", "Cache-Control" = "no-cache")) |> content()
fluData <- enframe(pluck(res, "data")) |> unnest_wider(value) |> mutate(date = as.Date(reportedDate))

fluAsean <- fluData |> 
  filter(date >= "2021-01-01") |> 
  mutate(date = as.Date(reportedDate)) |> 
  group_by(date) |> 
  summarise(inf_a = sum(totalPositiveSamplesA, na.rm = TRUE),
            inf_b = sum(totalPositiveSamplesB, na.rm = TRUE),
            inf_tot = sum(totalPositiveSamples, na.rm = TRUE)) |> 
  pivot_longer(cols = c(inf_a, inf_b), names_to = "type", values_to = "n")

fluCountry <- fluData |> 
  mutate(date = as.Date(reportedDate)) |> 
  group_by(date, countryName,) |> 
  summarise(inf_a = sum(totalPositiveSamplesA, na.rm = TRUE),
            inf_b = sum(totalPositiveSamplesB), na.rm = TRUE,
            inf_tot = sum(totalPositiveSamples, na.rm = TRUE)) |> 
  pivot_longer(cols = c(inf_a, inf_b), names_to = "type", values_to = "n")

# df <- data |> 
#   filter(country_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"),
#          iso_date >= "2023-01-01") |> 
#   rename(country = "country/area/territory") |> 
#   mutate(date = as.Date(iso_sdate),
#          pos_rate = (as.numeric(inf_all)/as.numeric(spec_processed_nb)*100))
# ratio <- max(df$inf_all) / max(df$pos_rate)
# df <- transform(df, pos_rate_scaled = pos_rate * ratio)
# 
# ggplot(data = fluAsean) + 
#   geom_col(aes(date, as.numeric(n), fill = type),
#            position = position_dodge()) +
#   geom_line(aes(x = date, y = inf_tot, colour = "Total Cases")) +
#   scale_color_manual(values = "black")
# 
# ggplot() +
#   geom_smooth(data = filter(df, country == "Indonesia"), aes(x = date, y = pos_rate))
# 
# ggplot(data = df, aes(x = date, y = pos_rate, fill = country)) +
#   geom_area()

# Highchart for COVID & Influenza data
highchart(type = "stock") |> 
  hc_add_series(data = covid_asean, yAxis = 0, type = 'line',
                hcaes(x = week, y = n)) |> 
  hc_add_yAxis(title = list(text = "COVID-19"), relative = 1) |> 
  hc_add_series(data = fluAsean, yAxis = 1, type = 'line',
                hcaes(x = date, y = inf_tot)) |> 
  hc_add_yAxis(title = list(text = "Influenza"), relative = 1)

# |> 
#   hc_xAxis(dateTimeLabelFormats = list(month = "%b '%y"), type = "datetime")

# ILI data from FluID
fluID_link <- "https://xmart-api-public.who.int/FLUMART/VIW_FID?$format=csv"
curl_download(fluID_link, "files/FluID.csv")
iliData <- read_csv("files/FluID.csv") |> rename_with(tolower)
iliIdn <- iliData |> filter(country_code == "IDN", agegroup_code == "All", mmwr_year >= 2021) |> 
  group_by(mmwr_weekstartdate) |> summarise(n_ili = sum(outpatients, na.rm = TRUE), n_sari = sum(inpatients, na.rm = TRUE))
iliIdn_ts <- as.xts(iliIdn)
ggplot(data = iliIdn, aes(x = mmwr_week, y = n_ili)) +
  geom_line(aes(color = factor(mmwr_year)))

## ASEAN data
iliAsean <- iliData |> filter(country_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"), 
                              agegroup_code == "All", mmwr_year >= 2021, case_info %in% c("ILI", "SARI")) |> 
  group_by(mmwr_weekstartdate) |> 
  summarise(n_ili = sum(outpatients, na.rm = TRUE), n_sari = sum(inpatients, na.rm = TRUE))

iliCountry <- iliData |> filter(country_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"), 
                              agegroup_code == "All", mmwr_year >= 2021, case_info %in% c("ILI", "SARI")) |> 
  group_by(mmwr_weekstartdate, country_area_territory) |> 
  summarise(n_ili = sum(outpatients, na.rm = TRUE), n_sari = sum(inpatients, na.rm = TRUE))

## Highcharter for ILI
highchart(type = "stock") |> 
  hc_add_series(data = iliAsean, yAxis = 0, type = "line", showInLegend = TRUE,
                hcaes(x = mmwr_weekstartdate, y = n_ili)) |> 
  hc_add_yAxis(title = list(text = "ILI"), relative = 1) |> 
  hc_add_series(data = iliAsean, yAxis = 1, hcaes(x = mmwr_weekstartdate, y = n_sari), type = "line") |> 
  hc_add_yAxis(title = list(text = "SARI"), relative = 1)

# Highcharter for COVID + Influenza + ILI + SARI
highchart(type = "stock") |> 
  hc_add_series(data = covid_asean, yAxis = 0, type = 'line',
                hcaes(x = week, y = n)) |> 
  hc_add_yAxis(title = list(text = "COVID-19"), relative = 1) |> 
  hc_add_series(data = fluAsean, yAxis = 1, type = 'line',
                hcaes(x = date, y = inf_tot)) |> 
  hc_add_yAxis(title = list(text = "Influenza"), relative = 1) |> 
  hc_add_series(data = iliAsean, yAxis = 2, type = "line", showInLegend = TRUE,
                hcaes(x = mmwr_weekstartdate, y = n_ili)) |> 
  hc_add_yAxis(title = list(text = "ILI"), relative = 1) |> 
  hc_add_series(data = iliAsean, yAxis = 3, hcaes(x = mmwr_weekstartdate, y = n_sari), type = "line") |> 
  hc_add_yAxis(title = list(text = "SARI"), relative = 1)
