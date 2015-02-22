
shinyUI(fluidPage(
  titlePanel("Factors Impacting Gas Efficiency"),

  br(),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Analyze and quantify the factors 
                that impact auto gas mileage."),
      
      br(),
      
      checkboxGroupInput("chk_variables",
                         label = h4("Choose factors for analysis"),
                         choices = list("Weight (lb/1000)" = "wt",
                                        "Transmission (automatic or manual)" = "am",
                                        "Number of cylinders" = "cyl",
                                        "Gross horsepower" = "hp",
                                        "Displacement (cu. in.)" = "disp",
                                        "Number of forward gears" = "gear",
                                        "Number of carburetors" = "carb",
                                        "1/4 mile time (sec.)" = "qsec",
                                        "Rear axle ratio" = "drat"
                                        ),
                         selected = NULL),
      
      actionButton("bfit", label="Explore / Fit a Model"),
      
      br(),
      br(),
      
      checkboxInput("fitbest", label="Fit a best model", FALSE)
    ),
    
    mainPanel(
      tabsetPanel(type="tab",
                  tabPanel("Introduction", helpText(""), helpText("This is a Shiny application that helps
                            explore linear relationships between variables in the mtcars dataset.
                            It fits multiple linear regression models between gas miles per gallon and user-selected
                            variables or provides a best-fitted model if instructed so. Along with the fitted model, 
                            this application also displays model summary as well as diagnostic plots to the user.")),
                  tabPanel("Exploration", plotOutput("explore")),
                  tabPanel("Regression Model", verbatimTextOutput("modelSum")),
                  tabPanel("Diagnostic Plots", plotOutput("modelFig")) 
      )
    )
  )
))