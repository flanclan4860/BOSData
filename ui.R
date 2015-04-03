
# Application: BOSData
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
          headerPanel("Boys of Summer Draft Prep"),
          sidebarPanel(
               wellPanel(h4("Hitters"),
                    numericInput('hw1', hitterSourceInfo[1]$Source, hitterSourceInfo[1]$Weight),
                    numericInput('hw2', hitterSourceInfo[2]$Source, hitterSourceInfo[2]$Weight),
                    numericInput('hw3', hitterSourceInfo[3]$Source, hitterSourceInfo[3]$Weight),
                    numericInput('hw4', hitterSourceInfo[4]$Source, hitterSourceInfo[4]$Weight),
                    numericInput('hw5', hitterSourceInfo[5]$Source, hitterSourceInfo[5]$Weight)     
               ),
               wellPanel(h4("Pitchers"),
                    numericInput('pw1', pitcherSourceInfo[1]$Source, pitcherSourceInfo[1]$Weight),
                    numericInput('pw2', pitcherSourceInfo[2]$Source, pitcherSourceInfo[2]$Weight),
                    numericInput('pw3', pitcherSourceInfo[3]$Source, pitcherSourceInfo[3]$Weight),
                    numericInput('pw4', pitcherSourceInfo[4]$Source, pitcherSourceInfo[4]$Weight),
                    numericInput('pw5', pitcherSourceInfo[5]$Source, pitcherSourceInfo[5]$Weight)      
               )
           ),
           mainPanel(
                tabsetPanel(type = "tabs", 
                            tabPanel("Hitters", dataTableOutput('hittersTable')),
                            tabPanel("Pitchers", dataTableOutput('pitcherTable')))
           )
     )
)

