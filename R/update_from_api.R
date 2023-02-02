library(data.table)
wdi_indicators <- c("NY.GDP.PCAP.KD", "NE.CON.PRVT.PC.KD")
wdi   <- wbstats::wb_data(indicator = wdi_indicators,
                          country = "all", # this is new
                          lang      = "en",
                          return_wide = FALSE) |>
  setDT()



# rename vars
wdi <- wdi[, c("iso3c", "date", "indicator_id", "value")]



setnames(wdi,
         new = c("country_code", "year", "indicator_code", "value"))

# Convert to wide
wdi <- dcast(wdi,
      country_code + year ~indicator_code)

wdi[,
    year := as.numeric(year)]


readr::write_csv(wdi, "wdi.csv")
