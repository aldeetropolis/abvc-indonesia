library(curl)

# 2024
thai_surdata <- function(epiweek) {
  df_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d66_", epiweek, "67.pdf")
  curl_download(df_link, paste0("thai surdata/2024_", epiweek, "_df.pdf"))
  
  dhf_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d26_", epiweek, "67.pdf")
  curl_download(dhf_link, paste0("thai surdata/2024_", epiweek, "_dhf.pdf"))
  
  dss_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d27_", epiweek, "67.pdf")
  curl_download(dss_link, paste0("thai surdata/2024_", epiweek, "_dss.pdf"))
  
  malaria_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d30_", epiweek, "67.pdf")
  curl_download(malaria_link, paste0("thai surdata/2024_", epiweek, "_malaria.pdf"))
  
  diph_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d23_", epiweek, "67.pdf")
  curl_download(diph_link, paste0("thai surdata/2024_", epiweek, "_diphtheria.pdf"))
  
  measles_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d21_", epiweek, "67.pdf")
  curl_download(measles_link, paste0("thai surdata/2024_", epiweek, "_measles.pdf"))
  
  rabies_link <- paste0("http://doe.moph.go.th/surdata/506wk/y67/d42_", epiweek, "67.pdf")
  curl_download(rabies_link, paste0("thai surdata/2024_", epiweek, "_rabies.pdf"))
}

thai_surdata(32)

# 2023

for (i in 10:53) {
  url <- paste0("http://doe.moph.go.th/surdata/506wk/y66/d30_", i, "66.pdf")
  curl_download(url, paste0("thai surdata/2023_", i, "_malaria.pdf"))
}

link <- "http://doe.moph.go.th/surdata/506wk/y66/d66_5366.pdf"
curl_download(link, "~/thai surdata/2023_53_df.pdf")

"https://www.moh.gov.my/index.php/database_stores/attach_download/337/2509"