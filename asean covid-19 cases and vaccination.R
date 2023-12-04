library(tidyverse)
library(ggthemes)
library(lubridate)
library(zoo)

# Case Data
link <- "https://covid19.who.int/WHO-COVID-19-global-data.csv"
download.file(link, "WHO-COVID-19-global-data.csv")
cov_data <- read_csv("WHO-COVID-19-global-data.csv") |> 
  filter(Country_code %in% c("BN", "KH", "ID", "LA", "PH", "TH", "VN", "MM", "SG", "MY")) |> 
  mutate(Country = replace(Country, Country == "Lao People's Democratic Republic", "Lao PDR"),
         Country = replace(Country, Country == "Viet Nam", "Vietnam"),
         Country = replace(Country, Country == "Brunei Darussalam", "Brunei DS"))

# Vaccination Data
url <- "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv"
download.file(url, "vaccinations.csv")
vacc_data <- read_csv("vaccinations.csv") |> 
  filter(iso_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS")) |> 
  mutate(location = replace(location, location == "Brunei", "Brunei DS"),
         location = replace(location, location == "Laos", "Lao PDR"))

# Merge case and vaccination data


# Brunei DS
brn_case_data <- cov_data |> filter(Country_code == "BN")
brn_vacc_data <- vacc_data |> filter(iso_code == "BRN")

ggplot() + geom_line(data = brn_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = brn_vacc_data, aes(date, daily_vaccinations))

# Cambodia
khm_case_data <- cov_data |> filter(Country_code == "KH")
khm_vacc_data <- vacc_data |> filter(iso_code == "KHM")

ggplot() + geom_line(data = khm_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = khm_vacc_data, aes(date, daily_vaccinations))

# Indonesia
khm_case_data <- cov_data |> filter(Country_code == "KH")
khm_vacc_data <- vacc_data |> filter(iso_code == "KHM")

ggplot() + geom_line(data = khm_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = khm_vacc_data, aes(date, daily_vaccinations))

# Lao PDR
lao_case_data <- cov_data |> filter(Country_code == "LA")
lao_vacc_data <- vacc_data |> filter(iso_code == "Lao")

ggplot() + geom_line(data = lao_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = lao_vacc_data, aes(date, daily_vaccinations))

# Malaysia
mys_case_data <- cov_data |> filter(Country_code == "MY")
mys_vacc_data <- vacc_data |> filter(iso_code == "MYS")

ggplot() + geom_line(data = mys_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = mys_vacc_data, aes(date, daily_vaccinations))

# Myanmar
mmr_case_data <- cov_data |> filter(Country_code == "MM")
mmr_vacc_data <- vacc_data |> filter(iso_code == "MMR")

ggplot() + geom_line(data = mmr_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = mmr_vacc_data, aes(date, daily_vaccinations))

# Philippines
phl_case_data <- cov_data |> filter(Country_code == "PH")
phl_vacc_data <- vacc_data |> filter(iso_code == "PHL")

ggplot() + geom_line(data = phl_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = phl_vacc_data, aes(date, daily_vaccinations))

# Singapore
sgp_case_data <- cov_data |> filter(Country_code == "SG")
sgp_vacc_data <- vacc_data |> filter(iso_code == "SGP")

ggplot() + geom_line(data = sgp_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = sgp_vacc_data, aes(date, daily_vaccinations))

# Thailand
tha_case_data <- cov_data |> filter(Country_code == "TH")
tha_vacc_data <- vacc_data |> filter(iso_code == "THA")

ggplot() + geom_line(data = tha_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = tha_vacc_data, aes(date, daily_vaccinations))

# Vietnam
vnm_case_data <- cov_data |> filter(Country_code == "VN")
vnm_vacc_data <- vacc_data |> filter(iso_code == "VNM")

ggplot() + geom_line(data = vnm_case_data, aes(Date_reported, New_cases)) +
  geom_line(data = vnm_vacc_data, aes(date, daily_vaccinations))