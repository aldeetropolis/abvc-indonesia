library(httr)
library(jsonlite)
library(tidyverse)
library(lubridate)
library(ggprism)

# Aggregated past 5 months
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201966436&startDate=2023-01&endDate=2023-06&isAggregated=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "4b96d6008bfe499cbdf360de9890a080", "Cache-Control" = "no-cache"))
parse <- content(res)
data_aggr <- data.frame(t(sapply(parse$data,c)))
data_aggr <- data_aggr[c("countryName", "totalReportedCases", "totalDeaths")]
data_aggr$totalReportedCases <- as.numeric(data_aggr$totalReportedCases)
data_aggr$totalDeaths <- as.numeric(data_aggr$totalDeaths)
data_aggr$cfr <- data_aggr$totalDeaths/data_aggr$totalReportedCases

# Aggregated past week
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1820814,%201831722,%201643084,%201655842,%201733045,%201327865,%201694008,%201880251,%201605651,%201562822,%201966436&startDate=2023-06-01&endDate=2023-06-08&isAggregated=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "4b96d6008bfe499cbdf360de9890a080", "Cache-Control" = "no-cache"))
parse <- content(res)
data_wk <- data.frame(t(sapply(parse$data,c)))
data_wk <- data_wk[c("countryName", "latitude", "longitude", "totalReportedCases", "totalDeaths")]

# Daily Cases past 3 tahun
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1643084&startDate=2020-01-01&endDate=2023-06&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "4b96d6008bfe499cbdf360de9890a080", "Cache-Control" = "no-cache"))
parse <- content(res)
data_daily <- data.frame(t(sapply(parse$data,c)))
data_daily$reportedDate <- ymd(substr(data_daily$reportedDate, 1, 10))
data_daily <- unnest(data_daily, cols = c(locationName, countryName))
data_daily <- data_daily[c("reportedDate", "locationName", "latitude", "longitude", "totalReportedCases", "totalDeaths")]
data_daily$totalReportedCases <- as.numeric(data_daily$totalReportedCases)
data_daily <- data_daily |> mutate(totalDeaths = replace(totalDeaths, totalDeaths == "NULL", NA),
                                   year = factor(year(reportedDate)),
                                   epi = epiweek(reportedDate))
data_daily$totalDeaths <- as.numeric(data_daily$totalDeaths)
data_daily$cfr <- (data_daily$totalDeaths / data_daily$totalReportedCases)*100
df <- data_daily |> group_by(locationName, epi, year) |> summarize(total_case = abs(sum(totalReportedCases)),
                                                                   total_deaths = abs(sum(totalDeaths)))

# Malaysia
jpeg("dengue malaysia 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df|> filter(locationName == "Malaysia")) +
  geom_line(aes(x = epi, y = total_case, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_case, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths malaysia 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Malaysia")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Indonesia
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1643084&startDate=2019-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataIdnCase <- data.frame(t(sapply(parse$data,c)))
dataIdnCase$reportedDate <- ymd(substr(dataIdnCase$reportedDate, 1, 10))
dataIdnCase <- dataIdnCase |> 
  mutate(year = factor(year(reportedDate)),
         epi = epiweek(reportedDate))
dataIdnCase$totalReportedCases <- as.numeric(dataIdnCase$totalReportedCases)
dataIdnCase <- dataIdnCase |> group_by(year, epi) |> summarise(totalCases = sum(totalReportedCases)) |> filter(totalCases > 0)

jpeg("dengue indonesia 2020-2023.jpeg", units="px", width=4000, height=2250, res=300)
ggplot(data = dataIdnCase) +
  geom_line(aes(x = epi, y = totalCases, colour = year), linewidth = 1) +
  geom_point(aes(x = epi, y = totalCases, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths indonesia 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Indonesia")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Laos
jpeg("dengue laos 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Laos")) +
  geom_line(aes(x = epi, y = total_case, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_case, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths laos 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Laos")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Myanmar
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1327865&startDate=2019-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataMyrCase <- data.frame(t(sapply(parse$data,c)))
dataMyrCase$reportedDate <- ymd(substr(dataMyrCase$reportedDate, 1, 10))
dataMyrCase <- dataMyrCase |> 
  mutate(year = factor(year(reportedDate)),
         epi = epiweek(reportedDate)) |> 
  filter(totalReportedCases > 0)
dataMyrCase$totalReportedCases <- abs(as.numeric(dataMyrCase$totalReportedCases))

jpeg("dengue myanmar 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = dataMyrCase) +
  geom_line(aes(x = epi, y = totalReportedCases, colour = year), linewidth = 0.8) +
  geom_point(aes(x = epi, y = totalReportedCases, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths myanmar 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Myanmar")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Singapore
jpeg("dengue singapore 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Singapore")) +
  geom_line(aes(x = epi, y = total_case, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_case, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths singapore 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Singapore")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Thailand
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1694008&startDate=2019-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataPhilCase <- data.frame(t(sapply(parse$data,c)))
dataPhilCase$reportedDate <- ymd(substr(dataPhilCase$reportedDate, 1, 10))
dataPhilCase <- dataPhilCase |> 
  mutate(year = factor(year(reportedDate)),
         epi = epiweek(reportedDate)) |> 
  filter(totalReportedCases > 0)
dataPhilCase$totalReportedCases <- abs(as.numeric(dataPhilCase$totalReportedCases))

jpeg("dengue thailand 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Thailand")) +
  geom_line(aes(x = epi, y = total_case, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = , colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths thailand 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Thailand")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Philippines
url <- "https://developer.bluedot.global/casecounts/diseases/55?locationIds=1694008&startDate=2019-01-01&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(url, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
dataPhilCase <- data.frame(t(sapply(parse$data,c)))
dataPhilCase$reportedDate <- ymd(substr(dataPhilCase$reportedDate, 1, 10))
dataPhilCase <- dataPhilCase |> 
  mutate(year = factor(year(reportedDate)),
         epi = epiweek(reportedDate)) |> 
  filter(totalReportedCases > 0)
dataPhilCase$totalReportedCases <- abs(as.numeric(dataPhilCase$totalReportedCases))

jpeg("dengue philippines 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = dataPhilCase) +
  geom_path(aes(x = epi, y = totalReportedCases, colour = year), linewidth = 0.8) +
  geom_point(aes(x = epi, y = totalReportedCases, colour = year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths philippines 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Philippines")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Vietnam
jpeg("dengue vietnam 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Vietnam")) +
  geom_line(aes(x = epi, y = total_case, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_case, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

jpeg("dengue deaths vietnam 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = df |> filter(locationName == "Vietnam")) +
  geom_line(aes(x = epi, y = total_deaths, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = total_deaths, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Cambodia!
jpeg("dengue cambodia 2020-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = data_daily |> filter(locationName == "Cambodia") |> group_by(year, epi) |> summarize(summary_variable = sum(totalReportedCases))) +
  geom_line(aes(x = epi, y = summary_variable, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = summary_variable, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Timor Leste!
ggplot(data = data_daily |> filter(locationName == "Timor Leste") |> group_by(year, epi) |> summarize(summary_variable = sum(totalReportedCases))) +
  geom_line(aes(x = epi, y = summary_variable, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = summary_variable, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()

# Brunei!
ggplot(data = data_daily |> filter(locationName == "Brunei") |> group_by(year, epi) |> summarize(summary_variable = sum(totalReportedCases))) +
  geom_line(aes(x = epi, y = summary_variable, colour = factor(year)), linewidth = 0.8) +
  geom_point(aes(x = epi, y = summary_variable, colour = factor(year), shape = factor(year))) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
