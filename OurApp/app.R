library(shiny)
library(shinybusy)
library(shiny.pwa)
library(shinyWidgets)
library(bslib)

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
  theme = bslib::bs_theme(preset = 'quartz'),
  
  # Make app into a downloadable format for mobile/web
  pwa(
      domain = "https://shiny.nick-amato.com/GeminiTesting",
      title = "DupeScoop",
      icon = "www/dupescoop.png",
      output = 'www',
  ),
  
  # Read in our custom CSS
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  # ),
  # 
  # ---- Fancy image input ---- 

  shiny::fluidRow(
    style = "margin-top: 20px;",
    shiny::column(
      width = 10, offset = 1,
      card(
        title = div("Select an image of a product!", align = 'center'),
        shiny::fluidRow(
          column(
            width = 4, offset = 4,
            fileInputArea(
              "imageInput",
              label = "Tap to upload!",
              buttonLabel = "Upload a clear picture!",
              multiple = FALSE
            ),
            shiny::tableOutput("files")
          )
        )
      )
    )
  ),
  # ---- rest of code ----

  setBackgroundImage('darker.jpg'),

  div(
    textInput(inputId = "prompt", label = "Description here/question"),
    actionButton(inputId = "submit", "talk to Gemini"),
    textOutput(outputId = "answer"),
    imageOutput(outputId = "imgOut", width = "400px", height = "400px"),
    align = 'center'
  )

)

server <- function(input, output) {
  
  shinybusy::add_busy_spinner(spin = "semipolar", color = "black", position = "bottom-right")
  
  
  observeEvent(input$imageInput, {
    path = input$imageInput$datapath
    
    output$imgOut = renderImage({
      list(
        src = path,
        width = "400px",
        height = "400px"
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
