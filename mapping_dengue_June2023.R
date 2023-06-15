library(rgdal)
library(leaflet)
library(writexl)

sea <- geojson_read(url_file_string = "~/Downloads/southeast-asia.geojson")
sea <- readOGR("~/Downloads/southeast-asia.geojson")

pal <- colorNumeric("viridis", NULL)
leaflet(sea) |> addTiles() |> addPolygons(fillColor = ~pal(totalCases), stroke = FALSE, fillOpacity = 1)

name <- c(sea@data[["name"]], "Singapore")
totalCases <- NA

dat <- data.frame(name, totalCases)

dat[2,2] <- sum(dataCbdCase |> filter(Year == 2023) |> select(`Weekly Dengue cases`))
dat[3,2] <- sum(dataMlyCase |> filter(Year == 2023) |> select(`Weekly Dengue cases`))
dat[4,2] <- sum(dataIdnCase |> filter(year == 2023) |> select(totalReportedCases))
dat[5,2] <- sum(dataLaoCase |> filter(Year == 2023) |> select(`Weekly Dengue cases`))
dat[6,2] <- sum(dataMyrCase |> filter(year == 2023) |> select(totalReportedCases))
dat[7,2] <- sum(dataPhilCase |> filter(Year == 2023) |> select(weeklyCases))
dat[8,2] <- sum(dataThaiCase |> filter(Year == 2023) |> select(`Weekly cases`))
dat[10,2] <- sum(dataVietCase |> filter(Year == 2023) |> select(`Weekly Dengue cases`))
dat[11,2] <- sum(dataSingCase |> filter(Year == 2023) |> select(`Weekly Dengue cases`))
dat$totalCases <- as.numeric(dat$totalCases)

data <- merge(sea, dat, by = "name")

write_xlsx(dat, "ASEAN Dengue Total Cases 2023.xlsx")
