# Chapter 05 - Challenge 1 ----

# import libraries ----

library(tidyverse)
library(lubridate)

# import data ----

covid_data_tbl <- read_csv("https://opendata.ecdc.europa.eu/covid19/casedistribution/csv")



covid_data_tbl <- covid_data_tbl%>% 
  mutate(across(countriesAndTerritories, str_replace_all, "_", " "))


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
  
  scale_x_date(breaks = "1 month", minor_breaks = "1 month", date_labels = "%B") +
  scale_y_continuous(labels = scales::dollar_format(prefix = "", suffix = "M")) +
  
  
  # geom_label(aes(,
  #   y = max(cumulative_cases),
  #   label = cumulative_cases,
  #   fill = factor(countriesAndTerritories),
  #   #colour = "black",
  #   #fontface = "bold",
  #   vjust = "inward",
  #   hjust = "inward",
  #   data = cumulative_cases_tbl$cumulative_cases[1])) +
  
  

  
  
  theme_light() +
  
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
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




















    