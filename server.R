
# Application: BOSData
# Filename: server.R
# Contains render functions for BOSData app

# There are two tables, one for hitters and one for pitchers
# When the user changes the weight factor inputs, the stats are recalculated

shinyServer(
  
    function(input,output,session){        
         
         # Display Projected Stats Table for hitters
          output$hittersTable <- renderDataTable({
               
              # Store new weight factors (from user input) 
               dtHitter <- dtHitter %>% 
                           mutate(Weight=inputHitterWeight(Source, input))
            
               # Write the new weights to file
               hitterSourceInfo <- hitterSourceInfo %>% 
                                   mutate(Weight=inputHitterWeight(Num, input))
               dtSourceInfo <- rbind(pitcherSourceInfo, hitterSourceInfo)
               write.csv(dtSourceInfo, sourceInfoFile, row.names=FALSE)
               
               # Compute the weighted means for each player
               # Re-computed when one of the inputs changes
               df <- data.frame(hitterStats()) 
               return(df)
          }
          , options=list(info=FALSE, paging=FALSE)
          )
          
          # Display Projected Stats Table for pitchers
          output$pitcherTable <- renderDataTable({
            
               # Store new weight factors (from user input) 
               dtPitcher <- dtPitcher %>% 
                            mutate(Weight=inputPitcherWeight(Source, input)) 
            
               # Write the new weights to file
               pitcherSourceInfo <- pitcherSourceInfo %>% 
                                mutate(Weight=inputPitcherWeight(Num, input))
            
               dtSourceInfo <- rbind(pitcherSourceInfo, hitterSourceInfo)
               write.csv(dtSourceInfo, sourceInfoFile, row.names=FALSE)
            
               # Compute the weighted means for each player
               # Re-computed when one of the inputs changes
               df <- data.frame(pitcherStats()) 
               return(df)
            
          }
          , options=list(info=FALSE, paging=FALSE)
          )
    }
)
