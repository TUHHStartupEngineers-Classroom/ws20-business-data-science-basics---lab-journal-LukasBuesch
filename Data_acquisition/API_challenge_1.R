# API challenge ----

# 1.0 LIBRARIES ----

library(tidyverse) # Main Package - Loads dplyr, purrr, etc.s
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(httr)


# 2.0 Get data  ----
# Get data from weather API  via function

weather_api <- function(city) {
  # path is city name
  API_key <- Sys.getenv("API_key")
  url <- modify_url(url = glue("https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_key}"))
  resp <- GET(url)
  stop_for_status(resp) # automatically throws an error if a request did not succeed
}


weather_hamburg_raw <- weather_api(city = "Hamburg")

weather_hamburg <- fromJSON(rawToChar(weather_hamburg_raw$content))

weather_hamburg
