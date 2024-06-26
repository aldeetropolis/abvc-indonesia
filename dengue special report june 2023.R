library(tidyverse)
library(lubridate)
library(ggprism)
library(readxl)
library(jsonlite)
library(httr)
library(zoo)
library(writexl)

yearweek <- read_xlsx("week.xlsx")
yearweek$year <- factor(yearweek$year)

# Malaysia
dataMlyCase <- read_excel("data-adva/malaysia-adva.xlsx") |> 
  select(2:4) |> 
  mutate(totalCases = round(rollmean(ifelse(is.na(`Weekly Dengue cases`), 0, `Weekly Dengue cases`), k = 16, fill = `Weekly Dengue cases`), 0)) |> 
  filter(Year > 2019)
#dataMlyDeath <- read_excel("data-adva/malaysia-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly Deaths`))
dataMlyCase$week <- as.numeric(gsub("Week ", "", dataMlyCase$`Week #`))
dataMlyCase$totalCases <- ifelse(is.na(dataMlyCase$totalCases), dataMlyCase$`Weekly Dengue cases`, dataMlyCase$totalCases)
dataMlyCase$date <- parse_date_time(paste(dataMlyCase$Year, dataMlyCase$week, 1, sep = "/"), 'Y/W/u')
dataMlyCase <- filter(dataMlyCase, !is.na(dataMlyCase$totalCases)) |> 
  select(date, week, totalCases)
#dataMlyDeath$week <- as.numeric(gsub("Week ", "", dataMlyDeath$`Week #`))
#dataMlyDeath$`Weekly Deaths` <- as.numeric(dataMlyDeath$`Weekly Deaths`)

jpeg("dengue malaysia 2020-2023.jpeg", units="px", width=4000, height=2250, res=300)
ggplot(data = dataMlyCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, color = "red") +
  # geom_point(aes(x = date, y = totalCases)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# ggplot(data = dataMlyDeath) +
#   geom_line(aes(x = week, y = `Weekly Deaths`, colour = Year), linewidth = 0.8) +
#   geom_point(aes(x = week, y = `Weekly Deaths`, colour = Year)) +
#   xlab("Epidemiological Week") +
#   ylab("Total Deaths") +
#   scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
#   theme_prism()

write_xlsx(dataMlyCase, "malaysia-dengue.xlsx")

# Thailand
dataThaiCase <- read_excel("data-adva/thailand-adva.xlsx") |> 
  select(2:4) |> 
  mutate(totalCases = round(rollmean(ifelse(is.na(`Weekly cases`), 0, `Weekly cases`), k = 12, fill = `Weekly cases`), 0)) |> 
  filter(Year > 2019)
#dataThaiDeath <- read_excel("data-adva/thailand-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly deaths`))
dataThaiCase$week <- as.numeric(gsub("Week ", "", dataThaiCase$`Week #`))
dataThaiCase$totalCases <- ifelse(is.na(dataThaiCase$totalCases), dataThaiCase$`Weekly cases`, dataThaiCase$totalCases)
dataThaiCase$date <- parse_date_time(paste(dataThaiCase$Year, dataThaiCase$week, 1, sep = "/"), 'Y/W/u')
dataThaiCase <- filter(dataThaiCase, !is.na(totalCases)) |> 
  select(date, week, totalCases)
# dataThaiDeath$week <- as.numeric(gsub("Week ", "", dataThaiDeath$`Week #`))
# dataThaiDeath$`Weekly deaths` <- as.numeric(dataThaiDeath$`Weekly deaths`)

jpeg("dengue thailand 2021-2023.jpeg", units="px", width=4000, height=2250, res=300)
ggplot(data = dataThaiCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, colour = "red") +
  # geom_point(aes(x = week, y = totalCases, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataThaiCase, "thailand-dengue.xlsx")

