one_num_test <- function(data, statistic = NULL, null = NULL, alt = "not equal", 
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
  if(!is.numeric(null)) { 
    stop("Null value should be a numeric value.") 
  }
  if(is.null(null)) { stop("Missing null value.") }

  # errors associated with alternative hypothesis
  if(!(alt %in% c("greater", "less", "not equal"))) {
    stop("Alternative hypothesis not specified properly, should be less, greater, or not equal.")
  }

  # errors associated with data format
  if(is.null(data)) { stop("Missing data.") }
  if(is.data.frame(data)) { stop("Data should be a vector, not a data frame.") }
  
  # missing statistic
  if(is.null(statistic)) { stop("Missing statistic.")}
  
  
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
  
  # function for calculating the desired point estimate
  calc_stat <- function(x, statistic){ statistic(x) }
  stat <- calc_stat(data, statistic)
  
  ## simulate null distribution -----------------##

  # simulate the bootstrap distribution
  boot_dist <- data.frame(stat = rep(NA, nsim))
  for(i in 1:nsim){
    boot_sample <- sample(data, size = n, replace = TRUE)
    boot_dist$stat[i] <- calc_stat(boot_sample, statistic)
  }

  # center the bootstrap distribution at the null value
  boot_dist_temp <- boot_dist$stat
  null_dist <- data.frame(stat = rep(NA, nsim))
  null_dist$stat <- boot_dist_temp - (mean(boot_dist$stat) - null)

  
  ## calculate p-value --------------------------##

  # calculate number of simulated statistics at least as extreme as observed statistics
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
    if(paste(substitute(statistic)) == "mean"){ parameter = "mu"}
    if(paste(substitute(statistic)) == "median"){ parameter = "pop_median"}
    if(!(paste(substitute(statistic)) %in% c("mean", "median"))){ parameter = "pop_parameter"}
    cat(paste0("H0: ", parameter, " = ", null, "\n"))

    # set alternative hypothesis sign
    if(alt == "not equal") { alt_sign = "!=" }
    if(alt == "greater") { alt_sign = ">" }
    if(alt == "less") { alt_sign = "<" }
  
    # print alternative hypothesis
    cat(paste0("HA: ", parameter, " ", alt_sign, " ", null, "\n"))
    
    # print summary statistics
    cat(paste0("Summary stats: n = ", n, ", sample ", paste(substitute(statistic)) , " = ", round(stat, digits), "\n")) 
  
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
        geom_vline(aes(xintercept = obs_stat)) +
        xlab("null distribution")
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