library(tidyverse)
library(maps)
library(mapdata)
library(readxl)

data_hbv <- read_xlsx("HBV seroprevalence.xlsx") |> 
  filter(Region %in% c("Brunei Darussalam", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam")) |> 
  mutate(region = recode(Region, "Brunei DS" = "Brunei Darussalam",
                         "Lao PDR" = "Laos"),
         prev = cut(as.numeric(Prevalence), breaks = c(0.001, 0.03, 0.08, 0.10), labels = c("<3%", "3 - 8%", ">8%")))

data_hcv <- read_xlsx("HCV seroprevalence.xlsx") |> 
  filter(Region %in% c("Brunei Darussalam", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", "Thailand", "Vietnam")) |> 
  mutate(region = recode(Region, "Brunei DS" = "Brunei Darussalam",
                         "Lao PDR" = "Laos"),
         prev = cut(as.numeric(Prevalence), breaks = c(0.001, 0.005, 0.011), labels = c("<0.5%", ">=0.5%")))

map <- map_data("world", c("Vietnam", "Indonesia", "Malaysia", "Singapore", "Cambodia", "Laos", "Brunei", "Philippines", "Thailand", "Myanmar")) |> 
  mutate(region = recode(region, "Brunei" = "Brunei DS", "Laos" = "Lao PDR"))

hbv_map <- left_join(map, data_hbv, by = "region")

hcv_map <- left_join(map, data_hcv, by = "region")

hbv_plot <- ggplot(hbv_map, aes(long, lat, group = group)) + geom_polygon(aes(fill = prev), colour = "grey80") +
  coord_quickmap() + theme_void()

hcv_plot <- ggplot(hcv_map, aes(long, lat, group = group)) + geom_polygon(aes(fill = prev), colour = "grey80") +
  coord_quickmap() + theme_void()

world <- map_data("world")