# Vietnam
dataVietCase <- read_excel("data-adva/vietnam-adva.xlsx") |> 
  select(2:4) |>
  mutate(totalCases = round(rollmean(ifelse(is.na(`Weekly Dengue cases`), 0, `Weekly Dengue cases`), k = 12, fill = `Weekly Dengue cases`), 0)) |> 
  filter(Year > 2019)
#dataVietDeath <- read_excel("data-adva/vietnam-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly Deaths`))
dataVietCase$week <- as.numeric(gsub("Week ", "", dataVietCase$`Week #`))
dataVietCase$date <- parse_date_time(paste(dataVietCase$Year, dataVietCase$week, 1, sep = "/"), 'Y/W/u')
dataVietCase <- select(dataVietCase, 
                       date, week, totalCases)
# dataVietDeath$week <- as.numeric(gsub("Week ", "", dataVietDeath$`Week #`))
# dataVietDeath$`Weekly Deaths` <- as.numeric(dataVietDeath$`Weekly Deaths`)

jpeg("dengue vietnam 2020-2023.jpeg", units = "px", width = 4000, height = 2250, res = 300)
ggplot(data = dataVietCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, colour = "red") +
  # geom_point(aes(x = date, y = totalCases, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataVietCase, "vietnam-dengue.xlsx")

# Cambodia
dataCbdCase <- read_excel("data-adva/cambodia-adva.xlsx") |> select(2:4) |> 
  mutate(totalCases = round(rollmean(ifelse(is.na(`Weekly Dengue cases`), 0, `Weekly Dengue cases`), k = 12, fill = `Weekly Dengue cases`), 0)) |> 
  filter(Year > 2019)
#dataCbdDeath <- read_excel("data-adva/cambodia-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly Deaths`))
dataCbdCase$week <- as.numeric(gsub("Week ", "", dataCbdCase$`Week #`))
dataCbdCase$date <- parse_date_time(paste(dataCbdCase$Year, dataCbdCase$week, 1, sep = "/"), 'Y/W/u')
dataCbdCase <- select(dataCbdCase,
                      date, week, totalCases)
# dataCbdDeath$week <- as.numeric(gsub("Week ", "", dataCbdDeath$`Week #`))
# dataCbdDeath$`Weekly Deaths` <- as.numeric(dataCbdDeath$`Weekly Deaths`)

jpeg("dengue cambodia 2020-2023.jpeg", units = "px", width = 4000, height = 2250, res = 300)
ggplot(data = dataCbdCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, color = "red") +
  # geom_point(aes(x = date, y = totalCases)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataCbdCase, "cambodia-dengue.xlsx")

# Laos
dataLaoCase <- read_excel("data-adva/laos-adva.xlsx")
dataLaoCase$`Weekly Dengue cases` <- as.numeric(dataLaoCase$`Weekly Dengue cases`)
dataLaoCase <- dataLaoCase |> 
  select(2:4) |> 
  mutate(totalCases = round(rollmean(ifelse(is.na(`Weekly Dengue cases`), 0, `Weekly Dengue cases`), k = 12, fill = `Weekly Dengue cases`), 0)) |> 
  filter(Year > 2019)
dataLaoCase$week <- as.numeric(gsub("Week ", "", dataLaoCase$`Week #`))
dataLaoCase$date <- parse_date_time(paste(dataLaoCase$Year, dataLaoCase$week, 1, sep = "/"), 'Y/W/u')
dataLaoCase <- select(dataLaoCase,
                      date, week, totalCases)
# dataLaoCase <- filter(dataLaoCase, totalCases > 0)

jpeg("dengue laos 2020-2023.jpeg", units = "px", width = 4000, height = 2250, res = 300)
ggplot(data = dataLaoCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, colour = "red") +
  # geom_point(aes(x = week, y = totalCases, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataLaoCase, "lao PDR-dengue.xlsx")

# Philippines
dataPhilCase <- read_excel("data-adva/philippines-adva.xlsx") |> 
  select(2:3, 6) |> 
dataPhilCase$week <- as.numeric(gsub("Week ", "", dataPhilCase$`Week #`))
dataPhilCase$weeklyCases <- as.numeric(dataPhilCase$weeklyCases)

