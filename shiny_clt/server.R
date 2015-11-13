library(ggplot2)
library(dplyr)

# Load data ---------------------------------------------------------
pops <- read.csv("data/pops.csv")

# Begin server definition -------------------------------------------

shinyServer(
  function(input, output, session){
    
    # Assign selected population distribution -----------------------
    
    # make reactive to be usable in later objects
    pop_dist <- reactive(unlist(select(pops, matches(input$pop))))
    

    # Plot population distribution ----------------------------------
    output$popPlot <- renderPlot({
      
      pop_name = switch(input$pop,
                        normal = "Normal population",
                        some_rs  = "Somewhat right skewed population",
                        very_ls = "Very left skewed population",
                        wonky = "Wonky population") 
      
      ggplot(data = pops, aes_string(x = input$pop)) +
        geom_histogram() +
        ggtitle(pop_name)
      
    })

    
    # Print population distribution summary statistics --------------
    output$popSummary <- renderText({
      
      # print summary statistics
      mu <- round(mean(pop_dist()), 3)
      sigma <- round(sd(pop_dist()), 3)
      
      HTML(paste0("Population distribution: mean = ", mu, 
           ", standard deviation = ", sigma))
      
    })
    
    # Simulate sampling distribution --------------------------------

    # create data frame for sample means to be stored
    x_bars <- reactive({
      x_bars <- rep(NA, input$n_sim)
      
      # simulate sample means
      for(i in 1:input$n_sim){
        samp <- sample(pop_dist(), size = input$n, replace = TRUE)
        x_bars[i] <- mean(samp)
      }
      
      # return x_bars
      return(x_bars)
    })
    
    # Plot sampling distribution ------------------------------------
    output$samplingPlot <- renderPlot({
      
      # put x_bars in a data frame for ggplot
      sampling_dist <- data.frame(x_bars = x_bars())
      
      # plot sampling distribution
      ggplot(data = sampling_dist, aes(x = x_bars)) +
        geom_histogram()
      
    })    
    
    # Print sampling distribution summary statistics ----------------
    output$samplingSummary <- renderUI({
      
      # print summary statistics
      sampling_mean <- round(mean(x_bars()), 3)
      sampling_se <- round(sd(x_bars()), 3)

      HTML(paste0("Sampling distribution of sample means from samples 
           of size ", input$n,  ": <br/>", "mean = ", sampling_mean, 
           ", standard error = ", sampling_se))
      
    })
  }
)