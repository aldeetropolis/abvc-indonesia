library(tidyverse)
library(writexl)

data <- read_csv("~/Downloads/contacts-7.csv") |> 
  select("Name", "Group Membership", "E-mail 1 - Value", "E-mail 2 - Value", "Organization 1 - Name",
         "Organization 1 - Title", "Organization 1 - Department")

write_xlsx(data, "~/Downloads/ABVC Mailing Lists.xlsx")
