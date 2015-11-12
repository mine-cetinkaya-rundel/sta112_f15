set.seed(285010)

normal <- rnorm(10000, mean = 30, sd = 5)
hist(normal)

some_rs <- rbeta(10000, 3, 7)
hist(some_rs)

very_ls <- rbeta(10000, 6, 1)
hist(very_ls)

wonky_full <- c(normal, some_rs*20, very_ls*10)
wonky <- sample(wonky_full, size = 10000, replace = FALSE)
hist(wonky)

d <- data.frame(normal, some_rs, very_ls, wonky)

write.csv(d, file = "../data/pops.csv", row.names = FALSE)