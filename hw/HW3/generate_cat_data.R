library(dplyr)

p_very_low <- c(rep("success", 30), rep("failure", 970))
p_low <- c(rep("success", 200), rep("failure", 800))
p_med <- c(rep("success", 500), rep("failure", 500))
p_high <- c(rep("success", 900), rep("failure", 100))

d <- data.frame(p_very_low, p_low, p_med, p_high)

set.seed(4720)
d <- d %>%
  sample_n(nrow(d))

write.csv(d, file = "../../data/cat_pops.csv", row.names = FALSE)