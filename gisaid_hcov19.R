library(tidyverse)
library(lubridate)
library(readxl)
library(jsonlite)

voi <- c("XBB.1.16", "XBB.1.5", "BA.2.75", "CH.1.1", "EG.5", "XBB.1.9.1", "XBB.1.9.2",
         "XBB.2.3", "B.1.1.529", "B.1.640", "B.1.617.2", "BA.2.86", "JN.1", "^XBB$")
data <- read_xlsx("GISAID per 19 Desember 2023.xlsx", sheet = "Linelist")
data$line <- if_else(grepl("XBB.1.16", data$Lineage), "XBB.1.16+XBB.1.16.*",
                     if_else(grepl("XBB.1.5", data$Lineage), "XBB.1.5+XBB.1.5.*",
                             if_else(grepl("BA.2.75", data$Lineage), "BA.2.75+BA.2.75.*",
                                     if_else(grepl("CH.1.1", data$Lineage), "CH.1.1+CH.1.1.*",
                                             if_else(grepl("EG.5", data$Lineage), "EG.5+EG.5.*",
                                                     if_else(grepl("XBB.1.9.1", data$Lineage), "XBB.1.9.1+XBB.1.9.1.*",
                                                             if_else(grepl("XBB.2.3", data$Lineage), "XBB.2.3+XBB.2.3.*",
                                                                     if_else(grepl("BA.2.86", data$Lineage), "BA.2.86.*",
                                                                             if_else(grepl("B.1.640", data$Lineage), "B.1.640+B.1.640.*",
                                                                                     if_else(grepl("B.1.617.2|AY", data$Lineage), "B.1.617.2+AY*",
                                                                                             if_else(grepl("B.1.1.529|BA", data$Lineage), "Omicron B.1.1.529+BA.*",
                                                                                                     if_else(grepl("JN.1", data$Lineage), "JN.1+JN.1.*",
                                                                                                             if_else(grepl("XBB.1.9.2", data$Lineage), "XBB.1.9.2+XBB.1.9.2.*",
                                                                                                                     if_else(grepl("XBB", data$Lineage), "XBB", "Others")
                                                                                                             )
                                                                                                     )
                                                                                             )
                                                                                     )
                                                                             )
                                                                     )
                                                             )
                                                     )
                                             )
                                     )
                             )
                     )
)

df <- data |> filter("Collection date" >= "2023-01-01") |> 
  mutate(month = floor_date(`Collection date`, 'month')) |> 
  arrange(Country, `Collection date`) |> 
  count(Country, month, line) |> 
  group_by(Country, month) |> 
  mutate(pct = n / sum(n))

# Plot Brunei
ggplot(filter(df, Country == "Brunei"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") + 
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

ggplot(filter(df, Country == "Brunei"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_area() + 
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Cambodia
ggplot(filter(df, Country == "Cambodia"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Indonesia
ggplot(filter(df, Country == "Indonesia"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Lao PDR
ggplot(filter(df, Country == "Laos"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Malaysia
ggplot(filter(df, Country == "Malaysia"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Myanmar
ggplot(filter(df, Country == "Myanmar"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Philippines
ggplot(filter(df, Country == "Philippines"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Singapore
ggplot(filter(df, Country == "Singapore"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Thailand
ggplot(filter(df, Country == "Thailand"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Vietnam
ggplot(filter(df, Country == "Viet Nam"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Another Data
js <- read_json("gisaid_variants_statistics.json")
data_gisaid_variant <- pluck(js, "stats") |> 
  enframe() |> 
  unnest_longer(value) |> 
  unnest_wider(value) |> 
  select(name, value_id, submissions_per_variant) |> 
  unnest_longer(submissions_per_variant) |> 
  hoist(submissions_per_variant, variant = list(2), count = list(1)) |> 
  rename(country = value_id, date = name) |> select(-submissions_per_variant) |> 
  arrange(date)

data_gisaid_lineage <- pluck(js, "stats") |> 
  enframe() |> 
  unnest_longer(value) |> 
  unnest_wider(value) |> 
  select(name, value_id, submissions_per_lineage) |> 
  unnest_longer(submissions_per_lineage) |> 
  hoist(submissions_per_lineage, lineage = list(2), count = list(1)) |> 
  rename(country = value_id, date = name) |> select(-submissions_per_lineage) |> 
  arrange(date)

data_gisaid_lineage$line <- if_else(grepl("XBB.1.16", data_gisaid_lineage$lineage), "XBB.1.16+XBB.1.16.*",
                     if_else(grepl("XBB.1.5", data_gisaid_lineage$lineage), "XBB.1.5+XBB.1.5.*",
                             if_else(grepl("BA.2.75", data_gisaid_lineage$lineage), "BA.2.75+BA.2.75.*",
                                     if_else(grepl("CH.1.1", data_gisaid_lineage$lineage), "CH.1.1+CH.1.1.*",
                                             if_else(grepl("EG.5", data_gisaid_lineage$lineage), "EG.5+EG.5.*",
                                                     if_else(grepl("XBB.1.9.1", data_gisaid_lineage$lineage), "XBB.1.9.1+XBB.1.9.1.*",
                                                             if_else(grepl("XBB.2.3", data_gisaid_lineage$lineage), "XBB.2.3+XBB.2.3.*",
                                                                     if_else(grepl("BA.2.86", data_gisaid_lineage$lineage), "BA.2.86.*",
                                                                             if_else(grepl("B.1.640", data_gisaid_lineage$lineage), "B.1.640+B.1.640.*",
                                                                                     if_else(grepl("B.1.617.2|AY", data_gisaid_lineage$lineage), "B.1.617.2+AY*",
                                                                                             if_else(grepl("B.1.1.529|BA", data_gisaid_lineage$lineage), "Omicron B.1.1.529+BA.*",
                                                                                                     if_else(grepl("JN.1", data_gisaid_lineage$lineage), "JN.1+JN.1.*",
                                                                                                             if_else(grepl("XBB.1.9.2", data_gisaid_lineage$lineage), "XBB.1.9.2+XBB.1.9.2.*",
                                                                                                                     if_else(grepl("XBB", data_gisaid_lineage$lineage), "XBB", "Others")
                                                                                                             )
                                                                                                     )
                                                                                             )
                                                                                     )
                                                                             )
                                                                     )
                                                             )
                                                     )
                                             )
                                     )
                             )
                     )
)

# Plot Brunei
ggplot(filter(data_gisaid_lineage, country == "Brunei"), aes(x = date, y = count, fill = line)) +
  geom_bar(stat = "identity", position = "stack") + 
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

ggplot(filter(df, Country == "Brunei"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_area() + 
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Cambodia
ggplot(filter(df, Country == "Cambodia"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Indonesia
ggplot(filter(df, Country == "Indonesia"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Lao PDR
ggplot(filter(df, Country == "Laos"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Malaysia
ggplot(filter(df, Country == "Malaysia"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Myanmar
ggplot(filter(df, Country == "Myanmar"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Philippines
ggplot(filter(df, Country == "Philippines"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Singapore
ggplot(filter(df, Country == "Singapore"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Thailand
ggplot(filter(df, Country == "Thailand"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")

# Plot Vietnam
ggplot(filter(df, Country == "Viet Nam"), aes(x = as.Date(month), y = pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B")
