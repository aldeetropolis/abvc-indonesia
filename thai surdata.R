library(curl)

# 2024
df_link <- "http://doe.moph.go.th/surdata/506wk/y67/d66_1767.pdf"
curl_download(df_link, "thai surdata/2024_17_df.pdf")

dhf_link <- "http://doe.moph.go.th/surdata/506wk/y67/d26_1767.pdf"
curl_download(dhf_link, "thai surdata/2024_17_dhf.pdf")

dss_link <- "http://doe.moph.go.th/surdata/506wk/y67/d27_1767.pdf"
curl_download(dss_link, "thai surdata/2024_17_dss.pdf")

malaria_link <- "http://doe.moph.go.th/surdata/506wk/y67/d30_1767.pdf"
curl_download(malaria_link, "thai surdata/2024_17_malaria.pdf")

diph_link <- "http://doe.moph.go.th/surdata/506wk/y67/d23_1767.pdf"
curl_download(diph_link, "thai surdata/2024_17_diphtheria.pdf")

measles_link <- "http://doe.moph.go.th/surdata/506wk/y67/d21_1767.pdf"
curl_download(measles_link, "thai surdata/2024_17_measles.pdf")

rabies_link <- "http://doe.moph.go.th/surdata/506wk/y67/d42_1767.pdf"
curl_download(rabies_link, "thai surdata/2024_17_rabies.pdf")

# 2023

for (i in 10:53) {
  url <- paste0("http://doe.moph.go.th/surdata/506wk/y66/d30_", i, "66.pdf")
  curl_download(url, paste0("thai surdata/2023_", i, "_malaria.pdf"))
}

link <- "http://doe.moph.go.th/surdata/506wk/y66/d66_5366.pdf"
curl_download(link, "thai surdata/2023_53_df.pdf")

"https://www.moh.gov.my/index.php/database_stores/attach_download/337/2509"