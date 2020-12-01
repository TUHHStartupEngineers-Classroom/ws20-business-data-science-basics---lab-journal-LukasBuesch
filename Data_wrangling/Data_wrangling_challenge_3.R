
# challenge 3 ----

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
    #uuid = col_character(),
    uuid = col_skip(),
    patent_id = col_character(),
    mainclass_id = col_character(),
    #subclass_id = col_character(),
    subclass_id = col_skip(),
    #sequence = col_double()
    sequence = col_skip()
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

assignee_3_tbl <- import_assignee()
patent_assignee_3_tbl <- import_patent_assignee()
uspc_3_tbl <- import_uspc()


# rename id to assignee_id
setnames(assignee_3_tbl,"id","assignee_id")

# join tables by id
combined_data_3_1 <- merge(x = patent_assignee_3_tbl, y = assignee_3_tbl, 
                         by    = "assignee_id", 
                         all.x = TRUE, 
                         all.y = FALSE)

# join tables by patent_id
combined_data_3_2 <- merge(x = combined_data_3_1, y = uspc_3_tbl, 
                         by    = "patent_id", 
                         all.x = TRUE, 
                         all.y = FALSE)



# reorder after appearance ----

ranking_raw_tbl <- combined_data_3_2[,.(count = .N), by = organization][
  order(count, decreasing = TRUE)]

# filter NA

ranking_tbl <- ranking_raw_tbl[organization != "NA"]

head(ranking_tbl, 10)



# get patents of first 10 companies ----

# reduce data (only first 10 companies)
 
patents_first_10_tbl <- combined_data_3_2[organization %in% c(ranking_tbl[1,organization] 
                                                          , ranking_tbl[2,organization] 
                                                          , ranking_tbl[3,organization] 
                                                          , ranking_tbl[4,organization]
                                                          , ranking_tbl[5,organization]
                                                          , ranking_tbl[6,organization]
                                                          , ranking_tbl[7,organization]
                                                          , ranking_tbl[8,organization]
                                                          , ranking_tbl[9,organization]
                                                          , ranking_tbl[10,organization])]



# reorder after appearance (USPTO mainclasses) ----

ranking_raw_tbl <- patents_first_10_tbl[,.(count = .N), by = mainclass_id][
  order(count, decreasing = TRUE)]

# filter NA

ranking_tbl <- ranking_raw_tbl[mainclass_id != "NA"]

head(ranking_tbl, 5)


