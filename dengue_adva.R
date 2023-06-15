library(tidyverse)
library(lubridate)
library(ggprism)
library(readxl)

# Malaysia
dataMlyCase <- read_excel("data-adva/malaysia-adva.xlsx") |> select(2:4) |> filter(!is.na(`Weekly Dengue cases`))
dataMlyDeath <- read_excel("data-adva/malaysia-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly Deaths`))
dataMlyCase$week <- as.numeric(gsub("Week ", "", dataMlyCase$`Week #`))
dataMlyCase$`Weekly Dengue cases` <- as.numeric(dataMlyCase$`Weekly Dengue cases`)
dataMlyDeath$week <- as.numeric(gsub("Week ", "", dataMlyDeath$`Week #`))
dataMlyDeath$`Weekly Deaths` <- as.numeric(dataMlyDeath$`Weekly Deaths`)

jpeg("dengue malaysia 2019-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = dataMlyCase) +
  geom_line(aes(x = week, y = `Weekly Dengue cases`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly Dengue cases`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

ggplot(data = dataMlyDeath) +
  geom_line(aes(x = week, y = `Weekly Deaths`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly Deaths`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Total Deaths") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()

# Thailand
dataThaiCase <- read_excel("data-adva/thailand-adva.xlsx") |> select(2:4) |> filter(!is.na(`Weekly cases`))
dataThaiDeath <- read_excel("data-adva/thailand-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly deaths`))
dataThaiCase$week <- as.numeric(gsub("Week ", "", dataThaiCase$`Week #`))
dataThaiCase$`Weekly cases` <- as.numeric(dataThaiCase$`Weekly cases`)
dataThaiDeath$week <- as.numeric(gsub("Week ", "", dataThaiDeath$`Week #`))
dataThaiDeath$`Weekly deaths` <- as.numeric(dataThaiDeath$`Weekly deaths`)

jpeg("dengue thailand 2021-2023.jpeg", units="in", width=10, height=5, res=300)
ggplot(data = dataThaiCase) +
  geom_line(aes(x = week, y = `Weekly cases`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly cases`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Vietnam
dataVietCase <- read_excel("data-adva/vietnam-adva.xlsx") |> select(2:4) |> filter(!is.na(`Weekly Dengue cases`))
dataVietDeath <- read_excel("data-adva/vietnam-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly Deaths`))
dataVietCase$week <- as.numeric(gsub("Week ", "", dataVietCase$`Week #`))
dataVietCase$`Weekly Dengue cases` <- as.numeric(dataVietCase$`Weekly Dengue cases`)
dataVietDeath$week <- as.numeric(gsub("Week ", "", dataVietDeath$`Week #`))
dataVietDeath$`Weekly Deaths` <- as.numeric(dataVietDeath$`Weekly Deaths`)

jpeg("dengue vietnam 2019-2023.jpeg", units = "in", width = 10, height = 5, res = 300)
ggplot(data = dataVietCase) +
  geom_line(aes(x = week, y = `Weekly Dengue cases`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly Dengue cases`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Cambodia
dataCbdCase <- read_excel("data-adva/cambodia-adva.xlsx") |> select(2:4) |> filter(!is.na(`Weekly Dengue cases`))
dataCbdDeath <- read_excel("data-adva/cambodia-adva.xlsx") |> select(2:3, 5) |> filter(!is.na(`Weekly Deaths`))
dataCbdCase$week <- as.numeric(gsub("Week ", "", dataCbdCase$`Week #`))
dataCbdCase$`Weekly Dengue cases` <- as.numeric(dataCbdCase$`Weekly Dengue cases`)
dataCbdDeath$week <- as.numeric(gsub("Week ", "", dataCbdDeath$`Week #`))
dataCbdDeath$`Weekly Deaths` <- as.numeric(dataCbdDeath$`Weekly Deaths`)

jpeg("dengue cambodia 2019-2023.jpeg", units = "in", width = 10, height = 5, res = 300)
ggplot(data = dataCbdCase) +
  geom_line(aes(x = week, y = `Weekly Dengue cases`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly Dengue cases`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Laos
dataLaoCase <- read_excel("data-adva/laos-adva.xlsx") |> select(2:4) |> filter(!is.na(`Weekly Dengue cases`))
dataLaoCase$week <- as.numeric(gsub("Week ", "", dataLaoCase$`Week #`))
dataLaoCase$`Weekly Dengue cases` <- as.numeric(dataLaoCase$`Weekly Dengue cases`)
dataLaoCase <- filter(dataLaoCase, !is.na(`Weekly Dengue cases`))

jpeg("dengue laos 2019-2023.jpeg", units = "in", width = 10, height = 5, res = 300)
ggplot(data = dataLaoCase) +
  geom_line(aes(x = week, y = `Weekly Dengue cases`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly Dengue cases`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Philippines
dataPhilCase <- read_excel("data-adva/philippines-adva.xlsx") |> 
  select(2:3, 6) |> 
  filter(!is.na(`Total Dengue Cases To Date`)) |> 
  group_by(Year) |> 
  mutate(weeklyCases = c(NA, diff(`Total Dengue Cases To Date`))) |> 
  mutate(weeklyCases = ifelse(is.na(weeklyCases), `Total Dengue Cases To Date`, weeklyCases)) |> 
  ungroup()
dataPhilCase$week <- as.numeric(gsub("Week ", "", dataPhilCase$`Week #`))
dataPhilCase$weeklyCases <- as.numeric(dataPhilCase$weeklyCases)

jpeg("dengue philippines 2019-2023.jpeg", units = "in", width = 10, height = 5, res = 300)
ggplot(data = dataPhilCase) +
  geom_line(aes(week, weeklyCases, colour = Year), linewidth = 0.8) +
  geom_point(aes(week, weeklyCases, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()

# Singapore
dataSingCase <- read_excel("data-adva/singapore-adva.xlsx") |> select(2:4) |> filter(!is.na(`Weekly Dengue cases`))
dataSingCase$week <- as.numeric(gsub("Week ", "", dataSingCase$`Week #`))
dataSingCase$`Weekly Dengue cases` <- as.numeric(dataSingCase$`Weekly Dengue cases`)

jpeg("dengue singapore 2019-2023.jpeg", units = "in", width = 10, height = 5, res = 300)
ggplot(data = dataSingCase) +
  geom_line(aes(x = week, y = `Weekly Dengue cases`, colour = Year), linewidth = 0.8) +
  geom_point(aes(x = week, y = `Weekly Dengue cases`, colour = Year)) +
  xlab("Epidemiological Week") +
  ylab("Number of Cases") +
  scale_x_continuous(breaks = seq(1, 53, 13), limits = c(0, 53), expand = c(0,0)) +
  theme_prism()
dev.off()