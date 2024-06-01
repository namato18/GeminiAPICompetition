#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)


# Define UI for application that draws a histogram
ui <- fluidPage(

  #Application title
  titlePanel("Select an Option"),
  
  #sidebar layout, is this needed for what we want?
  
  selectInput(inputId = "Dropdown", "Select an option", label = "Options", choices = c("Cheaper Product", "Better Quality", "Woman-Owned", "Organic"))
  
  #we can rename the Better Quality/boujee item, just wasn't sure what to
  
)

    
  

# Define server logic required to draw a histogram
server <- function(input, output) {


  
 
  
  

}


# Run the application 
shinyApp(ui = ui, server = server)
