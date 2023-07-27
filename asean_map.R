library(tidyverse)
library(maps)
library(mapdata)


map <- map_data("world", c("Vietnam", "Indonesia", "Malaysia", "Singapore", "Cambodia", "Laos", "Brunei", "Philippines", "Thailand", "Myanmar"))
ggplot(map, aes(long, lat, group = group)) + geom_polygon(fill = "white", colour = "grey80") +
  coord_quickmap()

world <- map_data("world")
