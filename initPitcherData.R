
# Application: BOSData
# Filename: initPitcherData.R
# Contains functions for reading pitcher data from sources
# and calculating the weighted means for each stat

inputPitcherWeight <- function(dataSource, input) {
  
  ifelse(dataSource==1, input$pw1, 
         ifelse(dataSource==2, input$pw2,
                ifelse(dataSource==3, input$pw3,
                       ifelse(dataSource==4, input$pw4, input$pw5))))
}

getPitcherData <- function() {
  
     # Read in projected stats from all source files
     # Rename some columns, and add new columns for
     # the source number and weight factor  
     data1 <- read.csv(pitcherSourceInfo[1]$Filepath, stringsAsFactors=FALSE)
     data1 <- mutate(data1, 
                     Name=PlayerName, Team=TeamID, Pos=ProjectedPosition, SO=K, SvH=SV+HLD, 
                     Source = pitcherSourceInfo[1]$Num, Weight=pitcherSourceInfo[1]$Weight)
     data2 <- read.csv(pitcherSourceInfo[2]$Filepath, stringsAsFactors=FALSE)
     data2 <- mutate(data2, 
                     Name=PlayerName, Team=TeamID, Pos=ProjectedPosition, SO=K, SvH=SV+HLD, 
                     Source = pitcherSourceInfo[2]$Num, Weight=pitcherSourceInfo[2]$Weight)
     data3 <- read.csv(pitcherSourceInfo[3]$Filepath, stringsAsFactors=FALSE)
     data3 <- mutate(data3, 
                     Name=PlayerName, Team=TeamID, Pos=ProjectedPosition, SO=K, SvH=SV+HLD, 
                     Source = pitcherSourceInfo[3]$Num, Weight=pitcherSourceInfo[3]$Weight)
     data4 <- read.csv(pitcherSourceInfo[4]$Filepath, stringsAsFactors=FALSE)
     data4 <- mutate(data4, 
                     Name=PlayerName, Team=TeamID, Pos=ProjectedPosition, SO=K, SvH=SV+HLD, 
                     Source = pitcherSourceInfo[4]$Num, Weight=pitcherSourceInfo[4]$Weight)
     data5 <- read.csv(pitcherSourceInfo[5]$Filepath, stringsAsFactors=FALSE)
     data5 <- mutate(data5, 
                     Name=PlayerName, Team=TeamID, Pos=ProjectedPosition, SO=K, SvH=SV+HLD, 
                     Source = pitcherSourceInfo[5]$Num, Weight=pitcherSourceInfo[5]$Weight)
     
     # Fill in missing data with zero
     data1[is.na(data1)] <- 0
     data2[is.na(data2)] <- 0
     data3[is.na(data3)] <- 0
     data4[is.na(data4)] <- 0
     data5[is.na(data5)] <- 0
     
     # Select desired columns
     data1 <- data.table(select(data1, Name, Team, Pos, 
                                IP, W, SO, SvH, ERA, WHIP, Source, Weight))
     data2 <- data.table(select(data2, Name, Team, Pos, 
                                IP, W, SO, SvH, ERA, WHIP, Source, Weight))
     data3 <- data.table(select(data3, Name, Team, Pos, 
                                IP, W, SO, SvH, ERA, WHIP, Source, Weight))
     data4 <- data.table(select(data4, Name, Team, Pos, 
                                IP, W, SO, SvH, ERA, WHIP, Source, Weight))
     data5 <- data.table(select(data5, Name, Team, Pos, 
                                IP, W, SO, SvH, ERA, WHIP, Source, Weight))

     # Combine all of the projected stats from all sources into one table
     combined <- rbind(data1, data2,data3, data4,data5)
     return(combined)
}

pitcherStats <- function(){ 
     mydata <- dtPitcher %>% 
               group_by(Name, Team, Pos) %>% 
               summarize(IP=weighted.mean(IP, Weight, na.rm=TRUE),
                         Wins=weighted.mean(W, Weight, na.rm=TRUE), 
                         SO=weighted.mean(SO, Weight, na.rm=TRUE),
                         S_H=weighted.mean(SvH, Weight, na.rm=TRUE), 
                         ERA=weighted.mean(ERA, Weight, na.rm=TRUE), 
                         WHIP=weighted.mean(WHIP, Weight, na.rm=TRUE)) %>%
                mutate(Tiering = 
                       as.integer(tierPlayer(Pos, Wins, SO, ERA, WHIP, S_H))) %>%
                mutate(Rating = 
                       as.numeric(ratePitcher(Pos, Wins, SO, S_H, ERA, WHIP))) %>%
                filter(Tiering != 0)
  
     genericPitchers <- read.csv("./genericPitchers.csv")
     gP <- mutate(genericPitchers, Tiering = 1, Rating = 1.0)
#                  Tiering = tierPlayer(Pos, Wins, SO, ERA, WHIP, S_H), 
#                  Rating = ratePitcher(Pos, Wins, SO, S_H, ERA, WHIP))
#                 as.integer(tierPlayer(Pos, Wins, SO, ERA, WHIP, S_H)),
#                 Rating = 
#                 as.numeric(ratePitcher(Pos, Wins, SO, S_H, ERA, WHIP)))
     
     mydata <- rbind(mydata, gP)
     
     # Save calculated projected stats to a file
     write.csv(mydata, pitcherProjectionsFile, row.names=FALSE)
  
     return(mydata)
}

dtPitcher <<- getPitcherData()
