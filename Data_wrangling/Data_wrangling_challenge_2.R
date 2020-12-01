
# challenge 2 ----

# import libraries ----
library(vroom)
library(data.table)
library(tidyverse)
library(lubridate)


# import data ----


import_assignee <- function(){
  
  col_types <- list(
    id = col_character(),
    type = col_double(),
    name_first = col_character(),
    name_last = col_character(),
    organization = col_character()
  )
  
  assignee_tbl <- vroom(
    file       = "Data_wrangling/assignee.tsv", 
    delim      = "\t", 
    col_types  = col_types,
    na         = c("", "NA", "NULL")
  )
  class(assignee_tbl)
  setDT(assignee_tbl)
  
}

import_patent <- function(){
  
  col_types <- list(
    id = col_skip(),
    type = col_skip(),
    number = col_character(),
    country = col_skip(),
    date = col_date("%Y-%m-%d"),
    abstract = col_skip(),
    title = col_skip(),
    kind = col_skip(),
    num_claims = col_skip(),
    filename = col_skip(),
    withdrawn = col_skip()
  )
  
  patent_tbl <- vroom(
    file       = "Data_wrangling/patent.tsv", 
    delim      = "\t", 
    col_types  = col_types,
    na         = c("", "NA", "NULL")
  )
  class(patent_tbl)
  setDT(patent_tbl)
}


import_patent_assignee <- function(){
  
  col_types <- list(
    patent_id = col_character(),
    assignee_id = col_character(),
    location_id = col_character()
  )
  
  patent_assignee_tbl <- vroom(
    file       = "Data_wrangling/patent_assignee.tsv", 
    delim      = "\t", 
    col_types  = col_types,
    na         = c("", "NA", "NULL")
  )
  class(patent_assignee_tbl)
  setDT(patent_assignee_tbl)
}


import_uspc <- function(){
  
  col_types <- list(
    uuid = col_character(),
    patent_id = col_character(),
    mainclass_id = col_character(),
    subclass_id = col_character(),
    sequence = col_double()
  )
  
  uspc_tbl <- vroom(
    file       = "Data_wrangling/uspc.tsv", 
    delim      = "\t", 
    col_types  = col_types,
    na         = c("", "NA", "NULL")
  )
  class(uspc_tbl)
  setDT(uspc_tbl)
}

# import tables

assignee_2_tbl <- import_assignee()
patent_assignee_2_tbl <- import_patent_assignee()
patent_2_tbl <- import_patent()


# rename id to assignee_id
setnames(assignee_2_tbl,"id","assignee_id")

# rename number to patent_id
setnames(patent_2_tbl,"number","patent_id")

# join tables by id
combined_data_2_0 <- merge(x = patent_assignee_2_tbl, y = assignee_2_tbl, 
                           by    = "assignee_id", 
                           all.x = TRUE, 
                           all.y = FALSE)
combined_data_2_1 <- merge(x = combined_data_2_0, y = patent_2_tbl, 
                           by = "patent_id",
                           all.x = TRUE, 
                           all.y = FALSE)


# make correct type of year

temp <- combined_data_2_1 %>% mutate_at(vars(date), funs(year, month, day)) 

# manipulate year column

US_comp_2019_raw_tbl <- temp[year == "2019"]

# filter NA

US_comp_2019_tbl <- US_comp_2019_raw_tbl[organization != "NA"]

# reorder after appearance ----

ranking_tbl <- US_comp_2019_tbl[,.(count = .N), by = organization][
  order(count, decreasing = TRUE)]

head(ranking_tbl, 10)



