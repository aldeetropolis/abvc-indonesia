library(tidyverse)

# Install development version from GitHub
remotes::install_github("outbreak-info/R-outbreak-info")

# Auth
outbreakinfo::authenticateUser()

library(outbreakinfo)
#  Provide GISAID credentials using authenticateUser()
# Get the prevalence of all circulating lineages in California over the past 90 days
ca_lineages <- getAllLineagesByLocation(location = "Indonesia", ndays = 90)

# Plot the prevalence of the dominant lineages in California
plotAllLineagesByLocation(location = "Indonesia", ndays = 30)
