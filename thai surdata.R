library(curl)

# 2024
df_link <- "http://doe.moph.go.th/surdata/506wk/y67/d66_1567.pdf"
curl_download(df_link, "thai surdata/2024_15_df.pdf")

dhf_link <- "http://doe.moph.go.th/surdata/506wk/y67/d26_1567.pdf"
curl_download(dhf_link, "thai surdata/2024_15_dhf.pdf")

dss_link <- "http://doe.moph.go.th/surdata/506wk/y67/d27_1567.pdf"
curl_download(dss_link, "thai surdata/2024_15_dss.pdf")

malaria_link <- "http://doe.moph.go.th/surdata/506wk/y67/d30_1567.pdf"
curl_download(malaria_link, "thai surdata/2024_15_malaria.pdf")

diph_link <- "http://doe.moph.go.th/surdata/506wk/y67/d23_1567.pdf"
curl_download(diph_link, "thai surdata/2024_15_diphtheria.pdf")

measles_link <- "http://doe.moph.go.th/surdata/506wk/y67/d21_1567.pdf"
curl_download(measles_link, "thai surdata/2024_15_measles.pdf")

rabies_link <- "http://doe.moph.go.th/surdata/506wk/y67/d42_1567.pdf"
curl_download(rabies_link, "thai surdata/2024_15_rabies.pdf")

# 2023
df_link <- "http://doe.moph.go.th/surdata/506wk/y66/d66_1366.pdf"
curl_download(df_link, "thai surdata/df_2023.pdf")

link <- "https://www.moh.gov.my/index.php/database_stores/attach_download/337/2517"
curl_download(link, "malaysia.pdf")

"https://www.moh.gov.my/index.php/database_stores/attach_download/337/2509"