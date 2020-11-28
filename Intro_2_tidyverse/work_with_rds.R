library("tidyverse")



# diamonds2 %>% pivot_longer() &>& diamonds

diamonds2 %>% 
  pivot_longer(cols      = c("2008", "2009"), 
               names_to  = 'year', 
               values_to = 'price') %>% 
  head(n = 5)

model <- lm(price ~ ., data = diamonds2_long)
model