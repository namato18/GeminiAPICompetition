

library(shiny)
library(shinybusy)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  fileInput(inputId = "imageinput", label = "Drop image here"),
  textInput(inputId = "Prompt", label = "Description here/question"),
  actionButton(inputId = "submit", "talk to Gemini"),
  textOutput(outputId = "Answer")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  shinybusy::add_busy_spinner(spin = "semipolar", color = "black", position = "bottom-right")
  source("../GeminiFuncs.R")
  
  
  observeEvent(input$submit,{
    
    SavedAnswer = gemini(input$Prompt)
    
    print(input$Prompt)
    print(SavedAnswer)
    
    output$Answer = renderText(SavedAnswer)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
