library(tidyverse)
library(readxl)

data <- read_xlsx("~/Downloads/DataExport_020224.xlsx")
names(data) <- tolower(names(data))
data$inf_all <- as.numeric(data$inf_all)

df_type <- data |> 
  filter(country_code %in% c("BRN", "KHM", "IDN", "LAO", "PHL", "THA", "VNM", "MMR", "SGP", "MYS"),
         iso_sdate >= "2023-01-01") |> 
  rename(country = "country/area/territory") |> 
  mutate(date = as.Date(iso_sdate)) |> 
  select(country, date, inf_a, inf_b) |> 
  pivot_longer(cols = c(inf_a, inf_b), names_to = "type", values_to = "n")

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

ggplot() + 
  geom_col(data = filter(df_type, country == "Indonesia"), aes(date, as.numeric(n), fill = type)) +
  geom_line(data = filter(df, country == "Indonesia"), aes(x = date, y = pos_rate_scaled))

ggplot() +
  geom_smooth(data = filter(df, country == "Indonesia"), aes(x = date, y = pos_rate))

ggplot(data = df, aes(x = date, y = pos_rate, fill = country)) +
  geom_area()
