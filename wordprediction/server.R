#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(wordcloud)
library(RColorBrewer)

source("functions.R", local=TRUE)
load('data/ngrams.RData')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  # output$distPlot <- renderPlot({
  #   
  #   # generate bins based on input$bins from ui.R
  #   x    <- faithful[, 2] 
  #   bins <- seq(min(x), max(x), length.out = input$bins + 1)
  #   
  #   # draw the histogram with the specified number of bins
  #   hist(x, breaks = bins, col = 'darkgray', border = 'white')
  #   
  # })
  
     output$wordcloudPlot <- renderPlot({

          if(nchar(input$predictText)) {
               results <- predictbasic4(input$predictText,"shit",unigram_datatable, bigram_datatable, trigram_datatable, maxResults = input$numResults)
               names(results)[1]<-paste("word")
               names(results)[2]<-paste("score")
               
               pal2 <- brewer.pal(8,"Dark2")
               wordcloud(results$word, results$score, max.words = input$numResults, random.order = FALSE, colors=pal2)
          }
     })
          
  #output$value <- renderPrint({ input$text })
  #output$value <- renderPrint({ input$action })
  
  output$predictText <- renderText({
       #paste("Input text is:", input$text)
       paste("Input text is:", input$predictText)
  })
  
  output$predictText1 <- renderText({
       #results <- predict0("The quick brown fox","shit",unigramDF, bigramDF, trigramDF, maxResults = 1)
       #results <- predict0(input$predictText,"shit",unigramDF, bigramDF, trigramDF, maxResults = 1)
       #results <- predictbasic(input$predictText,"shit",unigramDF, bigramDF, trigramDF, maxResults = input$numResults)
       if(nchar(input$predictText)) {
            results <- predictbasic4(input$predictText,"shit",unigram_datatable, bigram_datatable, trigram_datatable, maxResults = input$numResults)
            names(results)[1]<-paste("word")
            names(results)[2]<-paste("score")
            resultsText <- results[1,1]
            if (length(results[,1]) > 1) {
                 for (i in 2:length(results[,1])) {
                      resultsText <- paste(resultsText, results[i,1], sep=",")
                 }
            }
            paste("Prediction text is: ", resultsText)
       }
  })
  # observe({
  #      # Run whenever reset button is pressed
  #      input$predict
  #      
  #      # Send an update to my_url, resetting its value
  #      #updateUrlInput(session, "my_url", value = "http://www.r-project.org/")
  #      output$value <- renderPrint({ input$text })
  #      #output$value <- renderPrint({ "TEST BUTTON" })
  #      
  #      output$predictText <- renderText({
  #           #as.character(input$predict)
  #           as.character(input$text)
  #      })
  # })

})
