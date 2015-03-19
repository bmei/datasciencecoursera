library(shiny)
library(DT)

shinyUI(fluidPage(
  titlePanel("Factors Impacting Auto Gas Efficiency"),

  br(),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Analyze and quantify the factors that impact auto gas mileage (mpg)."),
      
      br(),
      
      checkboxGroupInput("chk_variables",
                         label = h4("Choose factors for analysis"),
                         choices = list("Weight (lb/1000)" = "wt",
                                        "Transmission (automatic or manual)" = "am",
                                        "Number of cylinders" = "cyl",
                                        "Gross horsepower" = "hp",
                                        "Displacement (cu. in.)" = "disp",
                                        "Number of forward gears" = "gear",
                                        "Engine Type (V or straight)" = "vs",
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
                  tabPanel("Instructions", 
                           div(
                             br(),
                             tags$b("Introduction"),
                             br(),
                             p("This is a Shiny application that uses the mtcars data from the 'datasets' package and 
                                     explores linear relationships among the variables in the dataset."),
                             p("It fits multiple linear regression models between gas miles per gallon (mpg) and
                                     user-selected variables or provides a best-fitted model if instructed so. Along with
                                     the fitted model, this application also displays model summary, diagnostic plots, as
                                     well as the data used to fit the model to the user."),
                             br(),
                             tags$b("Instructions"),
                             br(),
                             tags$li("To fit a model with your own chosen variable(s), simply check the variable(s) of
                                     interest on the left panel (and make sure the 'Fit a best model' box unchecked), 
                                     and then click the 'Explore / Fit a Model' button. "),
                             br(),
                             tags$li("To let the app choose the most significant variables and fit a best model for you,
                                     check the 'Fit a best model' checkbox before clicking the 'Explore / Fit a Model' button."),
                             br(),
                             tags$li("After a model is fitted, you can see the summary of the fitted model on the 'Regress Model'
                                     tab and four diagnostic plots on the Diagnostic Plots tab."),
                             br(),
                             tags$li("Linear relationship between any two of the chosen variables, including mpg, can be seen
                                     on the 'Exploration' tab."),
                             br(),
                             tags$li("The mtcars data on which models are fitted is shown on the 'Data' tab."))),
                  tabPanel("Data", div(dataTableOutput("data"), style="font-size:85%")),
                  tabPanel("Exploration", plotOutput("explore")),
                  tabPanel("Regression Model", verbatimTextOutput("modelSum")),
                  tabPanel("Diagnostic Plots", plotOutput("modelFig")) 
      )
    )
  )
))