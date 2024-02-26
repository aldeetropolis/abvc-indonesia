library(tidyverse)
library(readxl)
library(lubridate)
library(flextable)
library(zoo)
library(jsonlite)
library(httr)
library(highcharter)
library(wesanderson)

infUrl <- "https://developer.bluedot.global/casecounts/indicator-based/diseases/influenza/?locationIds=1880251,%201605651,%201694008,%201820814,%201733045,%201643084,%201831722,%201327865,%201655842,1562822&startDate=2023-01-01&api-version=v1"
res <- GET(infUrl, add_headers("Ocp-Apim-Subscription-Key" = "3f8e179c7c584514aa97faff3187df7d", "Cache-Control" = "no-cache")) |> content()
infData <- enframe(pluck(res, "data")) |> unnest_wider(value)

df_type_asean <- infData |> 
  mutate(date = as.Date(reportedDate)) |> 
  group_by(date) |> 
  summarise(inf_a = sum(totalPositiveSamplesA, na.rm = TRUE),
            inf_b = sum(totalPositiveSamplesB, na.rm = TRUE),
            inf_tot = sum(totalPositiveSamples, na.rm = TRUE)) |> 
  pivot_longer(cols = c(inf_a, inf_b), names_to = "type", values_to = "n")

df_type_country <- infData |> 
  mutate(date = as.Date(reportedDate)) |> 
  group_by(date, countryName,) |> 
  summarise(inf_a = sum(totalPositiveSamplesA),
            inf_b = sum(totalPositiveSamplesB)) |> 
  pivot_longer(cols = c(inf_a, inf_b, inf_tot), names_to = "type", values_to = "n")

df <- data |> 
  filter(country_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"),
         iso_sdate >= "2023-01-01") |> 
  rename(country = "country/area/territory") |> 
  mutate(date = as.Date(iso_sdate),
         pos_rate = (as.numeric(inf_all)/as.numeric(spec_processed_nb)*100))
ratio <- max(df$inf_all) / max(df$pos_rate)
df <- transform(df, pos_rate_scaled = pos_rate * ratio)

plot <- ggplot() +
  geom_area(data = owid_weekly_data, aes(x = week, y = cases, fill = location)) + 
  geom_line(data = owid_weekly_deaths, aes(week, deaths*200, colour = "Number of Death"), linetype = "solid", linewidth = 1.2) +
  scale_y_continuous(sec.axis = sec_axis(~ . / 200, name = "No. of Death"), name = "Weekly Cases") +
  scale_x_date(breaks = "1 month", labels = date_format("%b-%Y"),
               limits = as.Date(c('2022-12-25','2023-12-31')), name = element_blank()) +
  scale_colour_manual("", breaks = c("Number of Death"), values = "black") +
  theme(legend.title = element_blank()) +
  theme_hc()

ggplot(data = df_type_asean) + 
  geom_col(aes(date, as.numeric(n), fill = type),
           position = position_dodge()) +
  geom_line(aes(x = date, y = inf_tot, colour = "Total Cases")) +
  scale_color_manual(values = "black")

ggplot() +
  geom_smooth(data = filter(df, country == "Indonesia"), aes(x = date, y = pos_rate))

ggplot(data = df, aes(x = date, y = pos_rate, fill = country)) +
  geom_area()

# ILI data from FluID
data <- read_csv("~/Downloads/VIW_FID.csv") |> filter(COUNTRY_CODE == "IDN")
