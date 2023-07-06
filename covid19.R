library(tidyverse)
library(ggthemes)
library(scales)

# Daily COVID-19 data
link <- "https://covid19.who.int/WHO-COVID-19-global-data.csv"
download.file(link, "WHO-COVID-19-global-data.csv")
data <- read_csv("WHO-COVID-19-global-data.csv") |> 
  filter(Country_code %in% c("BN", "KH", "ID", "LA", "PH", "TH", "VN", "MM", "SG", "MY"),
         Date_reported >= "2022-01-01") |> 
  mutate(Country = replace(Country, Country == "Lao People's Democratic Republic", "Lao PDR"),
         Country = replace(Country, Country == "Viet Nam", "Vietnam"))

jpeg("epicurve COVID-19 ASEAN 6 July 2023.jpeg", units="px", width=3750, height=2250, res=300)
ggplot(data) + 
  geom_line(aes(Date_reported, Cumulative_cases, color = Country), linewidth = 1.0) +
  scale_y_continuous(labels = label_number(suffix = "M", scale = 1e-6)) +
  theme(legend.title = element_blank()) +
  xlab(element_blank()) +
  ylab("Cumulative cases") +
  theme_hc()
dev.off()

# Vaccination coverage
link <- "https://covid19.who.int/who-data/vaccination-data.csv"
download.file(link, "vaccination-data.csv")
vacc <- read_csv("vaccination-data.csv") |> 
  filter(ISO3 %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS")) |> 
  mutate(COUNTRY = replace(COUNTRY, COUNTRY == "Lao People's Democratic Republic", "Lao PDR"),
         COUNTRY = replace(COUNTRY, COUNTRY == "Viet Nam", "Vietnam")) |> 
  select(1, 5, 7, 9, 10, 11, 15, 16)
DT::datatable(vacc)
