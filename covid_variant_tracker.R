library(tidyverse)
library(lubridate)
library(RColorBrewer)
library(highcharter)
library(jsonlite)
library(ggprism)

# Data Import
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
                                                                                    if_else(grepl("BA.2.86", data_gisaid_lineage$lineage), "BA.2.86+BA.2.86.* excluding JN.1, JN.1.*",
                                                                                            if_else(grepl("B.1.640", data_gisaid_lineage$lineage), "B.1.640+B.1.640.*",
                                                                                                    if_else(grepl("B.1.617.2|AY", data_gisaid_lineage$lineage), "B.1.617.2+AY*",
                                                                                                            if_else(grepl("B.1.1.529|BA", data_gisaid_lineage$lineage), "Omicron B.1.1.529+BA.*",
                                                                                                                    if_else(grepl("JN.1", data_gisaid_lineage$lineage), "JN.1+JN.1.*",
                                                                                                                            if_else(grepl("XBB.1.9.2", data_gisaid_lineage$lineage), "XBB.1.9.2+XBB.1.9.2.*",
                                                                                                                                    if_else(grepl("XBB", data_gisaid_lineage$lineage), "XBB", data_gisaid_lineage$lineage)
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

# ASEAN region
asean_countries <- c("Brunei", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam")
## Variant
asean_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country %in% asean_countries) |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100,
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  select(-variant) |> arrange(month)
asean_variant$line[asean_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
asean_variant$line[asean_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
colourCount = length(unique(asean_variant$line))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))
asean_variant_plot <- ggplot(asean_variant, aes(month, pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%B") +
  theme_prism() + theme(legend.position = "bottom") + xlab(element_blank()) +
  ylab("Value (%)")
asean_variant_plot

# ## Lineage (bar chart)
# asean_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country %in% asean_countries) |> 
#   mutate(month = floor_date(as.Date(date), 'month')) |> 
#   arrange(date) |> 
#   group_by(month, line) |> 
#   summarise(n = sum(count)) |> 
#   mutate(pct = n / sum(n)*100)
# colourCount = length(unique(asean_lineage$line))
# getPalette = colorRampPalette(brewer.pal(9, "Paired"))
# asean_lineage_plot <- ggplot(asean_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b '%y") +
#   theme_prism() + theme(legend.position = "right") + xlab(element_blank()) +
#   ylab("Value (%)") + scale_fill_manual(values = getPalette(colourCount))
# asean_lineage_plot

## Export
jpeg("ASEAN COVID-19 Variant Trend 2023-2024.jpeg", units="px", width=4000, height=2250, res=300)
asean_variant_plot
dev.off()

## Lineage (area highchart)
asean_variant_barplot <- asean_variant |> hchart('column', hcaes(month, pct, group = line)) |> 
  hc_xAxis(dateTimeLabelFormats = list(month = "%b '%y"), 
           type = "datetime") |> 
  hc_plotOptions(series = list(marker = list(enabled = FALSE), stacking = "normal",
                               pointWidth = 100))

asean_variant_areaplot <- asean_variant |> hchart('area', hcaes(month, pct, group = line)) |> 
  hc_xAxis(dateTimeLabelFormats = list(month = "%b '%y"), 
           type = "datetime") |> 
  hc_plotOptions(area = list(stacking = "percent", marker = list(enabled = FALSE)))
htmlwidgets::saveWidget(widget = asean_variant_areaplot, file = "ASEAN Variant Chart 2023-2024.html")

# Brunei
brn_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Brunei") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100,
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  select(-variant) |> 
  arrange(month)
brn_variant$line[brn_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
brn_variant$line[brn_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# brn_variant_march_may$line[brn_variant_march_may$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
# brn_variant_march_may$line[brn_variant_march_may$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# brn_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country == "Brunei") |> 
#   mutate(month = floor_date(as.Date(date), 'month')) |> arrange(date) |> group_by(month, line) |> 
#   summarise(n = sum(count)) |> mutate(pct = n / sum(n)*100) |> 
#   full_join(brn_variant_march_may) |> arrange(month)
# brn_lineage_plot <- ggplot(brn_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ylab("Submission Rate (%)") +
#   xlab(element_blank()) + ggtitle("Brunei Darussalam")

# Cambodia
khm_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Cambodia") |> 
  mutate(month = floor_date(as.Date(date), 'month'),
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  arrange(date) |> 
  group_by(month, line) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100)
khm_variant$line[khm_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
khm_variant$line[khm_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# khm_variant_plot <- ggplot(khm_variant, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ylab("Submission Rate (%)") +
#   xlab(element_blank()) + ggtitle("Cambodia")

# Indonesia
idn_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Indonesia") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100,
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  select(-variant) |> 
  arrange(month)
idn_variant$line[idn_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
idn_variant$line[idn_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# idn_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country == "Indonesia") |> 
#   mutate(month = floor_date(as.Date(date), 'month')) |> arrange(date) |> group_by(month, line) |> summarise(n = sum(count)) |> 
#   mutate(pct = n / sum(n)*100) |> full_join(idn_variant_may_aug) |> arrange(month)
# idn_lineage_plot <- ggplot(idn_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ggtitle("Indonesia") + 
#   ylab("Submission Rate (%)") + xlab(element_blank())

# Lao PDR
lao_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Laos") |> 
  mutate(month = floor_date(as.Date(date), 'month'),
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  arrange(date) |> 
  group_by(month, line) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100)
lao_variant$line[lao_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
lao_variant$line[lao_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# lao_variant_plot <- ggplot(lao_variant, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ggtitle("Lao PDR") +
#   ylab("Submission Rate (%)") + xlab(element_blank())

# Malaysia
mys_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Malaysia") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100,
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  select(-variant) |> 
  arrange(month)
mys_variant$line[mys_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
mys_variant$line[mys_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# mys_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country == "Malaysia") |> 
#   mutate(month = floor_date(as.Date(date), 'month')) |> 
#   arrange(date) |> 
#   group_by(month, line) |> 
#   summarise(n = sum(count)) |> 
#   mutate(pct = n / sum(n)*100)
# mys_lineage_plot <- ggplot(mys_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") +
#   ylab("Submission Rate (%)") + xlab(element_blank())

# Myanmar
mmr_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Myanmar") |> 
  mutate(month = floor_date(as.Date(date), 'month'),
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  arrange(date) |> 
  group_by(month, line) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100)
mmr_variant$line[mmr_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
mmr_variant$line[mmr_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# mmr_variant_plot <- ggplot(mmr_variant, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ggtitle("Myanmar") + ylab("Submission Rate (%)") +
#   xlab(element_blank())

# Philippines
phl_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Philippines") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100,
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  select(-variant) |> 
  arrange(month)
phl_variant$line[phl_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
phl_variant$line[phl_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# phl_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country == "Philippines") |> 
#   mutate(month = floor_date(as.Date(date), 'month')) |> 
#   arrange(date) |> 
#   group_by(month, line) |> 
#   summarise(n = sum(count)) |> 
#   mutate(pct = n / sum(n)*100) |> 
#   full_join(phl_variant_july) |> arrange(month)
# phl_lineage_plot <- ggplot(phl_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ggtitle("Philippines") + ylab("Submission Rate (%)") +
#   xlab(element_blank())

# Singapore
sgp_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Singapore") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n))
sgp_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country == "Singapore") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, line) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100)
# sgp_lineage_plot <- ggplot(sgp_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ylab("Submisison Rate (%)") +
#   xlab(element_blank()) + ggtitle("Singapore")

# Thailand
tha_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Thailand") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, variant) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n))
tha_lineage <- data_gisaid_lineage |> filter(date >= "2023-01-01", country == "Thailand") |> 
  mutate(month = floor_date(as.Date(date), 'month')) |> 
  arrange(date) |> 
  group_by(month, line) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100)
# tha_lineage_plot <- ggplot(tha_lineage, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ggtitle("Thailand") + ylab("Submission Rate (%)") +
#   xlab(element_blank())

# Vietnam
vnm_variant <- data_gisaid_variant |> filter(date >= "2023-01-01", country == "Vietnam") |> 
  mutate(month = floor_date(as.Date(date), 'month'),
         line = gsub(".*\\((.*)\\).*", "\\1", variant)) |> 
  arrange(date) |> 
  group_by(month, line) |> 
  summarise(n = sum(count)) |> 
  mutate(pct = n / sum(n)*100)
vnm_variant$line[vnm_variant$line == "B.1.1.529+BA.*"] <- "Omicron B.1.1.529+BA.*"
vnm_variant$line[vnm_variant$line == "XBB+XBB.* excluding XBB.1.5, XBB.1.16, XBB.1.9.1, XBB.1.9.2, XBB.2.3"] <- "XBB"
# vnm_variant_plot <- ggplot(vnm_variant, aes(month, pct, fill = line)) +
#   geom_bar(stat = "identity", position = "stack") +
#   scale_x_date(date_breaks = "1 month", date_labels = "%b") +
#   theme_prism() + theme(legend.position = "bottom") + ggtitle("Vietnam") + ylab("Submission Rate (%)") +
#   xlab(element_blank())

# Plot
brn_variant$country <- "Brunei DS"
khm_variant$country <- "Cambodia"
idn_variant$country <- "Indonesia"
lao_variant$country <- "Lao PDR"
mys_variant$country <- "Malaysia"
mmr_variant$country <- "Myanmar"
phl_variant$country <- "Philippines"
sgp_lineage$country <- "Singapore"
tha_lineage$country <- "Thailand"
vnm_variant$country <- "Vietnam"
data_ams_variant <- rbind(brn_variant,
                          khm_variant,
                          idn_variant,
                          lao_variant,
                          mys_variant,
                          mmr_variant,
                          phl_variant,
                          sgp_lineage,
                          tha_lineage,
                          vnm_variant)

colourCount = length(unique(data_ams_variant$line))
getPalette = colorRampPalette(brewer.pal(9, "Paired"))
ams_variant_plot <- ggplot(data_ams_variant, aes(month, pct, fill = line)) +
  geom_bar(stat = "identity", position = "stack") +
  scale_x_date(date_breaks = "1 month", date_labels = "%b '%y") +
  theme_prism() + theme(legend.position = "bottom") + ylab("Value (%)") +
  xlab(element_blank()) + facet_wrap(vars(country), nrow = 5, ncol = 2) +
  scale_fill_manual(values = getPalette(colourCount))
ams_variant_plot

jpeg("AMS COVID-19 Variant trend 2023.jpeg", units = "px", width = 4000, height = 3000, res = 300)
ams_variant_plot
dev.off()

# data_ams_variant_pivot <- data_ams_variant |> select(-n) |> 
#   group_by(country) |> mutate(row = row_number()) |> 
#   pivot_wider(names_from = line, values_from = pct) |> 
#   arrange(month, country) |> select(-row)
# 
# writexl::write_xlsx(data_ams_variant_pivot, "ASEAN Variant 8Jan24.xlsx")

brn_pie <- brn_variant |> filter(month == "2023-10-01")
khm_pie <- khm_variant |> filter(month == "2023-12-01")
idn_pie <- idn_lineage |> filter(month == "2023-12-01")
lao_pie <- lao_variant |> filter(month == "2023-11-01")
mys_pie <- mys_lineage |> filter(month == "2023-12-01")
mmr_pie <- mmr_variant |> filter(month == "2023-09-01")
phl_pie <- phl_lineage |> filter(month == "2023-12-01")
sgp_pie <- sgp_lineage |> filter(month == "2023-12-01")
tha_pie <- tha_lineage |> filter(month == "2023-11-01")
vnm_pie <- vnm_variant |> filter(month == "2023-11-01")

ams_pie <- rbind(brn_pie, khm_pie, idn_pie, lao_pie, mys_pie,
                 mmr_pie, phl_pie, sgp_pie, tha_pie, vnm_pie)

ams_pie$line[ams_pie$line == "BA.2.86+BA.2.86.* excluding JN.1, JN.1.*"] <- "BA.2.86.*"

colourCount = length(unique(ams_pie$line))
getPalette = colorRampPalette(brewer.pal(9, "Paired"))

ams_variant_pie <- ggplot(ams_pie, aes(x = "", y = pct, fill = line)) +
  geom_bar(stat="identity", width=1) + coord_polar("y", start = 0) +
  facet_wrap(vars(country), nrow = 2, ncol = 5) + 
  theme_prism() +
  theme(legend.position = "bottom",
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank()) +
  scale_fill_manual(values = getPalette(colourCount))

jpeg("AMS COVID-19 Variant December 2023.jpeg", units = "px", width = 4000, height = 3000, res = 300)
ams_variant_pie
dev.off()