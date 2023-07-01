library(tidyverse)
library(lubridate)
library(rvest)
library(jsonlite)

html <- read_html("https://minnaair.com/blog/yokohama/")
data <- html %>%
    html_nodes("script") %>%
    .[[13]] %>%
    html_text() %>%
    str_split(., "\n") %>%
    unlist(.) %>%
    .[3:5] %>%
    str_replace_all(., "^\\s+const db_.* = ", "")

places <- fromJSON(data[1]) %>%
    select(-as.character(0:14)) %>%
    rename(school_id = id, school_uuid = uuid, school_name = name)
devices <- fromJSON(data[2]) %>%
    select(-as.character(0:6)) %>%
    rename(device_id = id, device_uuid = uuid, device_name = name, school_id = office_id)
#values <- fromJSON(data[3]) %>%
#    select(-as.character(0:10)) %>%
#    mutate(timestamp_value = as_datetime(as.numeric(timestamp_value), tz = "Asia/Tokyo")) %>%
#    rename(value_id = id, value_uuid = uuid, datetime = timestamp_value)

#df <- values %>%
#    left_join(devices, by = "device_id") %>%
#    left_join(places, by = "school_id") %>%
#    select(datetime, school_id, school_name, district, latitude, longitude, device_id, device_name, co2, humidity, pm10, pm25, temperature, tvoc, air_quality, value_id)

write_excel_csv(places, "yokohama_air_places.csv")
write_excel_csv(devices, "yokohama_air_devices.csv")
#write_excel_csv(df, "yokohama_air_data.csv")
