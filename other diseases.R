library(httr)
library(jsonlite)

# Indonesia
inaUrl <- "https://developer.bluedot.global/casecounts/locations/1643084?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(inaUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
inaData <- data.frame(t(sapply(parse$data,c)))
View(inaData)

# Brunei Darussalam
brnUrl <- "https://developer.bluedot.global/casecounts/locations/1820814?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(brnUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
brnData <- data.frame(t(sapply(parse$data,c)))
View(brnData)

# Cambodia
khmUrl <- "https://developer.bluedot.global/casecounts/locations/1831722?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(khmUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
khmData <- data.frame(t(sapply(parse$data,c)))
View(khmData)

# Lao PDR
laoUrl <- "https://developer.bluedot.global/casecounts/locations/1655842?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(laoUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
laoData <- data.frame(t(sapply(parse$data,c)))
View(laoData)

# Malaysia
mlyUrl <- "https://developer.bluedot.global/casecounts/locations/1733045?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(mlyUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
mlyData <- data.frame(t(sapply(parse$data,c)))
View(mlyData)

# Myanmar
myrUrl <- "https://developer.bluedot.global/casecounts/locations/1327865?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(myrUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
myrData <- data.frame(t(sapply(parse$data,c)))
View(myrData)

# Philippines
phlUrl <- "https://developer.bluedot.global/casecounts/locations/1694008?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(phlUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
phlData <- data.frame(t(sapply(parse$data,c)))
View(phlData)

# Singapore
sgpUrl <- "https://developer.bluedot.global/casecounts/locations/1880251?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(sgpUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
sgpData <- data.frame(t(sapply(parse$data,c)))
View(sgpData)

# Thailand
thaUrl <- "https://developer.bluedot.global/casecounts/locations/1605651?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(thaUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
thaData <- data.frame(t(sapply(parse$data,c)))
View(thaData)

# Vietnam
vnmUrl <- "https://developer.bluedot.global/casecounts/locations/1562822?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(vnmUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
vnmData <- data.frame(t(sapply(parse$data,c)))
View(vnmData)

# China
chnUrl <- "https://developer.bluedot.global/casecounts/locations/1814991?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(chnUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
chnData <- data.frame(t(sapply(parse$data,c)))
View(chnData)

# South Korea
korUrl <- "https://developer.bluedot.global/casecounts/locations/1835841?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(korUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
korData <- data.frame(t(sapply(parse$data,c)))
View(korData)

# Japan
jpnUrl <- "https://developer.bluedot.global/casecounts/locations/1861060?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(jpnUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
jpnData <- data.frame(t(sapply(parse$data,c)))
View(jpnData)

# Taiwan
twnUrl <- "https://developer.bluedot.global/casecounts/locations/1668248?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(twnUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
twnData <- data.frame(t(sapply(parse$data,c)))
View(twnData)

# Hong kong
hkgUrl <- "https://developer.bluedot.global/casecounts/locations/1819730?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(hkgUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
hkgData <- data.frame(t(sapply(parse$data,c)))
View(hkgData)

# Macau
macUrl <- "https://developer.bluedot.global/casecounts/locations/1821275?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(macUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
macData <- data.frame(t(sapply(parse$data,c)))
View(macData)

# Timor Leste
tlsUrl <- "https://developer.bluedot.global/casecounts/locations/1966436?diseaseIds=239,%20200,%2013,%2055,%20141,%2064,%2059,%2086,%2012,%2099,%20100,%2032,%206,%208,%2043,%2026,%2053&startDate=2023-06-29&isAggregated=false&includeSources=true&api-version=v1"
res <- GET(tlsUrl, add_headers("Ocp-Apim-Subscription-Key" = "5f645982e25d4a729d7292b890a8ed31", "Cache-Control" = "no-cache"))
parse <- content(res)
tlsData <- data.frame(t(sapply(parse$data,c)))
View(tlsData)
