library(tidyverse)
library(lubridate)

df <- read_csv("yokohama_air_data.csv")
df$datetime <- ymd_hms(df$datetime, tz = "Asia/Tokyo")

lastmonth_df <- df %>% filter(datetime >= ymd("2023-08-01"), datetime < ymd("2023-09-01"))
write_excel_csv(lastmonth_df, "../yokohama_school_air_data_archive/yokohama_air_data_202308.csv")

thismonth_df <- df %>% filter(datetime >= ymd("2023-09-01"))
write_excel_csv(thismonth_df, "yokohama_air_data.csv")
