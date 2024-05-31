library(shiny)
library(shinybusy)
library(shiny.pwa)

options(shiny.maxRequestSize = 50 * 1024^2)


# Define UI for application that draws a histogram
ui <- fluidPage(
  # Your app content
  pwa(
      domain = "https://shiny.nick-amato.com/GeminiTesting",
      title = "DupeScoop",
      icon = "www/DUPE SCOOP.png",
      output = 'www',
  ),
  
  fileInput(inputId = "imageInput", label = "Drop image here"),
  textInput(inputId = "prompt", label = "Description here/question"),
  actionButton(inputId = "submit", "talk to Gemini"),
  textOutput(outputId = "answer"),
  imageOutput(outputId = "imgOut")
)

server <- function(input, output) {
  
  shinybusy::add_busy_spinner(spin = "semipolar", color = "black", position = "bottom-right")
  source("GeminiFuncs.R")
  
  
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

shinyApp(ui = ui, server = server)
