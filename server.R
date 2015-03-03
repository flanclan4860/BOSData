

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
