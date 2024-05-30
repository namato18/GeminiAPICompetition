library(shiny)

Sys.setenv(GEMINI_API_KEY = "xxxxxxxxxxx")

ui <- fluidPage(
  mainPanel(
    fluidRow(
      fileInput(
        inputId = "imgFile",
        label = "Select image to upload",
      ),
      textInput(
        inputId = "prompt", 
        label = "Prompt", 
        placeholder = "Enter Your Query"
      ),
      actionButton("submit", "Talk to Gemini"),
      textOutput("response")
    ),
    imageOutput(outputId = "myimage")
  )
)

server <- function(input, output) {
  
  observeEvent(input$imgFile, {
    path <- input$imgFile$datapath
    output$myimage <- renderImage({
      list(
        src = path
      )
    }, deleteFile = FALSE)
  })
  
  observeEvent(input$submit, {
    output$response <- renderText({
      gemini_vision(input$prompt, input$imgFile$datapath)
    })
  })
}

shinyApp(ui = ui, server = server)
