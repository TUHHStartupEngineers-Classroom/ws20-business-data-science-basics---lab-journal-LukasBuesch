# Chapter 05 - Challenge 1 ----

# import libraries ----

library(tidyverse)

# import data ----

covid_data_tbl <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv")



covid_data_tbl %>% 
  mutate(across(countriesAndTerritories, str_replace_all, "_", " ")) %>%
  mutate(countriesAndTerritories = case_when(
    
    countriesAndTerritories == "United Kingdom" ~ "UK",
    countriesAndTerritories == "United States of America" ~ "USA",
    countriesAndTerritories == "Czechia" ~ "Czech Republic",
    TRUE ~ countriesAndTerritories
    
  ))


# Data Manipulation x axis - month, y axis - cumulative cases
cumulative_cases_tbl <- covid_data_tbl %>%
  
  # Select relevant columns
  select(dateRep,month, countriesAndTerritories, `Cumulative_number_for_14_days_of_COVID-19_cases_per_100000`) %>%

  # Filter for nations of interest
  
  filter(countriesAndTerritories %in% c("Germany","Spain", "France", "United_Kingdom", "United_States_of_America")) %>%
  
  # grouping
  
  group_by(countriesAndTerritories) %>%
  #summarize(revenue = sum(total_price)) %>%
  ungroup()


# Plot ----

cumulative_cases_tbl %>%
  
  ggplot(aes(dateRep, `Cumulative_number_for_14_days_of_COVID-19_cases_per_100000`), color = countriesAndTerritories) +
  
  geom_line(size = 0.5, linetype = 1) +
  geom_smooth(method = "loess", span = 0.2)
    