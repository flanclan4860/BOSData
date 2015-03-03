
library(shiny)
library(dplyr)
library(data.table)


SPratingMult <- 1.5
RPratingMult <- 1.0

TARGET <- c(R=74.3, HR=20.0, RBI=74.3, SB=11.8, AVG=0.280, 
            Wins=11.67, SO=150.0, SaveHold=39.0, ERA=3.8, WHIP=1.25,
            RPWins=5.0, RPSO=50.0, RPSaveHold=39.0, RPERA=3.0, RPWHIP=1.05)


# Contains just name, team, and pos, used for merging sources
hitterData <- "./hitter.csv"

# Calculated projected stats
hitterProjections <- "../BOSDraft/hitterProjections.csv"

# Sources for projected stats
hitterDataSource <- c("./BOSData1.csv", 
                      "./FanGraphsHitters.csv", 
                      "./BOSData2.csv", 
                      "./BOSData3.csv", 
                      "./BOSData4.csv")

pitcherData <- "./pitcher.csv"
pitcherProjections <- "../BOSDraft/pitcherProjections.csv"

pitcherDataSource <- c("./pitcherData1.csv",
                       "./FanGraphsPitchers.csv",
                       "./FanGraphsPitchers.csv",
                       "./FanGraphsPitchers.csv",
                       "./FanGraphsPitchers.csv")

source("initHitterData.R")
source("initPitcherData.R")
source("flanaprog.R")