url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1694008&startDate=2020-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataPhilCase <- data.frame(t(sapply(parse$data,c)))
dataPhilCase$reportedDate <- ymd(substr(dataPhilCase$reportedDate, 1, 10))
dataPhilCase <- dataPhilCase |> 
  mutate(year = factor(year(reportedDate)),
         week = epiweek(reportedDate)) |> 
  filter(totalReportedCases > 0)
dataPhilCase$totalReportedCases <- as.numeric(dataPhilCase$totalReportedCases)
dataPhilCase <- dataPhilCase |> group_by(year, week) |> summarise(totalCases = sum(totalReportedCases)) |> ungroup()
dataPhilCase <- left_join(yearweek, dataPhilCase, by = c("year", "week"))
dataPhilCase$date <- parse_date_time(paste(dataPhilCase$year, dataPhilCase$week, 1, sep = "/"), 'Y/W/u')
dataPhilCase$totalCases[is.na(dataPhilCase$totalCases)] <- 0
dataPhilCase <- mutate(dataPhilCase, totalCases = round(rollmean(dataPhilCase$totalCases, k = 12, fill = NA), 0)) |> 
  select(date, week, t)

jpeg("dengue philippines 2020-2023.jpeg", units = "px", width = 4000, height = 2250, res = 300)
ggplot(data = dataPhilCase) +
  geom_line(aes(date, totalCases), linewidth = 0.8, colour = "red") +
  # geom_point(aes(epi, ma, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataPhilCase, "philippine-dengue.xlsx")

# Singapore
dataSingCase <- read_excel("data-adva/singapore-adva.xlsx") |> 
  select(2:4) |> 
  mutate(totalCases = round(
    rollmean(
      ifelse(is.na(`Weekly Dengue cases`), 0, `Weekly Dengue cases`), 
      k = 12, fill = `Weekly Dengue cases`), 0)) |> 
  filter(Year > 2019)
dataSingCase$week <- as.numeric(gsub("Week ", "", dataSingCase$`Week #`))
dataSingCase$totalCases <- ifelse(is.na(dataSingCase$totalCases), 
                                  dataSingCase$`Weekly Dengue cases`, 
                                  dataSingCase$totalCases)
dataSingCase$date <- parse_date_time(paste(dataSingCase$Year, dataSingCase$week, 1, sep = "/"), 'Y/W/u')
dataSingCase <- select(dataSingCase,
                       date, week, totalCases)
# dataSingCase <- filter(dataSingCase, totalCases > 0)

jpeg("dengue singapore 2020-2023.jpeg", units = "px", width = 4000, height = 2250, res = 300)
ggplot(data = dataSingCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, colour = "red") +
  # geom_point(aes(x = week, y = totalCases, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataSingCase, "singapore-dengue.xlsx")

# Indonesia
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1643084&startDate=2020-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataIdnCase <- data.frame(t(sapply(parse$data,c)))
dataIdnCase$reportedDate <- ymd(substr(dataIdnCase$reportedDate, 1, 10))
dataIdnCase <- dataIdnCase |> 
  mutate(year = factor(year(reportedDate)),
         week = epiweek(reportedDate))
dataIdnCase$totalReportedCases <- as.numeric(dataIdnCase$totalReportedCases)
dataIdnCase <- dataIdnCase |> 
  group_by(year, week) |> 
  summarise(totalCases = sum(totalReportedCases))
dataIdnCase <- left_join(yearweek, dataIdnCase, by = c("year", "week"))
dataIdnCase$date <- parse_date_time(paste(dataIdnCase$year, dataIdnCase$week, 1, sep = "/"), 'Y/W/u')
dataIdnCase$totalCases[is.na(dataIdnCase$totalCases)] <- 0
dataIdnCase <- mutate(dataIdnCase, 
                      totalCases = round(rollmean(dataIdnCase$totalCases, k = 12, fill = NA), 0)) |> 
  select(date, week, totalCases)

