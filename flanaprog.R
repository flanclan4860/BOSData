
# Application: BOSData
# Filename: flanaprog.R
# Helper functions for computing the flanaprog tierings and ratings

# Table used for computing the flanaprog Tier 
# Tiering tables have 6 rows, one for each possible tier
# Column 6 is the tier (6-1), and 
#  for hitters Col1 is Runs, Col2 is HR, Col3 is RBI, Col4 is SB, Col5 is AVG
#  for pitchers Col1 is Wins, Col2 is SO, Col3 is S_H, Col4 is ERA, Col5 is WHIP
hitterTier <- read.csv("./flanHitterTiering.csv")
startPitcherTier <- read.csv("./flanSPTiering.csv")
reliefPitcherTier <- read.csv("./flanRPTiering.csv")

# Compute flanaprog tier
# Takes a position and 5 stats for a player and returns a tiering
# For hitters, x1=Runs, x2=HR, x3=RBI, x4=SB, x5=AVG
# For pitchers, x1=Wins, x2=SO, x3=S_H, x4=ERA, x5=WHIP
# Tier for each stat is between 0 and 6

# The sum of tiers for all stats is returned
tierPlayer <- function(pos, x1, x2, x3, x4, x5) {

     ifelse (pos=="SP",
          df <- startPitcherTier,
          ifelse (pos=="RP",
               df <- reliefPitcherTier,
               df <- hitterTier))
     
     tier <- c(0, 0, 0, 0, 0)    
     # Compute tier for Runs/Wins
     for (i in nrow(df):1){
          if (x1 >= df[df$Tier==i, 1]) {
               tier[1] <- i
               break
          }
     }
     # Compute tier for HR/SO
     for (i in nrow(df):1){
          if (x2 >= df[df$Tier==i, 2]) {
               tier[2] <- i
               break
          }
     }
     # Compute tier for RBI/S_H
     for (i in nrow(df):1){
          if (x3 >= df[df$Tier==i, 3]) {
               tier[3] <- i
               break
          }
     }
     if (!grepl("P", pos)) {
       # Compute tier for SB
       for (i in nrow(df):1){
         if (x4 >= df[df$Tier==i, 4]) {
           tier[4] <- i
           break
         }
       }
       # Computer tier for AVG
       for (i in nrow(df):1){
         if (x5 >= df[df$Tier==i, 5]) {
           tier[5] <- i
           break
         }
       } 
      } else {
         # Compute tier for ERA
         if (x4 <= 0) {
           tier[4] <- 0
         } else {
            for (i in nrow(df):1){
               if (x4 <= df[df$Tier==i, 4]) {
                  tier[4] <- i
                  break
               }
            }
         }
         # Computer tier for WHIP
         if (x5 <= 0) {
           tier[5] <- 0
         } else {
           for (i in nrow(df):1){
              if (x5 <= df[df$Tier==i, 5]) {
                  tier[5] <- i
                  break
              }
           }
         } 
      }
     # Player tier is the sum of all tiers
     return(sum(tier))
}

# Calculate the flanaprog rating for a hitter
rateHitter <- function(R, HR, RBI, SB, AVG){
  
     format((HR / TARGET["HR"] + 
             RBI / TARGET["RBI"] + 
             SB / TARGET["SB"] + 
             AVG / TARGET["AVG"] + 
             R / TARGET["R"]), 
             digits=4, nsmall=3)
  
}

# Calculate the flanaprog rating for a pitcher
ratePitcher <- function(Pos, Wins, SO, S_H, ERA, WHIP) {

     # Avoid divide by zero
     ifelse (ERA == 0, ERARating <- 0, ERARating <- TARGET["ERA"] / ERA)
     ifelse (WHIP == 0, WHIPRating <- 0, WHIPRating <- TARGET["WHIP"] / WHIP)
  
     ifelse(Pos=="SP", 
         # Rating for a starting pitcher
         format((SPratingMult * (Wins / TARGET["Wins"] + 
                                 SO / TARGET["SO"] +
                                 S_H / TARGET["S_H"] +
                                 ERARating +
                                 WHIPRating)), 
                 digits=4, nsmall=3),
         
         # Rating for a relief pitcher
         format((RPratingMult * (Wins / TARGET["RPWins"] + 
                                 SO / TARGET["RPSO"] +
                                 S_H / TARGET["RPSaveHold"] +
                                 ERARating +
                                 WHIPRating)), 
                 digits=4, nsmall=3))
}
