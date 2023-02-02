library(data.table)
wdifile <- fs::path("raw_data/WDIEXCEL.xlsx")

# convert dots and spaces to _
name_repair <- function(nms) {
  gsub("[.[:space:]]", "_", nms) |>
    tolower()
}

orig  <- readxl::read_xlsx(wdifile, sheet = "Data",
                           .name_repair = name_repair)

setDT(orig)

orig <- orig[indicator_code  %in% c("NY.GDP.PCAP.KD", "NE.CON.PRVT.PC.KD")
][,
  c("indicator_name", "country_name") := NULL]

df   <- melt(orig,
             id.vars         = c("country_code", "indicator_code"),
             variable.name   = "year",
             variable.factor = FALSE,
             value.factor    = FALSE
)

wdi   <- dcast(df,
               country_code + year ~indicator_code)
wdi[,
    year := as.numeric(year)]

readr::write_csv(wdi, "wdi.csv")



