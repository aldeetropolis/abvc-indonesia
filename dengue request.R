library(tidyverse)
library(lubridate)
library(writexl)

data <- read_csv("~/Downloads/min-max-case-counts_2024-05-20T0330473344448+0000.csv")
data_sel <- data |> select(reportedDate, diseaseName, countryName, maxTotalReportedCases, maxTotalDeaths) |> 
  mutate(date = as.Date(reportedDate, '%m/%d/%Y')) |> mutate(year = year(date)) |> group_by(countryName, year) |> 
  summarise(confirmed_case = sum(maxTotalReportedCases),
            deaths = sum(maxTotalDeaths)) |> 
  arrange(countryName, year) |> 
  pivot_wider(year)

write_xlsx(data_sel, "files/Dengue ASEAN last 5 yr.xlsx")
