library(shiny)
library(shinydashboard)
library(readxl)
library(DT)

#loadData
SDG_Data <- as.data.frame(read_excel("Data/sdgdata.xlsx"))
rownames(SDG_Data) <- SDG_Data[,1]
SDG_Data [,1] <- NULL
SDG_Data[, 1:13] <- sapply(SDG_Data[,1:13], as.numeric)
uhisData <- SDG_Data[1:4, ]
polData <- SDG_Data[6:7, ]
rm(SDG_Data)

dataset_choices <- c("uhisData", "polData")

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "SDG Vizualization Demo"),
  dashboardSidebar(sidebarMenu(
    menuItem("SDG11", tabName = "sdg11", icon = icon("building")),
    menuItem("SDG12", tabName = "sdg12", icon = icon("trash"))
  )),
  dashboardBody(tabItems(
    tabItem("sdg11",
            fluidRow(
              tags$head(tags$style(HTML(".small-box {height: 150px}"))),
              valueBoxOutput("seisukorras"),
              valueBoxOutput("linnades"),
              valueBoxOutput("peenosakesed")),
            fluidRow(
              valueBoxOutput("roheline"),
              valueBoxOutput("rahulolu"),
              valueBoxOutput("uhistransport")),
            fluidRow(
              column(3, selectInput("dataset", "Choose Dataset: ", choices = c("Public Transport",
                                                                               "Pollution Data"))),
              # column(3, selectInput("viz", "Choose a visualization:", choices = c("Bar Graph",
              #                                                           "Line Graph",
              #                                                           "Area Graph",
              #                                                           "Pie Chart"
              #                                                           ))),
              DT::dataTableOutput("dataTable")
            ),
            fluidRow(
              downloadButton("downloadData", "Download Data"),
              HTML("<br><br>"),
              plotOutput("dataplot")
            )
    ),
    tabItem("sdg12",
            fluidRow(
              box("something here")
            ))
  )
  )
  
  
)




server <- function(input, output) {
  output$seisukorras <- renderValueBox({
    valueBox("85%", "Heas ja rahuldavas seisukorras olevate ehitismälestiste osakaal
             ", icon = icon("building") , color = "green"
             
    )  })
  output$linnades <- renderValueBox({
    valueBox("4.5", "Linnades toimunud liiklusõnnetuste tagajärjel vigastatute ja hukkunute arv", icon = icon("car") , color = "yellow"
             
    )  })
  output$peenosakesed <- renderValueBox({
    valueBox(paste0(polData[1,12], "% PM10"), "Peenosakesed PM10 ja PM2,5 välisõhus", icon = icon("industry") , color = "green"
             
    ) })
  output$roheline <- renderValueBox({
    valueBox("17%", "Rohealad linnades
             ", icon = icon("leaf") , color = "red"
             
    ) })
  output$rahulolu <- renderValueBox({
    valueBox("80%","Rahulolu eluruumide seisundiga
             ", icon = icon("smile-o") , color = "green"
             
    ) })
  output$uhistransport <- renderValueBox({
    valueBox(paste0(uhisData[1,13], "%"), "Ühistranspordiga, jalgrattaga või jalgsi tööl käijate osakaal", icon = icon("bus") , color = "yellow"
    )
  })
  
  datasetInput <- reactive({
    switch(input$dataset,
           
           "Public Transport" = uhisData,
           "Pollution Data" = polData
    )
  })
  
  output$dataTable <- DT::renderDataTable({
    datasetInput()
    
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names= FALSE)
    }
  )
  
  output$dataplot <- renderPlot({
    if(input$dataset == "Public Transport") {
      plot(colnames(uhisData), uhisData[1,1:13], "b", xlab = "Year", ylab = "Ühistranspordiga tööl käijate osatähtsus hõivatute seas, %")
    }
    else{
      plot(colnames(polData), polData[1,1:13], "b", xlab= "Year", ylab ="Peenosakeste PM10 sisaldus välisõhus, tuhat tonni", color = "blue")
    }
  })
  
}


shinyApp(ui, server)
