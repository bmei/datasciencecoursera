library(shiny)
library(DT)

data(mtcars)
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$am <- as.factor(mtcars$am)
mtcars$gear <- as.factor(mtcars$gear)
mtcars$carb <- as.factor(mtcars$carb)
mtcars$vs <- as.factor(mtcars$vs)

shinyServer(
  function(input, output) {
    
    # explore
    explore <- reactive({
      
      if (input$fitbest) {
        modnames <- names(model()$coefficients)
        varnames <- c()
        for (i in 1:length(modnames)) {
          tmpname <- substr(modnames[i], 1, nchar(modnames[i])-1)
          if (tmpname %in% names(mtcars)) varnames <- c(varnames, tmpname)
          else varnames <- c(varnames, modnames[i])
        }
        
        cardata <- mtcars[, which(names(mtcars) %in% c("mpg", varnames))]
      }
      else {
        cardata <- mtcars[, which(names(mtcars) %in% c("mpg", input$chk_variables))]
      }
      
      pairs(cardata, panel = function(x, y) {
                               points(x, y)
                               abline(lm(y ~ x), col = "red")
                             }
      )
    })
    
    # fit the model
    model <- reactive({
      
      if (input$fitbest) {
        init_model <- lm(mpg ~ ., data = mtcars)
        modelFit <- step(init_model, direction="both", trace=0)
        return(modelFit)
      }
      else {
        if (length(input$chk_variables)) {
          formula <- as.formula(paste("mpg ~", paste(input$chk_variables, collapse = "+")))
          modelFit <- lm(formula, data = mtcars)
          return(modelFit)
        }
      }
    })

    # data
    output$data <- renderDataTable({
      datatable(mtcars)
    })
    
    # exploratory analysis
    output$explore <- renderPlot({
      input$bfit
      
      isolate(
        if (length(input$chk_variables) | input$fitbest) {
          explore()
        }
      )
    })      
    
    # model summary
    output$modelSum <- renderPrint({
      input$bfit
      
      isolate(
        if (length(input$chk_variables) | input$fitbest) {
          summary(model())
        }
      )
    })  
    
    # diagnostic figures
    output$modelFig <- renderPlot({
      input$bfit
      
      isolate(
        if (length(input$chk_variables) | input$fitbest) {
          par(mfrow = c(2,2))
          plot(model())
        }
      )
    })
  }
)
