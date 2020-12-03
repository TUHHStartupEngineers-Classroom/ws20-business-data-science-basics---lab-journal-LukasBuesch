# Chapter 05 - Challenge 2 ----

# import libraries ----

library(tidyverse)
library(ggplot2)
library(maps)

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


# data manipulation ----

mortality_tbl <- covid_data_tbl %>%
  
  # Select relevant columns
  select(countriesAndTerritories, deaths, popData2019, cases) %>%
  
  # grouping
  
  group_by(countriesAndTerritories) %>%
  summarize(population_2019 = mean(popData2019), deaths_sum = sum(deaths)) %>%
  mutate(mortality = deaths_sum / population_2019)
  mutate(date = dateRep)
  ungroup()


  
  # plotting ---

world <- map_data("world")

mortality_tbl %>%
  
  ggplot(aes(mortality, countriesAndTerritories)) +
  
  geom_map(aes(map_id = world ), map = world )
  


  geom_tile(aes(fill = pct)) +
  geom_text(aes(label = scales::percent(pct, accuracy = 1L)), 
            size = 3) +
  facet_wrap(~ category_1, scales = "free_x") +
  
  # Formatting
  scale_fill_gradient(low = "white", high = "#2C3E50") +
  labs(
    title = "Heatmap of Purchasing Habits",
    x = "Bike Type (Category 2)",
    y = "Customer",
    caption = str_glue(
      "Customers that prefer Road: 
        To be discussed ...
        
        Customers that prefer Mountain: 
        To be discussed ...")
    ) +
  
   theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "none",
    plot.title = element_text(face = "bold"),
    plot.caption = element_text(face = "bold.italic")
   )
  
  # Formatting
  scale_fill_gradient(low = "white", high = "#2C3E50") +
    labs(
      title = "Heatmap of Purchasing Habits",
      x = "Bike Type (Category 2)",
      y = "Customer",
      caption = str_glue(
        "Customers that prefer Road: 
        To be discussed ...
        
        Customers that prefer Mountain: 
        To be discussed ...")
    ) +
    
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "none",
      plot.title = element_text(face = "bold"),
      plot.caption = element_text(face = "bold.italic")
    )




