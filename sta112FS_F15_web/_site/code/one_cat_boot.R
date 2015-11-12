one_cat_boot <- function(data, success = NULL, nsim = 15000, conf_level = 0.95,
                         seed = NULL, digits = 4,
                         print_summ = TRUE, print_plot = TRUE, print_output = TRUE,
                         return_invis = TRUE){

  
  ## check for errors ---------------------------##

  # check if ggplot2 is installed
  installed_packages = names(installed.packages()[,"Package"])
  if (!("ggplot2" %in% installed_packages)){
    stop("Install the ggplot2 package.")
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

  # set sample size
  n <- length(data)

  # set seed, if provided
  if(!is.null(seed)) { set.seed(seed) }

  # calculate observed number of successes
  n_suc <- sum(data == success)

  # set function for calculating proportion of successes
  calc_phat <- function(x){ sum(x == success) / n }
  stat <- calc_phat(data)


  ## simulation ---------------------------------##

  # simulate the bootstrap distribution
  boot_dist <- data.frame(stat = rep(NA, nsim))
  for(i in 1:nsim){
    boot_sample <- sample(data, size = n, replace = TRUE)
    boot_dist$stat[i] <- calc_phat(boot_sample)
  }
  
  # calculate critical value
  crit <- qnorm(conf_level + (1 - conf_level)/2)

  # calculate the interval
  boot_se <- sd(boot_dist$stat)
  ci <- stat + c(-1,1) * crit * boot_se 


  ## print summary ------------------------------##
  
  if(print_summ == TRUE){
    cat(paste0("Summary stats: n = ", n, ", number of successes (", success,") = ", n_suc, ", p-hat = ", round(stat, digits), "\n")) 
  }
  
  
  ## print output ------------------------------##
  
  if(print_output == TRUE){
    ci_pretty <- round(ci, digits)
    conf_level_perc <- as.character(conf_level * 100)
    cat(paste0(conf_level_perc, "% CI: (", ci_pretty[1], ", ", ci_pretty[2], ")"))
  }
  

  ## print plot ---------------------------------##
  
  if(print_plot == TRUE){
    boot_plot <- ggplot(data = boot_dist, aes(x = stat), environment = environment()) +
      geom_histogram() +
      xlab("bootstrap proportions") +
      geom_vline(aes(xintercept = ci), lty = 2)
    suppressWarnings( suppressMessages( print( boot_plot ) ) )
  }
  

  ## return -------------------------------------##
  
  if(return_invis == TRUE){
    return(invisible(list(n = n, statistic = stat, SE_boot = boot_se, 
                          conf_level = conf_level, ci = ci)))  
  } else{
    cat("\n")
    return(list(n = n, statistic = stat, SE_boot = boot_se, 
                conf_level = conf_level, ci = ci))
  }
  
}