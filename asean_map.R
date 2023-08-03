library(tidyverse)
library(maps)
library(mapdata)
library(readxl)

map <- map_data("world", c("Vietnam", "Indonesia", "Malaysia", "Singapore", "Cambodia", "Laos", "Brunei", "Philippines", "Thailand", "Myanmar"))
ggplot(map, aes(long, lat, group = group)) + geom_polygon(fill = "white", colour = "grey80") +
  coord_quickmap()

<<<<<<< HEAD
world <- map_data("world")

data_hbv <- read_xlsx("HBV seroprevalence.xlsx") |> 
  filter(Region %in% c("Brunei Darussalam", "Cambodia", "Indonesia", "Laos", "Philippines", "Malaysia", "Myanmar", "Thailand", "Vietnam", "Singapore"))

data_hcv <- read_xlsx("HCV seroprevalence.xlsx") |> 
  filter(Region %in% c("Brunei Darussalam", "Cambodia", "Indonesia", "Laos", "Philippines", "Malaysia", "Myanmar", "Thailand", "Vietnam", "Singapore"))

=======
world <- map_data("world")
>>>>>>> 10904b18c7c51dc0dc5888652ede647edde41f7d
