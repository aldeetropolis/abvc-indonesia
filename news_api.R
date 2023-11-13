library(tidyverse)
library(jsonlite)
library(httr)

url <- "https://newsapi.org/v2/top-headlines?country=id&apiKey=bdf7d47b234744b6a6132631d69c70e1"
res <- GET(url) |> content()
news <- enframe(pluck(res, "articles")) |> unnest_wider(value)

url <- "https://newsapi.org/v2/everything?q=diphtheria&from=2023-10-08&sortBy=popularity&apiKey=bdf7d47b234744b6a6132631d69c70e1"
res <- GET(url) |> content()
news <- enframe(pluck(res, "articles")) |> unnest_wider(value)