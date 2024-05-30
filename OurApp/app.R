

library(shiny)
library(shinybusy)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  fileInput(inputId = "imageInput", label = "Drop image here"),
  textInput(inputId = "prompt", label = "Description here/question"),
  actionButton(inputId = "submit", "talk to Gemini"),
  textOutput(outputId = "answer"),
  imageOutput(outputId = "imgOut")
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  shinybusy::add_busy_spinner(spin = "semipolar", color = "black", position = "bottom-right")
  source("../GeminiFuncs.R")
  
  
  observeEvent(input$imageInput, {
    path = input$imageInput$datapath
    
    output$imgOut = renderImage({
      list(
        src = path
      )
    }, deleteFile = FALSE)
  })
  
  observeEvent(input$submit,{
    
    SavedAnswer = gemini_vision(input$prompt, input$imageInput$datapath)
    
    print(input$prompt)
    print(SavedAnswer)
    
    output$answer = renderText(SavedAnswer)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
