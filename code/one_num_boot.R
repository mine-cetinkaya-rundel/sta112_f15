one_num_boot <- function(data, statistic = NULL, nsim = 15000, conf_level = 0.95,
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
  
  # missing statistic
  if(is.null(statistic)) { stop("Missing statistic.")}

  
  ## setup --------------------------------------##

  # remove NAs
  data <- data[!is.na(data)]

  # sample size
  n <- length(data)

  # seed, if set
  if(!is.null(seed)) { set.seed(seed) }
  
  # function for calculating the desired point estimate
  calc_stat <- function(x, statistic){ statistic(x) }
  stat <- calc_stat(data, statistic)

  
  ## simulation ---------------------------------##
  
  # simulate the bootstrap distribution
  boot_dist <- data.frame(stat = rep(NA, nsim))
  for(i in 1:nsim){
    boot_sample <- sample(data, size = n, replace = TRUE)
    boot_dist$stat[i] <- calc_stat(boot_sample, statistic)
  }
  
  # calculate critical value
  crit <- qt(conf_level + (1 - conf_level)/2, df = n - 1)

  # calculate the interval
  boot_se <- sd(boot_dist$stat)
  ci <- stat + c(-1,1) * crit * boot_se 
  
  
  ## print summary ------------------------------##
  
  if(print_summ == TRUE){
    cat(paste0("Summary stats: n = ", n, ", sample ", paste(substitute(statistic)) , " = ", round(stat, digits), "\n")) 
  }
  
  
  ## print output -------------------------------##
  
  if(print_output == TRUE){
    ci_pretty <- round(ci, digits)
    conf_level_perc <- as.character(conf_level * 100)
    cat(paste0(conf_level_perc, "% CI: (", ci_pretty[1], ", ", ci_pretty[2], ")"))
  }
  
  
  ## print plot ---------------------------------##

    if(print_plot == TRUE){
    boot_plot <- ggplot(data = boot_dist, aes(x = stat), environment = environment()) +
      geom_histogram() +
      xlab(paste0("bootstrap ", paste(substitute(statistic)), "s")) +
      geom_vline(aes(xintercept = ci), lty = 2)
    suppressWarnings( suppressMessages( print( boot_plot ) ) )
  }
  
  
  ## return ------------------------------------##
  
  if(return_invis == TRUE){
    return(invisible(list(n = n, statistic = stat, SE_boot = boot_se, 
                          conf_level = conf_level, ci = ci)))  
  } else{
    cat("\n")
    return(list(n = n, statistic = stat, SE_boot = boot_se, 
                          conf_level = conf_level, ci = ci))
  }
  
}