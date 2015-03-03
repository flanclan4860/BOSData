library("shiny") 

#dfHitterWeight <- read.csv("./hitterWeight.csv")
#dfPitcherWeight <- read.csv("./pitcherWeight.csv")

source("globals.R")

shinyUI(
  
     pageWithSidebar(
          headerPanel("BOS Fantasy Baseball League"),
          sidebarPanel(
               wellPanel(h4("Hitters"),
                    numericInput('hw1', "BOSData1", dfHitterWeight[1,"Weight"]),
                    numericInput('hw2', "FanGraphs", dfHitterWeight[2,"Weight"]),
                    numericInput('hw3', "BOSData2", dfHitterWeight[3,"Weight"]),
                    numericInput('hw4', "BOSData3", dfHitterWeight[4,"Weight"]),
                    numericInput('hw5', "BOSData4", dfHitterWeight[5,"Weight"])
                    #,
                    #actionButton("submit","Submit")       
               ),
               wellPanel(h4("Pitchers"),
                         numericInput('pw1', "PitcherData1", dfPitcherWeight[1,"Weight"]),
                         numericInput('pw2', "FanGraphs", dfPitcherWeight[2,"Weight"]),
                         numericInput('pw3', "PitcherData2", dfPitcherWeight[3,"Weight"]),
                         numericInput('pw4', "PitcherData3", dfPitcherWeight[4,"Weight"]),
                         numericInput('pw5', "PitcherData4", dfPitcherWeight[5,"Weight"])      
               )
           ),
           mainPanel(
                tabsetPanel(type = "tabs", 
                            tabPanel("Hitters", dataTableOutput('hittersTable')),
                            tabPanel("Pitchers", dataTableOutput('pitcherTable')))
           )
     )
)

