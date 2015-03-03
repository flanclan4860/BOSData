

# TARGET <- c(R=74.3, HR=20.0, RBI=74.3, SB=11.8, AVG=0.280, 
#             Wins=11.67, SO=150.0, SaveHold=39.0, ERA=3.8, WHIP=1.25,
#             RPWins=5.0, RPSO=50.0, RPSaveHold=39.0, RPERA=3.0, RPWHIP=1.05)

# Holds functions used for setting up the data
#source("initHitterData.R")
#source("initPitcherData.R")

# Get data table that holds the player stats
#dtHitter <<- getHitterdata()
#dtPitcher <<- getPitcherData()

shinyServer(
  
    function(input,output,session){        
         
         # Output Projected Stats Table
          output$hittersTable <- renderDataTable({
               
               weight <- c(input$hw1, input$hw2, input$hw3, input$hw4, input$hw5)
               
               # Compute the weighted means for each player
               # Re-computed when one of the inputs changes
               df <- hitterStats(dtHitter, weight) 
               
               # Store the new weights
               dfHitterWeight$Weight <- weight
               write.csv(dfHitterWeight, "./hitterWeight.csv", row.names=FALSE)
               
               return(df)
          }
          , options=list(info=FALSE, paging=FALSE)
          )
          
          output$pitcherTable <- renderDataTable({
            
            weight <- c(input$pw1, input$pw2, input$pw3, input$pw4, input$pw5)
            
            # Compute the weighted means for each player
            # Re-computed when one of the inputs changes
            df <- pitcherStats(dtPitcher, weight) 
            
            # Store the new weights
            dfPitcherWeight$Weight <- weight
            write.csv(dfPitcherWeight, "./pitcherWeight.csv", row.names=FALSE)
            
            return(df)
            
          }
          , options=list(info=FALSE, paging=FALSE)
          )
    }
)
