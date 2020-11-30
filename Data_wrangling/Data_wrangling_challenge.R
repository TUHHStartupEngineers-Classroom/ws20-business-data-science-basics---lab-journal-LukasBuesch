# import libraries ----
library(vroom)
library(data.table)
library(tidyverse)


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
    id = col_character(),
    type = col_character(),
    number = col_character(),
    country = col_character(),
    date = col_date("%Y-%m-%d"),
    abstract = col_character(),
    title = col_character(),
    kind = col_character(),
    num_claims = col_double(),
    filename = col_character(),
    withdrawn = col_character()
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


# challenge 1 ----

# Import tables

assignee_1_tbl <- import_assignee()
patent_assignee_1_tbl <- import_patent_assignee()

# rename id to assignee_id
setnames(assignee_1_tbl,"id","assignee_id")

# join tables by id
combined_data_1 <- merge(x = patent_assignee_1_tbl, y = assignee_1_tbl, 
                       by    = "assignee_id", 
                       all.x = TRUE, 
                       all.y = FALSE)



# in type: integer for country (2 - US Company or Corporation)

US_comp_tbl <- combined_data_1[type == "2"]

# reorder after appearance ----

ranking_tbl <- US_comp_tbl[,.(count = .N), by = organization][
  order(count, decreasing = TRUE)]

head(ranking_tbl, 10)






















