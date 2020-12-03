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
  
  # change date format
  
  mutate(date = dmy(dateRep)) %>%
  
  arrange(date) %>%
  

  # Filter for nations of interest and year
  
  filter(countriesAndTerritories %in% c("Germany","Spain", "France", "United_Kingdom", "United_States_of_America")) %>%
  
  filter(year == "2020") %>%
  
  # grouping
  
  group_by(countriesAndTerritories) %>%
  mutate(cumulative_cases = cumsum(cases)) %>%
  ungroup()





# Plot ----

cumulative_cases_tbl %>%

  # Canvas
  
  ggplot(aes(date, cumulative_cases), color = countriesAndTerritories) +
  
  # Geoms
  
  
  
  geom_line(aes(x     = date,
                y     = cumulative_cases,
                color = countriesAndTerritories)) + 
  
  geom_label(aes(label = countriesAndTerritories,
                 #fill = factor(countriesAndTerritories),
                 #colour = "black",
                 #fontface = "bold",
                 vjust = "inward",
                 hjust = "inward")) +
  
  
  theme_light() +
  
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(face = "bold.italic"),
    plot.background = element_blank(),
    axis.title = element_text(face = "bold")
    ) +
  
  labs(
    title = "COVID-19 confirmed cases worldwide",
    subtitle = "------------",
    x = "Year 2020",
    y = "Cumulative Cases",
    color = "Continent / Country" # Legend text
  )




















    