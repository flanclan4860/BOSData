
# Filename: initHitterData.R
# Contains functions for reading hitter data from sources
# and calculating the weighted means for each stat

inputHitterWeight <- function(dataSource, input) {
  
  ifelse(dataSource==1, input$hw1, 
         ifelse(dataSource==2, input$hw2,
                ifelse(dataSource==3, input$hw3,
                       ifelse(dataSource==4, input$hw4, input$hw5))))
}

getHitterData <- function() {
  
     data1 <- read.csv(hitterSource[1]$Filepath, stringsAsFactors=FALSE)
     data1 <- mutate(data1, Source = hitterSource[1]$Num, Weight=hitterSource[1]$Weight)
     data2 <- read.csv(hitterSource[1]$Filepath, stringsAsFactors=FALSE)
     data2 <- mutate(data2, Source = hitterSource[2]$Num, Weight=hitterSource[2]$Weight)
  
#      data2 <- read.csv(hitterSource[2]$Filepath, header=FALSE, skip=1, nrows=200)
#      names(data2) <- c("Name","PA","AB","H","2B","3B","HR","R","RBI","BB","SO","HBP","SB","CS","X","AVG","OBP","SLG","OPS","wOBA","XX","wRC+","BsR","Fld","XXX","Off","Def","WAR","playerid")
#      data2 <- mutate(data2, Source = hitterSource[2]$Num, Weight=hitterSource[2]$Weight)
#      
     
     data3 <- read.csv(hitterSource[3]$Filepath, stringsAsFactors=FALSE)
     data3 <- mutate(data3, Source = hitterSource[3]$Num, 
                     Weight=hitterSource[3]$Weight)
     data4 <- read.csv(hitterSource[4]$Filepath, stringsAsFactors=FALSE)
     data4 <- mutate(data4, Source = hitterSource[4]$Num, 
                     Weight=hitterSource[4]$Weight)
     data5 <- read.csv(hitterSource[5]$Filepath, stringsAsFactors=FALSE)
     data5 <- mutate(data5, Source = hitterSource[5]$Num, 
                     Weight=hitterSource[5]$Weight)
     
     
     data1 <- data.table(select(data1, Name=Player.Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data2 <- data.table(select(data2, Name=Player.Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data3 <- data.table(select(data3, Name=Player.Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data4 <- data.table(select(data4, Name=Player.Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
     data5 <- data.table(select(data5, Name=Player.Name, Team, Pos, 
                                AB, R, HR, RBI, SB, AVG, Source, Weight))
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

hitterStats <- function(){ 
     mydata <- dtHitter %>% group_by(Name, Team, Pos) %>% 
               summarize(AB=weighted.mean(AB, Weight, na.rm=TRUE), 
                         R=weighted.mean(R, Weight, na.rm=TRUE),
                         HR=weighted.mean(HR, Weight, na.rm=TRUE), 
                         RBI=weighted.mean(RBI, Weight, na.rm=TRUE), 
                         SB=weighted.mean(SB, Weight, na.rm=TRUE), 
                         AVG=weighted.mean(AVG, Weight, na.rm=TRUE)) %>%
    mutate(FlanaprogTiering = as.integer(tierPlayer(Pos, R, HR, RBI, SB, AVG))) %>%
    mutate(FlanaprogRating = as.numeric(rateHitter(R, HR, RBI, SB, AVG)))
  
    # Save the calculated projections to a file
    write.csv(mydata, hitterProjections, row.names=FALSE)
  
    return(mydata)
}

dtHitter <<- getHitterData()

