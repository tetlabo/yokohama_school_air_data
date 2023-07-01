library(tidyverse)
library(lubridate)
library(rvest)
library(jsonlite)

options(dplyr.width = Inf)

base_url <- "https://minnaair.com/application/yokohama/detail.php?device="
devices <- readLines("./device_list.txt")

# データフレームの初期化
new_df <- data.frame(value_id = character(), value_uuid = character(), co2 = character(), humidity = character(), pm10 = character(), pm25 = character(), temperature = character(), tvoc = character(), datetime = character(), device_id = character(), air_quality = character())

# 前回のデータを開く
prev_df <- read_csv("./yokohama_air_data.csv", col_types = cols(.default = "c"))

for (i in 1:length(devices)){
#for (i in 1:10){
    print(paste("now processing", i, "of", length(devices), "..."))
    url <- paste0(base_url, devices[i])
    html <- read_html(url)
    data <- html %>%
        html_nodes("script") %>%
        .[[15]] %>%
        html_text() %>%
        str_split(., "\n") %>%
        unlist(.) %>%
        .[[2]] %>%
        str_replace_all(., "^const air_logs = ", "") %>%
        str_replace_all(., ";$", "")

    if (nchar(data) <= 100){
        print(paste("skipping", i, "of", length(devices), "..."))
        next
    }

    values <- fromJSON(data) %>%
        select(-as.character(0:10)) %>%
        mutate(timestamp_value = as.character(as_datetime(as.numeric(timestamp_value), tz = "Asia/Tokyo"))) %>%
        rename(value_id = id, value_uuid = uuid, datetime = timestamp_value) %>%
        arrange(datetime)

    if (nrow(values) == 0){
        print(paste("skipping", i, "of", length(devices), "..."))
        next
    }
        
    # 前回のデータとの差分だけ抽出
    #values %>% slice_head(n = 1) %>% print(.)
    #prev_df %>% filter(device_id == devices[i]) %>% slice_tail(n = 1) %>% print(.)
    prev_df_last_datetime <- prev_df %>% filter(device_id == devices[i]) %>% slice_tail(n = 1) %>% pull(datetime)
    prev_df_last_datetime <- ifelse(length(prev_df_last_datetime) == 0, "0", prev_df_last_datetime)
    prev_df_last_datetime <- ymd_hms(prev_df_last_datetime, tz = "Asia/Tokyo")
    values <- values %>% filter(datetime > prev_df_last_datetime)

    new_df <- new_df %>% bind_rows(values)

#    Sys.sleep(3)
}

new_df <- new_df %>% distinct()

write_excel_csv(new_df, "yokohama_air_data.csv", append = TRUE)
