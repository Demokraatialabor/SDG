library(shiny)

ui <- fluidPage(
  titlePanel("Hello World!")
)

server <- function(input, output){
  
}

shinyApp(ui = ui, server = server)
