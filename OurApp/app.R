

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  actionButton(inputId = "button1", label = "press me"),
  checkboxInput("checkbox", label = "Choice A", value = TRUE),
  checkboxGroupInput("checkGroup", label = h3("Checkbox group"), 
                     choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                     selected = 1),
  dateInput("date", label = h3("Date input"), value = "2014-01-01"),
)

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
