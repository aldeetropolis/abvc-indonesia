library(tidyverse)
library(rio)
library(readxl)

data_mpox <- read_csv("mpox cases and deaths by country (17).csv")
data_viet <- read_excel("VIetnam death case vaccination 2021-2022.xlsx") |> 
  select(!c("...19", "...20", "sources")) |> 
  mutate(reportedDate = openxlsx::convertToDate(reportedDate)) |> 
  rename(weeklyDeaths = "weekly deaths",
         cumulativeVaccination = "cumulative vaccination") |> 
  filter(!is.na(cumulativeVaccination), !is.na(totalConfirmedCases))

cor(data_viet$cumulativeVaccination, data_viet$weeklyDeaths, method = "spearman")
cor(data_viet$cumulativeVaccination, data_viet$totalDeaths)

with(data_viet, plot(cumulativeVaccination, totalDeaths))
abline(fit <- lm(cumulativeVaccination ~ totalDeaths, data = data_viet), col = 'red')
legend("topright", bty="n", legend=paste("R2 =", format(summary(fit)$adj.r.squared, digits=4)))

cor(data_viet$cumulativeVaccination, data_viet$totalConfirmedCases)
t.test(data_viet$cumulativeVaccination, data_viet$weeklyDeaths)
t.test(data_viet$cumulativeVaccination, data_viet$weeklyDeaths)
