
# Application: BOSData
# Filename: globals.R

library(shiny)
library(dplyr)
library(data.table)

# Constants used for calculating flanaprog ratings
SPratingMult <- 1.5
RPratingMult <- 1.0
TARGET <- c(R=74.3, HR=20.0, RBI=74.3, SB=11.8, AVG=0.280, 
            Wins=11.67, SO=150.0, S_H=39.0, ERA=3.8, WHIP=1.25,
            RPWins=5.0, RPSO=50.0, RPSaveHold=39.0, RPERA=3.0, RPWHIP=1.05)

# dtsource holds sourcename, filepath of source data, type of data(hitter or pitcher), 
#  and weight (used for calculating weighted mean), one row for each data source
sourceInfoFile <- "./dataSourceInfo.csv"
dtSourceInfo <- data.table(read.csv(sourceInfoFile, stringsAsFactors=FALSE))
pitcherSourceInfo <- filter(dtSourceInfo, Type=="Pitcher")
hitterSourceInfo <- filter(dtSourceInfo, Type=="Hitter")

# Filepath for saving Calculated projected stats
hitterProjectionsFile <- "../BOSDraft/hitterProjections.csv"
pitcherProjectionsFile <- "../BOSDraft/pitcherProjections.csv"


