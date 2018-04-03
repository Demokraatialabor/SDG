library(shiny)
library(shinydashboard)
library(tidyverse)
library(readxl)
#loadData
SDG_Data <- as.data.frame(read_excel("Data/Näitajad_töötuba.xlsx"))
SDG_Data[, 2:13] <- sapply(SDG_Data[,2:13], as.numeric)
uhisData <- SDG_Data[1:4, ]
polData <- SDG_Data[6:7, ]
rm(SDG_Data)

ui <- dashboardPage(
  skin = "green",
  dashboardHeader(title = "SDG Vizualization Demo"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "home", icon = icon("dashboard")),
    menuItem(
      "Data Explorer",
      tabName = "explore"
    )
  )),
  dashboardBody(tabItems(
    tabItem("home",
            fluidRow(
              box(
                title = "Heas ja rahuldavas seisukorras olevate ehitismälestiste osakaal",
                width = 4,
                height = 100,
                background = "green"
              ),
              box(
                title = "Linnades toimunud liiklusõnnetuste tagajärjel vigastatute ja hukkunute arv",
                width = 4,
                height = 100,
                background = "yellow"
              ),
              box(
                title = "Peenosakesed PM10 ja PM2,5 välisõhus",
                width = 4,
                height = 100,
                background = "red"
              )
            ),
            fluidRow(
              box(
                title = "Rohealad linnades",
                width = 4,
                height = 100,
                background = "green"
              ),
              box(
                title = "Rahulolu eluruumide seisundiga",
                width = 4,
                height = 100,
                background = "green"
              ),
              box(
                title = "Ühistranspordiga, jalgrattaga või jalgsi tööl käijate osakaal",
                width = 4,
                height = 100,
                background = "yellow"
              )
            )),
    tabItem("explore",
            fluidRow(box(title = "Data Exploration",
                         plotOutput("plot1", height = 250))))
  ))
)

server <- function(input, output) {

}


shinyApp(ui, server)
