library("tidyverse")
library(ggplot2) # To load the diamonds dataset
library(dplyr)



# Tidying data with pivot_longer()

diamonds2 %>% 
  pivot_longer(cols      = c("2008", "2009"), 
               names_to  = 'year', 
               values_to = 'price') %>% 
  head(n = 5)

model <- lm(price ~ ., data = diamonds2)
model



# Tidying data with pivot_wider()
diamonds3 <- readRDS("Intro_2_tidyverse/diamonds3.rds")


diamonds3 %>% head(n = 5)

diamonds3 %>% 
  pivot_wider(names_from  = "dimension",
              values_from = "measurement") %>% 
  head(n = 5)


# Tidying data with seperate()
diamonds4 <- readRDS("Intro_2_tidyverse/diamonds4.rds")


diamonds4 %>% 
  separate(col = dim,
           into = c("x", "y", "z"),
           sep = "/",
           convert = T)