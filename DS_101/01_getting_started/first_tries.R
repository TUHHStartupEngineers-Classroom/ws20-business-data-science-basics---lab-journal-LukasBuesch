roll_dice <- function(faces = 1:6, number_of_dice = 2) {
  dice <- sample(x = faces, size = number_of_dice, replace = TRUE)
  sum(dice)
}
roll_dice()

roll3 <- function(faces = 1:6, number_of_dice = 1) {
  dice <- sample(x = faces, size = number_of_dice, 
                 replace = TRUE, 
                 prob = c(0.1, 0.1, 0.1, 0.1, 0.1, 0.5))
  sum(dice)
}

results <- replicate(n = 100, expr = roll3(), simplify=TRUE)
hist(results)



calc_EOQ <- function(D = 1000) {
  K <- 5
  h <- 0.25
  Q <- sqrt(2*D*K/h)
  Q
}