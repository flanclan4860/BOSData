
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
  
     data1 <- read.csv(pitcherSource[1]$Filepath, stringsAsFactors=FALSE)
     data1 <- mutate(data1, IP=Innings, W=Wins, SO=20, SvH=Saves+Holds, 
                     Source = pitcherSource[1]$Num, Weight=pitcherSource[1]$Weight)
     data2 <- read.csv(pitcherSource[1]$Filepath, stringsAsFactors=FALSE)
     data2 <- mutate(data2, IP=Innings, W=Wins, SO=20, SvH=Saves+Holds, 
                     Source = pitcherSource[2]$Num, Weight=pitcherSource[2]$Weight)
     data3 <- read.csv(pitcherSource[1]$Filepath, stringsAsFactors=FALSE)
     data3 <- mutate(data3, IP=Innings, W=Wins, SO=20, SvH=Saves+Holds, 
                     Source = pitcherSource[3]$Num, Weight=pitcherSource[3]$Weight)
     data4 <- read.csv(pitcherSource[1]$Filepath, stringsAsFactors=FALSE)
     data4 <- mutate(data4, IP=Innings, W=Wins, SO=20, SvH=Saves+Holds, 
                     Source = pitcherSource[4]$Num, Weight=pitcherSource[4]$Weight)
     data5 <- read.csv(pitcherSource[1]$Filepath, stringsAsFactors=FALSE)
     data5 <- mutate(data5, IP=Innings, W=Wins, SO=20, SvH=Saves+Holds, 
                     Source = pitcherSource[5]$Num, Weight=pitcherSource[5]$Weight)
  
  
#          
#      data2 <- read.csv(pitcherSource[2]$Filepath, header=FALSE, skip=1, nrows=200)
#      names(data2) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
#      data2 <- mutate(data2, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H, 
#                      Source = pitcherSource[2]$Num, Weight=pitcherSource[2]$Weight)
#      
#      data3 <- read.csv(pitcherSource[3]$Filepath, header=FALSE, skip=1, nrows=200)
#      names(data3) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
#      data3 <- mutate(data3, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H, 
#                      Source = pitcherSource[3]$Num, Weight=pitcherSource[3]$Weight)
#      
#      data4 <- read.csv(pitcherSource[4]$Filepath, header=FALSE, skip=1, nrows=200)
#      names(data4) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
#      data4 <- mutate(data4, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H, 
#                      Source = pitcherSource[4]$Num, Weight=pitcherSource[4]$Weight)
#      
#      data5 <- read.csv(pitcherSource[5]$Filepath, header=FALSE, skip=1, nrows=200)
#      names(data5) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
#      data5 <- mutate(data5, Pos=ifelse(G/GS == 90.0, "SP", "RP"), SvH=SV+H, 
#                      Source = pitcherSource[5]$Num, Weight=pitcherSource[5]$Weight)
     
#      pitcher <- data.table(select(data1, Name, Team, Pos))
      data1 <- data.table(select(data1, Name, Team, Pos, IP, W, SO, SvH, ERA, WHIP, Source, Weight))
      data2 <- data.table(select(data2, Name, Team, Pos, IP, W, SO, SvH, ERA, WHIP, Source, Weight))
      data3 <- data.table(select(data3, Name, Team, Pos, IP, W, SO, SvH, ERA, WHIP, Source, Weight))
      data4 <- data.table(select(data4, Name, Team, Pos, IP, W, SO, SvH, ERA, WHIP, Source, Weight))
      data5 <- data.table(select(data5, Name, Team, Pos, IP, W, SO, SvH, ERA, WHIP, Source, Weight))
#                                                                                                          
#      setkey(pitcher, Name)
#      setkey(data1, Name)
#      setkey(data2, Name)
#      setkey(data3, Name)
#      setkey(data4, Name)
#      setkey(data5, Name)
#      
#      # Merge player and data tables
#      pitcherStats1 <- merge(pitcher, data1, all.x=TRUE)
#      pitcherStats2 <- merge(pitcher, data2, all.x=TRUE)
#      pitcherStats3 <- merge(pitcher, data3, all.x=TRUE)
#      pitcherStats4 <- merge(pitcher, data4, all.x=TRUE)
#      pitcherStats5 <- merge(pitcher, data5, all.x=TRUE)
#      
#      # Combine all of the projected stats from all sources into one table
#      combined <- rbind(pitcherStats1, pitcherStats2, pitcherStats3, pitcherStats4, pitcherStats5)
     combined <- rbind(data1, data2,data3, data4,data5)
     return(combined)
}

pitcherStats <- function(){ 
     mydata <- dtPitcher %>% 
               group_by(Name, Team, Pos) %>% 
               summarize(IP=weighted.mean(IP, Weight, na.rm=TRUE),
                         Wins=weighted.mean(W, Weight, na.rm=TRUE), 
                         SO=weighted.mean(SO, Weight, na.rm=TRUE),
                         SaveHold=weighted.mean(SvH, Weight, na.rm=TRUE), 
                         ERA=weighted.mean(ERA, Weight, na.rm=TRUE), 
                         WHIP=weighted.mean(WHIP, Weight, na.rm=TRUE)) %>%
                mutate(FlanaprogTiering = 
                       as.integer(tierPlayer(Pos, Wins, SO, ERA, WHIP, SaveHold))) %>%
                mutate(FlanaprogRating = 
                       as.numeric(ratePitcher(Pos, Wins, SO, SaveHold, ERA, WHIP)))                      
  
     # Save calculated projected stats to a file
     write.csv(mydata, pitcherProjections, row.names=FALSE)
  
     return(mydata)
}

dtPitcher <<- getPitcherData()
