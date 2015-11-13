# Load data ---------------------------------------------------------
pops <- read.csv("data/pops.csv")


# Begin ui definition -----------------------------------------------
fluidPage(
  
  # App title -------------------------------------------------------
  titlePanel("Simulating the Central Limit Theorem"),
  
  # Sidebar ---------------------------------------------------------
  sidebarLayout(
    sidebarPanel(
      
      # Select population distribution
      selectInput("pop",
                  "Population distribution:",
                  choices = names(pops)
                  ),
      
      # Horizontal line separating population and sample input
      hr(),
      
      # Input sample size
      numericInput("n",
                   "Sample size:",
                   min = 1,
                   value = 10),
      
      # Slide to number of samples
      sliderInput("n_sim",
                  "Number of samples:",
                  min = 1000,
                  max = 20000,
                  step = 1000,
                  value = 5000)
    ),
    
    # Main panel ----------------------------------------------------
    mainPanel(
      
      # Print population distribution summary statistics
      h5(htmlOutput("popSummary"), align = "center"),
      
      # Plot population distribution
      plotOutput("popPlot"),
      
      # Horizontal line divider
      hr(),
      
      # Print sampling distribution summary statistics
      h5(htmlOutput("samplingSummary"), align = "center"),
      
      # Plot sampling distribution
      plotOutput("samplingPlot")
      
    )
  ) 
)