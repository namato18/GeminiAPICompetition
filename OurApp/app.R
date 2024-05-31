library(shiny)
library(shinybusy)
library(shiny.pwa)
library(shinyWidgets)

source("GeminiFuncs.R")
source('icon.R')

options(shiny.maxRequestSize = 50 * 1024^2)


card <- function(title, ...) {
  htmltools::tags$div(
    class = "card",
    htmltools::tags$div(class = "card-header", title),
    htmltools::tags$div(class = "card-body", ...)
  )
}

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Make app into a downloadable format for mobile/web
  pwa(
      domain = "https://shiny.nick-amato.com/GeminiTesting",
      title = "DupeScoop",
      icon = "www/dupescoop.png",
      output = 'www',
  ),
  
  # Read in our custom CSS
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  
  # ---- Fancy image input ---- 
  title = "Image Input",
  theme = bslib::bs_theme(version = 5),
  lang = "en",
  shiny::fluidRow(
    style = "margin-top: 20px;",
    shiny::column(
      width = 10, offset = 1,
      card(
        title = "Select an image of a product!",
        shiny::fluidRow(
          column(
            width = 4, offset = 4,
            fileInputArea(
              "imageInput",
              label = "Tap to upload!",
              buttonLabel = "Upload a clear picture!",
              multiple = TRUE,
              accept = "text/plain"
            ),
            shiny::tableOutput("files")
          )
        )
      )
    )
  ),
  # ---- rest of code ----

  setBackgroundImage('background.jpg'),

  textInput(inputId = "prompt", label = "Description here/question"),
  actionButton(inputId = "submit", "talk to Gemini"),
  textOutput(outputId = "answer"),
  imageOutput(outputId = "imgOut")
)

server <- function(input, output) {
  
  shinybusy::add_busy_spinner(spin = "semipolar", color = "black", position = "bottom-right")
  
  
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
