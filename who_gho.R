library(httr)
library(jsonlite)
library(tidyverse)
library(flextable)
library(lubridate)
library(ggthemes)
library(ggrepel)
library(writexl)

dimUrl <- "https://ghoapi.azureedge.net/api/Dimension"
res <- GET(url) |> content()
dim <- enframe(pluck(res, "value")) |> unnest_wider(value)

countryUrl <- "https://ghoapi.azureedge.net/api/DIMENSION/COUNTRY/DimensionValues"
res <- GET(countryUrl) |> content()
country <- enframe(pluck(res, "value")) |> 
  unnest_wider(value) |> select(Code, Title) |> 
  rename(country_code = Code, country_name = Title)

timeperiodUrl <- "https://ghoapi.azureedge.net/api/DIMENSION/TIMEPERIOD/DimensionValues"
res <- GET(timeperiodUrl) |> content()
timeperiod <- enframe(pluck(res, "value")) |> unnest_wider(value)

indUrl <- "https://ghoapi.azureedge.net/api/Indicator"
res <- GET(indUrl) |> content()
indicator <- enframe(pluck(res, "value")) |> unnest_wider(value)

# Diphtheria - number of reported cases
diphUrl <- "https://ghoapi.azureedge.net/api/WHS3_41"
res <- GET(diphUrl) |> content()
diphData <- enframe(pluck(res, "value")) |> 
  unnest_wider(value) |> 
  filter(TimeDim >= 2018, SpatialDim %in% c("BRN", "KHM", "IDN", "LAO", "MYS", "MMR", "PHL", "SGP", "THA", "VNM")) |> 
  select(SpatialDim, TimeDim, NumericValue) |> 
  rename(country_code = SpatialDim,
         year = TimeDim,
         reported_case = NumericValue)

# Diphtheria - vaccine coverage
diphVaccUrl <- "https://ghoapi.azureedge.net/api/WHS4_100"
res <- GET(diphVaccUrl) |> content()
diphVaccData <- enframe(pluck(res, "value")) |> 
  unnest_wider(value) |> 
  filter(TimeDim >= 2018, SpatialDim %in% c("BRN", "KHM", "IDN", "LAO", "MYS", "MMR", "PHL", "SGP", "THA", "VNM")) |> 
  select(SpatialDim, TimeDim, NumericValue) |> 
  rename(country_code = SpatialDim,
         year = TimeDim,
         vaccine_coverage = NumericValue)

# Population
popUrl <- "https://ghoapi.azureedge.net/api/RS_1845"
res <- GET(popUrl) |> content()
popData <- enframe(pluck(res, "value")) |> 
  unnest_wider(value) |> 
  filter(SpatialDim %in% c("BRN", "KHM", "IDN", "LAO", "MYS", "MMR", "PHL", "SGP", "THA", "VNM")) |> 
  select(SpatialDim, NumericValue) |> 
  rename(country_code = SpatialDim,
         population = NumericValue)

df <- left_join(diphData, popData, by = "country_code") |> 
  left_join(diphVaccData, by = c("country_code", "year")) |> 
  left_join(country, by = "country_code") |> 
  mutate(case_per_pop = round((reported_case/population)*1000000, 2),
         ir = (reported_case/population)*100,
         country_name = recode(country_name,
                               "Lao People's Democratic Republic" = "Lao PDR",
                               "Brunei Darussalam" = "Brunei DS"),
         name_lab = if_else(year == 2022, country_name, NA_character_)) |> 
  group_by(country_name)

df_vacc <- pivot_wider(df, id_cols = country_name, names_from = year, values_from = vaccine_coverage)
df_case <- pivot_wider(df, id_cols = country_name, names_from = year, values_from = reported_case)

plot_vacc <- ggplot(df, aes(year, vaccine_coverage, colour = country_name)) + 
  geom_line(linewidth = .9) + 
  geom_point(aes(colour = country_name, shape = country_name), size = 2) +
  geom_text_repel(aes(color = country_name, label = name_lab),
                  fontface = "bold",
                  size = 5,
                  direction = "y",
                  xlim = c(2022.9, NA),
                  hjust = 0,
                  segment.size = .7,
                  segment.alpha = .5,
                  segment.linetype = "dotted",
                  box.padding = .4,
                  segment.curvature = -0.1,
                  segment.ncp = 3,
                  segment.angle = 20) + 
  coord_cartesian(
    clip = "off",
    ylim = c(25, 100)
  ) +
  scale_x_continuous(
    expand = c(0, 0),
    limits = c(2018, 2022), 
    breaks = seq(2018, 2022)
  ) + ylab("Vaccine coverage in %") +
  theme_hc() +
  theme(legend.position = "none", 
        plot.margin = margin(20, 90, 20, 20),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
plot_vacc

jpeg("vaccine coverage asean 2018-2022.jpeg", units="px", width=4000, height=2250, res=300)
plot_vacc
dev.off()

plot_case <- ggplot(df, aes(year, reported_case, fill = country_name), color = "black", stat = "bin", linewidth = 5) + 
  geom_area() + 
  ylab("Number of case") +
  theme_hc() +
  theme(legend.title = element_blank(), 
        plot.margin = margin(20, 90, 20, 20),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
plot_case

jpeg("number of cases asean.jpeg", units="px", width=4000, height=2250, res=300)
plot_case
dev.off()

plot_pop <- ggplot(df) + geom_line(aes(year, case_per_pop, color = country_name))

writexl::write_xlsx(df, "asean diphtheria data who 2018-2022 (1).xlsx")
