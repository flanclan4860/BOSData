
# Application: BOSData
# Filename: initHitterData.R
# Contains functions for reading hitter data from sources
# and calculating the weighted means for each stat

inputHitterWeight <- function(dataSource, input) {
  
  ifelse(dataSource==1, input$hw1, 
         ifelse(dataSource==2, input$hw2,
                ifelse(dataSource==3, input$hw3,
                       ifelse(dataSource==4, input$hw4, input$hw5))))
}

validPos <- function(positions) {
  # Remove Util, CI, and MI from eligible positions
  # If Util is the only eligible position, replace it with DH
  positions <- ifelse(positions=="Util", 
                      sub("Util", "DH", positions, fixed=TRUE),
                      sub("Util", "", positions, fixed=TRUE))
  positions <- sub("CI", "", positions)
  positions <- sub("MI", "", positions)
  
}
getHitterData <- function() {
  
     # Read in projected stats from all source files
     # Rename some columns, and add new columns for
     # the source number and weight factor
     data1 <- read.csv(hitterSourceInfo[1]$Filepath, stringsAsFactors=FALSE)
     data1 <- mutate(data1, Name=PlayerName, Team=TeamID, 
                            Pos=validPos(EligiblePositions),
                            Source = hitterSourceInfo[1]$Num, 
                            Weight=hitterSourceInfo[1]$Weight)
     data2 <- read.csv(hitterSourceInfo[2]$Filepath, stringsAsFactors=FALSE)
     data2 <- mutate(data2, Name=PlayerName, Team=TeamID, 
                            Pos=validPos(EligiblePositions),
                            Source = hitterSourceInfo[2]$Num, 
                            Weight=hitterSourceInfo[2]$Weight)       
     data3 <- read.csv(hitterSourceInfo[3]$Filepath, stringsAsFactors=FALSE)
     data3 <- mutate(data3, Name=PlayerName, Team=TeamID, 
                            Pos=validPos(EligiblePositions),
                            Source = hitterSourceInfo[3]$Num, 
                            Weight=hitterSourceInfo[3]$Weight)
     data4 <- read.csv(hitterSourceInfo[4]$Filepath, stringsAsFactors=FALSE)
     data4 <- mutate(data4, Name=PlayerName, Team=TeamID, 
                            Pos=validPos(EligiblePositions),
                            Source = hitterSourceInfo[4]$Num, 
                            Weight=hitterSourceInfo[4]$Weight)
     data5 <- read.csv(hitterSourceInfo[5]$Filepath, stringsAsFactors=FALSE)
     data5 <- mutate(data5, Name=PlayerName, Team=TeamID, 
                            Pos=validPos(EligiblePositions),
                            Source = hitterSourceInfo[5]$Num, 
                            Weight=hitterSourceInfo[5]$Weight)
  
     # Select desired columns
     data1 <- data.table(select(data1, Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data2 <- data.table(select(data2, Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data3 <- data.table(select(data3, Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data4 <- data.table(select(data4, Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data5 <- data.table(select(data5, Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
      
     # Fill in missing data with zero
     data1[is.na(data1)] <- 0
     data2[is.na(data2)] <- 0
     data3[is.na(data3)] <- 0
     data4[is.na(data4)] <- 0
     data5[is.na(data5)] <- 0
     
     # Combine all of the projected stats from all sources into one table
     combined <- rbind(data1, data2,data3, data4,data5)
     return(combined)
}

hitterStats <- function(){ 
     mydata <- dtHitter %>% 
               group_by(Name, Team, Pos) %>% 
               summarize(AB=weighted.mean(AB, Weight, na.rm=TRUE), 
                         R=weighted.mean(R, Weight, na.rm=TRUE),
                         HR=weighted.mean(HR, Weight, na.rm=TRUE), 
                         RBI=weighted.mean(RBI, Weight, na.rm=TRUE), 
                         SB=weighted.mean(SB, Weight, na.rm=TRUE), 
                         AVG=weighted.mean(AVG, Weight, na.rm=TRUE)) %>%
               mutate(Tiering = as.integer(tierPlayer(Pos, R, HR, RBI, SB, AVG))) %>%
               mutate(Rating = as.numeric(rateHitter(R, HR, RBI, SB, AVG))) %>%
               filter(Tiering != 0)
     
    
    genericHitters <- read.csv("./genericHitters.csv")
    gH <- mutate(genericHitters, Tiering = 1, Rating = 1.0)
    #             Tiering = as.integer(tierPlayer(Pos, R, HR, RBI, SB, AVG)), 
    #             Rating = rateHitter(R, HR, RBI, SB, AVG))
    #                 as.integer(tierPlayer(Pos, Wins, SO, ERA, WHIP, S_H)),
    #                 Rating = 
    #                 as.numeric(ratePitcher(Pos, Wins, SO, S_H, ERA, WHIP)))
    
    mydata <- rbind(mydata, gH)
  
    # Save the calculated projections to a file
    write.csv(mydata, hitterProjectionsFile, row.names=FALSE)
  
    return(mydata)
}

dtHitter <<- getHitterData()

