one_cat_test <- function(data, success = NULL, null = NULL, alt = "not equal", 
                         nsim = 15000, seed = NULL, digits = 4,
                         print_summ = TRUE, print_plot = TRUE, print_output = TRUE,
                         return_invis = TRUE){

  
  ## check for errors ---------------------------##
 
  # check if ggplot2 is installed
  installed_packages = names(installed.packages()[,"Package"])
  if (!("ggplot2" %in% installed_packages)){
    stop("Install the ggplot2 package.")
  }

  # errors associated with null hypothesis
  if(null < 0 | null > 1 | !is.numeric(null)) { 
    stop("Null value should be a numeric value between 0 and 1.") 
  }
  if(is.null(null)) { stop("Missing null value.") }

  # errors associated with alternative hypothesis
  if(!(alt %in% c("greater", "less", "not equal"))) {
    stop("Alternative hypothesis not specified properly, should be less, greater, or not equal.")
  }

  # errors associated with data format
  if(is.null(data)) { stop("Missing data.") }
  if(is.data.frame(data)) { stop("Data should be a vector, not a data frame.") }
  
  # success is not a level of data
  data <- factor(data)
  if(!is.null(success)){
    if(!(success %in% levels(data))){ stop("'success' is not a level of 'data'.")}
  }
  
  # success not provided
  if(is.null(success)){ success = levels(data)[1] }
  
  
  ## setup --------------------------------------##

  # load ggplot2 quietly
  suppressMessages(library(ggplot2, quietly = TRUE))

  # remove NAs
  data <- data[!is.na(data)]

  # set seed, if provided
  if(!is.null(seed)) { set.seed(seed) }


  ## calculate sample statistics ----------------##
 
  # set sample size
  n <- length(data)
  
  # calculate observed number of successes
  n_suc <- sum(data == success)
  
  # set function for calculating proportion of successes
  calc_phat <- function(x){ sum(x == success) / n }
  stat <- calc_phat(data)
  
  # set outcomes to sample from
  outcomes <- levels(data)
  # error if data has more than 2 levels
  if(length(outcomes) > 2) { stop("Input data has more than two levels.") }
  
  # set probability with which to sample
  if(which(outcomes == success) == 1) { p <- c(null, 1-null) }
  if(which(outcomes == success) == 2) { p <- c(1-null, null) }
  
  
  ## simulate null distribution -----------------##

  null_dist <- data.frame(stat = rep(NA, nsim))
  for(i in 1:nsim){
    sim_sample <- sample(outcomes, size = n, prob = p, replace = TRUE)
    null_dist$stat[i] <- calc_phat(sim_sample)
  }

  
  ## calculate p-value --------------------------##

  # calculate number of simulated p-hats at least as extreme as observed p-hat
  if(alt  == "greater"){ 
    nsim_extreme <- sum(null_dist$stat >= stat)
    obs_stat <- stat
    }
  if(alt  == "less"){ 
    nsim_extreme <- sum(null_dist$stat <= stat) 
    obs_stat <- stat
    }  
  if(alt  == "not equal"){
    obs_stat <- rep(NA, 2) 
    if(stat > null) { 
      nsim_extreme <- 2 * sum(null_dist$stat >= stat) 
      obs_stat[1] <- stat
      obs_stat[2] <- null - (stat-null)
      }
    if(stat < null) { 
      nsim_extreme <- 2 * sum(null_dist$stat <= stat) 
      obs_stat[1] <- null + (null-stat)
      obs_stat[2] <- stat
      }
  }
  
  # calculate p-value
  p_value <- nsim_extreme / nsim
  

  ## print summary ------------------------------##

  if(print_summ == TRUE){
    # print null hypothesis
    cat(paste("H0: p =", null, "\n"))

    # set alternative hypothesis sign
    if(alt == "not equal") { alt_sign = "!=" }
    if(alt == "greater") { alt_sign = ">" }
    if(alt == "less") { alt_sign = "<" }
  
    # print alternative hypothesis
    cat(paste("HA: p", alt_sign, null, "\n")) 
  
    # print summary statistics
    cat(paste0("Summary stats: n = ", n, ", number of successes (", success,") = ", n_suc, ", p-hat = ", round(stat, digits), "\n")) 
  
    # print p-value
    if(round(p_value, digits) == 0) { cat(paste("p-value < 0.0001\n")) }
    if(round(p_value, digits) > 0) { cat(paste("p-value = ", round(p_value, digits), "\n")) }
  }


  ## plot null distribution ---------------------##
  
  if(print_plot == TRUE){
    # dot plot if low number of simulations
    if(nsim <= 100){
      nulldist_plot <- ggplot(data = null_dist, aes(x = stat), environment = environment()) + 
        geom_dotplot() +
        geom_vline(aes(xintercept = obs_stat)) +
        xlab("null distribution")
      suppressWarnings( suppressMessages( print( nulldist_plot ) ) ) 
    }
    # histogram if high number of simulations
    if(nsim > 100){
      bw <- (max(null_dist$stat) - min(null_dist$stat)) / 20
      nulldist_plot <- ggplot(data = null_dist, aes(x = stat), environment = environment()) + 
        geom_histogram(binwidth = bw) +
        xlab("null distribution") +
        geom_vline(aes(xintercept = obs_stat), lty = 2)
      suppressWarnings( suppressMessages( print( nulldist_plot ) ) ) 
    }
  }


  ## return -------------------------------------##
  
  if(return_invis == TRUE){
    return(invisible(list(n = n, statistic = stat, p_value = p_value)))  
  } else{
    cat("\n")
    return(invisible(list(n = n, statistic = stat, p_value = p_value)))  
  }
}