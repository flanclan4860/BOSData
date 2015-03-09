
# Filename: server.R
# Contains render functions for BOSData app

# There are two tables, one for hitters and one for pitchers
# When the user changes the weight factor inputs, the stats are recalculated

shinyServer(
  
    function(input,output,session){        
         
         # Output Projected Stats Table for hitters
          output$hittersTable <- renderDataTable({
               
              # Updata data table with weight factors from user input
               dtHitter <- dtHitter %>% 
                           mutate(Weight=inputHitterWeight(Source, input))
               # Compute the weighted means for each player
               # Re-computed when one of the inputs changes
               df <- data.frame(hitterStats()) 
               
               # Store the new weights
               hitterSource <- hitterSource %>% 
                               mutate(Weight=inputHitterWeight(Num, input))
               
               dtSource <- rbind(pitcherSource, hitterSource)
               write.csv(dtSource, "./dtSource.csv", row.names=FALSE)
               
               return(df)
          }
          , options=list(info=FALSE, paging=FALSE)
          )
          
          output$pitcherTable <- renderDataTable({
            
            # Updata data table with weight factors from user input
            dtPitcher <- dtPitcher %>% 
                         mutate(Weight=inputPitcherWeight(Source, input))
            
            # Compute the weighted means for each player
            # Re-computed when one of the inputs changes
            df <- data.frame(pitcherStats()) 
            
            # Store the new weights
            pitcherSource <- pitcherSource %>% 
                             mutate(Weight=inputPitcherWeight(Num, input))
            
            dtSource <- rbind(pitcherSource, hitterSource)
            write.csv(dtSource, "./dtSource.csv", row.names=FALSE)
            
            return(df)
            
          }
          , options=list(info=FALSE, paging=FALSE)
          )
    }
)