jpeg("dengue indonesia 2020-2023.jpeg", units="px", width=4000, height=2250, res=300)
ggplot(data = dataIdnCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 1, color = "red") +
  # geom_point(aes(x = epi, y = totalCases, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataIdnCase, "indonesia-dengue.xlsx")

# Myanmar
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1327865&startDate=2020-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataMyrCase <- data.frame(t(sapply(parse$data,c)))
dataMyrCase$reportedDate <- ymd(substr(dataMyrCase$reportedDate, 1, 10))
dataMyrCase <- dataMyrCase |> 
  mutate(year = factor(year(reportedDate)),
         week = epiweek(reportedDate))
dataMyrCase$totalReportedCases <- as.numeric(dataMyrCase$totalReportedCases)
dataMyrCase <- dataMyrCase |> group_by(year, week) |> summarise(totalCases = sum(totalReportedCases))
dataMyrCase <- left_join(yearweek, dataMyrCase, by = c("year", "week"))
dataMyrCase$date <- parse_date_time(paste(dataMyrCase$year, dataMyrCase$week, 1, sep = "/"), 'Y/W/u')
dataMyrCase$totalCases[is.na(dataMyrCase$totalCases)] <- 0
dataMyrCase <- mutate(dataMyrCase, 
                      totalCases = round(rollmean(dataMyrCase$totalCases, k = 12, fill = NA), 0)) |> 
  select(date, week, totalCases)

jpeg("dengue myanmar 2020-2023.jpeg", units="px", width=4000, height=2250, res=300)
ggplot(data = dataMyrCase) +
  geom_line(aes(x = date, y = totalCases), linewidth = 0.8, colour = "red") +
  # geom_point(aes(x = epi, y = totalCases, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

write_xlsx(dataIdnCase, "myanmar-dengue.xlsx")

# Total ASEAN
dataCbdCase <- rename(dataCbdCase, "cbd" = "totalCases") |> select(date, cbd)
dataIdnCase <- rename(dataIdnCase, "idn" = "totalCases") |> select(date, idn)
dataLaoCase <- rename(dataLaoCase, "lao" = "totalCases") |> select(date, lao)
dataMlyCase <- rename(dataMlyCase, "mly" = "totalCases") |> select(date, mly)
dataPhilCase <- rename(dataPhilCase, "phil" = "totalCases") |> select(date, phil)
dataSingCase <- rename(dataSingCase, "sing" = "totalCases") |> select(date, sing)
dataThaiCase <- rename(dataThaiCase, "thai" = "totalCases") |> select(date, thai)
dataVietCase <- rename(dataVietCase, "viet" = "totalCases") |> select(date, viet)
dataMyrCase <- rename(dataMyrCase, "myr" = "totalCases") |> select(date, myr)

dataAsean <- full_join(dataCbdCase, dataIdnCase, by = "date") |> 
  full_join(dataLaoCase, by = "date") |> 
  full_join(dataMlyCase, by = "date") |> 
  full_join(dataMyrCase, by = "date") |> 
  full_join(dataPhilCase, by = "date") |> 
  full_join(dataSingCase, by = "date") |> 
  full_join(dataThaiCase, by = "date") |> 
  full_join(dataVietCase, by = "date")

dataAsean$total <- rowSums(dataAsean[2:10], na.rm = TRUE)
dataAsean <- filter(dataAsean, total > 0)
# dataAsean$ma <- round(rollmean(dataAsean$total, k = 4, fill = NA), 0)
# dataAsean$ma <- ifelse(is.na(dataAsean$ma), dataAsean$total, dataAsean$ma)

jpeg("dengue asean 2020-2023.jpeg", units="px", width=4000, height=2250, res=300)
ggplot(data = dataAsean) +
  geom_line(aes(x = date, y = total), linewidth = 0.8, colour = "red") +
  # geom_point(aes(x = week, y = total, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  # scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# write_xlsx(dataAsean, "ASEAN-dengue.xlsx")

# 
