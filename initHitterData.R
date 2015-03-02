
### Filename: initHitterData.R
#   March, 2015

library(shiny)
library(dplyr)
library(data.table)

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

# Weights for each source, used for calculating weighted mean
dfHitterWeight <- read.csv("./hitterWeight.csv")

# Table used for computing the flanaprog Tier 
dtHitterTier <<- data.table(read.csv("./flanHitterTiering.csv"))

# Compute flanaprog tier
tierHitter <- function(runs, homers, rbi, sb, avg) {
  
     tier <- 0
     Rtier <- 0
     HRtier <- 0
     RBItier <- 0
     SBtier <- 0
     AVGtier <- 0
  
     # Compute tier for Runs
     for (i in nrow(dtHitterTier):1){
          if (runs >= dtHitterTier[Tier==i, R]) {
               Rtier <- i
               break
          }
     }
     # Compute tier for HR
     for (i in nrow(dtHitterTier):1){
          if (homers >= dtHitterTier[Tier==i, HR]) {
               HRtier <- i
               break
          }
     }
     # Compute tier for RBI
     for (i in nrow(dtHitterTier):1){
          if (rbi >= dtHitterTier[Tier==i, RBI]) {
               RBItier <- i
               break
          }
     }
     # Compute tier for SB
     for (i in nrow(dtHitterTier):1){
          if (sb >= dtHitterTier[Tier==i, SB]) {
               SBtier <- i
               break
          }
     }
     # Computer tier for AVG
     for (i in nrow(dtHitterTier):1){
          if (avg >= dtHitterTier[Tier==i, AVG]) {
               AVGtier <- i
               break
          }
     }
     
     # Player tier is the sum of each tier
     tier <- Rtier+HRtier+RBItier+SBtier+AVGtier
     return(tier)
}

getHitterdata <- function(){
     # Get the projected stats data from each source
     data1 <- read.csv(hitterDataSource[1])
  
     data2 <- read.csv(hitterDataSource[2], header=FALSE, skip=1, nrows=200)
     names(data2) <- c("Name","PA","AB","H","2B","3B","HR","R","RBI","BB","SO","HBP","SB","CS","X","AVG","OBP","SLG","OPS","wOBA","XX","wRC+","BsR","Fld","XXX","Off","Def","WAR","playerid")
  
     data3 <- read.csv(hitterDataSource[3])
     data4 <- read.csv(hitterDataSource[4])
     data5 <- read.csv(hitterDataSource[5])
  
     # Create the player table, holds player info, without stats
     #player <- data.table(select(data1, Name=Player.Name, Team, Pos))    
     #write.csv(player, "./player.csv", row.names=FALSE)
     player <- data.table(read.csv(hitterData))
  
     # Select the columns from the raw data that contain projected stats
     data1 <- data.table(select(data1, Name=Player.Name, AB, R, HR, RBI, SB, AVG))
     data2 <- data.table(select(data2, Name, AB, R, HR, RBI, SB, AVG))
     data3 <- data.table(select(data3, Name=Player.Name, AB, R, HR, RBI, SB, AVG))
     data4 <- data.table(select(data4, Name=Player.Name, AB, R, HR, RBI, SB, AVG))
     data5 <- data.table(select(data5, Name=Player.Name, AB, R, HR, RBI, SB, AVG))
  
     # Use player name as a key for merging the player and data tables
     setkey(player, Name)
     setkey(data1, Name)
     setkey(data2, Name)
     setkey(data3, Name)
     setkey(data4, Name)
     setkey(data5, Name)
  
     # Merge player and data tables
     playerStats1 <- merge(player, data1, all.x=TRUE)
     playerStats2 <- merge(player, data2, all.x=TRUE)
     playerStats3 <- merge(player, data3, all.x=TRUE)
     playerStats4 <- merge(player, data4, all.x=TRUE)
     playerStats5 <- merge(player, data5, all.x=TRUE)
  
     # Combine all of the projected stats from all sources into one table
     combined <- rbind(playerStats1, playerStats2, playerStats3, playerStats4, playerStats5)
     
     return(combined)
}


hitterStats <- function(hitterData, weight){ 
     mydata <- hitterData %>% 
         group_by(Name, Team, Pos) %>% 
         summarize(AB=weighted.mean(AB, weight, na.rm=TRUE), 
                   R=weighted.mean(R, weight, na.rm=TRUE),
                   HR=weighted.mean(HR, weight, na.rm=TRUE), 
                   RBI=weighted.mean(RBI, weight, na.rm=TRUE), 
                   SB=weighted.mean(SB, weight, na.rm=TRUE), 
                   AVG=weighted.mean(AVG, weight, na.rm=TRUE)) %>%
         mutate(FlanaprogTiering = as.integer(tierHitter(R, HR, RBI, SB, AVG))) 

     write.csv(mydata, hitterProjections, row.names=FALSE)
     
     return(data.frame(mydata))
}

