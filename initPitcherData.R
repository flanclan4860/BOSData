
getPitcherData <- function() {
     data1 <- read.csv(pitcherDataSource[1])
     data1 <- mutate(data1, IP=Innings, W=Wins, SO=20, SvH=Saves+Holds)
         
     data2 <- read.csv(pitcherDataSource[2], header=FALSE, skip=1, nrows=200)
     names(data2) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
     data2 <- mutate(data2, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H)
     
     data3 <- read.csv(pitcherDataSource[3], header=FALSE, skip=1, nrows=200)
     names(data3) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
     data3 <- mutate(data3, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H)
     
     data4 <- read.csv(pitcherDataSource[4], header=FALSE, skip=1, nrows=200)
     names(data4) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
     data4 <- mutate(data4, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H)
     
     data5 <- read.csv(pitcherDataSource[5], header=FALSE, skip=1, nrows=200)
     names(data5) <- c("Name","W","L","ERA","GS","G","SV","IP","H","ER","HR","SO","BB","WHIP","K/9","BB/9","FIP","WAR","RA9-WAR","playerid")
     data5 <- mutate(data5, Pos=ifelse(G/GS >= 90.0, "SP", "RP"), SvH=SV+H)
     
     pitcher <- data.table(select(data1, Name, Team, Pos))
     data1 <- data.table(select(data1, Name, IP, W, SO, SvH, ERA, WHIP))
     data2 <- data.table(select(data2, Name, IP, W, SO, SvH, ERA, WHIP))
     data3 <- data.table(select(data3, Name, IP, W, SO, SvH, ERA, WHIP))
     data4 <- data.table(select(data4, Name, IP, W, SO, SvH, ERA, WHIP))
     data5 <- data.table(select(data5, Name, IP, W, SO, SvH, ERA, WHIP))
                                                                                                         
     setkey(pitcher, Name)
     setkey(data1, Name)
     setkey(data2, Name)
     setkey(data3, Name)
     setkey(data4, Name)
     setkey(data5, Name)
     
     # Merge player and data tables
     pitcherStats1 <- merge(pitcher, data1, all.x=TRUE)
     pitcherStats2 <- merge(pitcher, data2, all.x=TRUE)
     pitcherStats3 <- merge(pitcher, data3, all.x=TRUE)
     pitcherStats4 <- merge(pitcher, data4, all.x=TRUE)
     pitcherStats5 <- merge(pitcher, data5, all.x=TRUE)
     
     # Combine all of the projected stats from all sources into one table
     combined <- rbind(pitcherStats1, pitcherStats2, pitcherStats3, pitcherStats4, pitcherStats5)
     
     return(combined)
}

pitcherStats <- function(pitcherData, weight){ 
     mydata <- pitcherData %>% 
               group_by(Name, Team, Pos) %>% 
               summarize(IP=weighted.mean(IP, weight, na.rm=TRUE),
                         Wins=weighted.mean(W, weight, na.rm=TRUE), 
                         SO=weighted.mean(SO, weight, na.rm=TRUE),
                         SaveHold=weighted.mean(SvH, weight, na.rm=TRUE), 
                         ERA=weighted.mean(ERA, weight, na.rm=TRUE), 
                         WHIP=weighted.mean(WHIP, weight, na.rm=TRUE)) %>%
                mutate(FlanaprogTiering = 
                       as.integer(tierPlayer(Pos, Wins, SO, ERA, WHIP, SaveHold))) %>%
                mutate(FlanaprogRating = 
                       as.numeric(ratePitcher(Pos, Wins, SO, SaveHold, ERA, WHIP)))                      
  
     write.csv(mydata, pitcherProjections, row.names=FALSE)
  
     return(data.frame(mydata))
}

dtPitcher <<- getPitcherData()
