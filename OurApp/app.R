library(shiny)
library(shinybusy)
library(shiny.pwa)
library(shinyWidgets)
library(bslib)
library(stringr)

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
  
  div(h1("Dupe Scoop", class = 'main-title'), align = 'center'),
  
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
    actionButton(inputId = "submit", "Find Better Deals!"),
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
    
    main_prompt = paste0("Based on the picture provided, can you please find similar products that contain the same or similar ingredients.",
                         ' The items should also be found for a cheaper price. The products should also have the same function as the original product. ',
                         "Please only return a bulleted list of the names of the similar products.",
                         " I do not want any additional information in your response, just the names of the similar/cheaper products.",
                         " Please return each similar product with the form **(product)**")
    
    SavedAnswer = gemini_vision(main_prompt, input$imageInput$datapath)
    

    
    products = str_match_all(SavedAnswer, pattern = "\\*\\*(.*)\\*\\*")[[1]][,2]
    
    print(input$prompt)
    print(SavedAnswer)
    
    output$answer = renderText(products)
  })
}

shinyApp(ui = ui, server = server)
