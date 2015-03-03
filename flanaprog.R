# Weights for each source, used for calculating weighted mean
dfHitterWeight <- read.csv("./hitterWeight.csv")
dfPitcherWeight <- read.csv("./pitcherWeight.csv")

# Table used for computing the flanaprog Tier 
dfHitterTier <- read.csv("./flanHitterTiering.csv")

# Compute flanaprog tier
tierPlayer <- function(pos, x1, x2, x3, x4, x5) {
  
  if (pos=="SP") {
    df <- dfSPTier
  } else if (pos=="RP") {
    df <- dfRPTier
  } else {
    df <- dfHitterTier
  }
  tier <- c(0, 0, 0, 0, 0)    
  # Compute tier for Runs
  for (i in nrow(df):1){
    if (x1 >= df[df$Tier==i, 2]) {
      tier[1] <- i
      break
    }
  }
  # Compute tier for HR
  for (i in nrow(df):1){
    if (x2 >= df[df$Tier==i, 3]) {
      tier[2] <- i
      break
    }
  }
  # Compute tier for RBI
  for (i in nrow(df):1){
    if (x3 >= df[df$Tier==i, 4]) {
      tier[3] <- i
      break
    }
  }
  # Compute tier for SB
  for (i in nrow(df):1){
    if (x4 >= df[df$Tier==i, 5]) {
      tier[4] <- i
      break
    }
  }
  # Computer tier for AVG
  for (i in nrow(df):1){
    if (x5 >= df[df$Tier==i, 6]) {
      tier[5] <- i
      break
    }
  }
  # Player tier is the sum of each tier
  return(sum(tier))
}


rateHitter <- function(R, HR, RBI, SB, AVG){
  
  format((HR/TARGET["HR"] + 
            RBI/TARGET["RBI"] + 
            SB/TARGET["SB"] + 
            AVG/TARGET["AVG"] + 
            R/TARGET["R"]), 
         digits=4, nsmall=3)
  
}

ratePitcher <- function(Pos, Wins, SO, SaveHold, ERA, WHIP) {
  
  ifelse(Pos=="SP", 
         format((SPratingMult * (Wins/TARGET["Wins"] + 
                                   SO/TARGET["SO"] +
                                   SaveHold/TARGET["SaveHold"] +
                                   TARGET["ERA"]/ERA +
                                   TARGET["WHIP"]/WHIP)), 
                digits=4, nsmall=3),
         format((RPratingMult * (Wins/TARGET["RPWins"] + 
                                   SO/TARGET["RPSO"] +
                                   SaveHold/TARGET["RPSaveHold"] +
                                   TARGET["RPERA"]/ERA +
                                   TARGET["RPWHIP"]/WHIP)), 
                digits=4, nsmall=3))
}
