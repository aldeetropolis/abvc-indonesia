library(tidyRSS)
df <- tidyfeed("https://rss.diffbot.com/rss?url=https://www.who.int/emergencies/disease-outbreak-news",
               parse_dates = FALSE)
