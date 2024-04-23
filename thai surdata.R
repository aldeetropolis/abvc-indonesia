library(curl)

# 2024
df_link <- "http://doe.moph.go.th/surdata/506wk/y67/d66_1467.pdf"
curl_download(df_link, "thai surdata/df_14_2024.pdf")

dhf_link <- "http://doe.moph.go.th/surdata/506wk/y67/d26_1467.pdf"
curl_download(dhf_link, "thai surdata/dhf_14_2024.pdf")

dss_link <- "http://doe.moph.go.th/surdata/506wk/y67/d27_1467.pdf"
curl_download(dss_link, "thai surdata/dss_14_2024.pdf")

malaria_link <- "http://doe.moph.go.th/surdata/506wk/y67/d30_1467.pdf"
curl_download(malaria_link, "thai surdata/malaria_14_2024.pdf")

diph_link <- "http://doe.moph.go.th/surdata/506wk/y67/d23_1467.pdf"
curl_download(diph_link, "thai surdata/diphtheria_14_2024.pdf")

measles_link <- "http://doe.moph.go.th/surdata/506wk/y67/d21_1467.pdf"
curl_download(measles_link, "thai surdata/measles_14_2024.pdf")

rabies_link <- "http://doe.moph.go.th/surdata/506wk/y67/d42_1467.pdf"
curl_download(rabies_link, "thai surdata/rabies_14_2024.pdf")

# 2023
df_link <- "http://doe.moph.go.th/surdata/506wk/y66/d66_1366.pdf"
curl_download(df_link, "thai surdata/df_2023.pdf")

link <- "https://www.moh.gov.my/index.php/database_stores/attach_download/337/2517"
curl_download(link, "malaysia.pdf")

"https://www.moh.gov.my/index.php/database_stores/attach_download/337/2509"