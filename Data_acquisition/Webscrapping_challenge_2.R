# WEBSCRAPING ----

# 1.0 LIBRARIES ----

library(tidyverse) # Main Package - Loads dplyr, purrr, etc.
library(rvest)     # HTML Hacking & Web Scraping
library(jsonlite)  # converts JSON files to R objects
library(glue)      # concatenate strings
library(stringi)   # character string/text processing
library(purrr)


# 1.1 COLLECT PRODUCT FAMILIES ----

url_home          <- "https://www.rosebikes.de/"

# Read in the HTML for the entire webpage
html_home         <- read_html(url_home)

# Web scrape the ids for the families
bike_family_tbl <- html_home %>%
  
  # Get the nodes for the families ...
  html_nodes(css = ".main-navigation-category-with-tiles__link") %>%
  # ...and extract the information of the id attribute
  html_attr("href") %>%
  
  # Remove the product families Gear and Outlet and Woman 
  # (because the female bikes are also listed with the others)
  discard(.p = ~stringr::str_detect(.x,"sale")) %>%
  
  # Convert vector to tibble
  enframe(name = "position", value = "family_class") %>%
  
  # Add a hashtag so we can get nodes of the categories by id (#)
  mutate(
    family_id = str_glue("#{family_class}")
  )

bike_family_tbl


# 1.2 COLLECT PRODUCT CATEGORIES ----

# Combine all Ids to one string to get all nodes at once
# (seperated by the OR operator ",")

family_id_css <- bike_family_tbl %>%
  
  pull(family_class) %>%
  
  stringr::str_c(collapse = ", ")


family_id_css



# 2.1 Get URL for each bike of the Product categories

# Create vector with all URLS for product classes

bike_category_url_tbl <- bike_family_tbl %>%
  
  # Convert vector to tibble
  select("position", "family_class") %>%
  
  # Add the domain, because we will get only the family_class
  mutate(
    url = glue("https://www.rosebikes.de{family_class}")
  ) %>%
  
  # delete multiple entries
  distinct(url)




# 2.1 Get URL for each bike of the Product categories

# select first bike category url
bike_category_url <- bike_category_url_tbl$url[1]

# Get the URLs for the bikes of the first category
html_bike_category  <- read_html(bike_category_url)
bike_sub_category_url_tbl        <- html_bike_category %>%
  
  # Get the 'a' nodes, which are hierarchally underneath 
  # the class productTile__contentWrapper
  html_nodes(css = ".catalog-category-bikes__picture-wrapper--left") %>%
  html_attr("href") %>%
  
  # Convert vector to tibble
  enframe(name = "position", value = "url") %>%

  # Add the domain, because we will get only the subdirectories

   mutate(url = glue("https://www.rosebikes.de{url}")) %>%
     
  # delete multiple entries
     
  distinct(url)


# search one Layer deeper

bike_sub_category_url <- bike_sub_category_url_tbl$url[1]

# Get the URLs for the bikes of the first subcategory

html_bike_sub_category  <- read_html(bike_sub_category_url)

bike_url_tbl        <- html_bike_sub_category %>%
  
  # Get the 'a' nodes, which are hierarchally underneath 
  # the class productTile__contentWrapper
  
  html_nodes(css = ".catalog-category-model__link") %>%
  html_attr("href") %>%
  
  # Convert vector to tibble
  
  enframe(name = "position", value = "url")



  # Add the full URL
  
bike_url_tbl$url <- paste("https://www.rosebikes.de", trimws(bike_url_tbl$url), sep = "")



  
  
# 2.1.2 Extract the descriptions (since we have retrieved the data already)
bike_url <- bike_url_tbl$url[1]
html_bike <- read_html(bike_url)

bike_desc_tbl <- html_bike %>%
  
  # Get the nodes in the meta tag where the attribute itemprop equals description
  html_nodes(".buybox__prize__wrapper > span") %>%
  
  # Extract the content of the attribute content
  html_attr("data-test") %>%
  
  # Convert vector to tibble
  enframe(name = "position", value = "price")





get_bike_data <- function(bike_url) {
  
  # Get the descriptions
  html_bike <- read_html(bike_url)
  bike_desc_tbl <- html_bike %>%
    html_nodes(".buybox__prize__wrapper > span") %>%
    html_attr("data-test") %>%
    enframe(name = "position", value = "price")
  
}





# Run the function with the first url to check if it is working
bike_url <- bike_url_tbl$url[1]
bike_data_tbl <- get_bike_data(bike_url)

bike_data_tbl



# 2.3.1a Map the function against all urls

# Extract the urls as a character vector
bike_url_vec <- bike_url_tbl %>% 
  pull(url)

# Run the function with every url as an argument
bike_data_lst <- map(bike_url_vec, get_bike_data)

# Merge the list into a tibble
bike_data_tbl <- bind_rows(bike_data_lst)


name_with_price = bind_cols(bike_data_tbl,bike_url_tbl$url)

name_with_price




