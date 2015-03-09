
# Filename: ui.R
# Contains user interface elements for BOSData app
# There is a headerPanel, sidebarPanel, and mainPanel

# mainPanel has 2 tabPanels, one for hitter table and one for pitcher table
# sidebarPanel is divided into 2 sections, one for hitters, one for pitchers
#   each section has an input box for entering the weight factor for each
#   source of data projections, the weights are used in calculating a 
#   weighted mean for all sources, resulting in the hitter and pitcher data tables

source("globals.R")
source("initHitterData.R")
source("initPitcherData.R")
source("flanaprog.R")


shinyUI(
  
     pageWithSidebar(
          headerPanel("BOS Fantasy Baseball League"),
          sidebarPanel(
               wellPanel(h4("Hitters"),
                    numericInput('hw1', hitterSource[1]$Source, hitterSource[1]$Weight),
                    numericInput('hw2', hitterSource[2]$Source, hitterSource[2]$Weight),
                    numericInput('hw3', hitterSource[3]$Source, hitterSource[3]$Weight),
                    numericInput('hw4', hitterSource[4]$Source, hitterSource[4]$Weight),
                    numericInput('hw5', hitterSource[5]$Source, hitterSource[5]$Weight)
                    #,
                    #actionButton("submit","Submit")       
               ),
               wellPanel(h4("Pitchers"),
                    numericInput('pw1', pitcherSource[1]$Source, pitcherSource[1]$Weight),
                    numericInput('pw2', pitcherSource[2]$Source, pitcherSource[2]$Weight),
                    numericInput('pw3', pitcherSource[3]$Source, pitcherSource[3]$Weight),
                    numericInput('pw4', pitcherSource[4]$Source, pitcherSource[4]$Weight),
                    numericInput('pw5', pitcherSource[5]$Source, pitcherSource[5]$Weight)      
               )
           ),
           mainPanel(
                tabsetPanel(type = "tabs", 
                            tabPanel("Hitters", dataTableOutput('hittersTable')),
                            tabPanel("Pitchers", dataTableOutput('pitcherTable')))
           )
     )
)

