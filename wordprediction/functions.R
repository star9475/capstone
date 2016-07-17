#load('../data/ngram.Rdata')


library(tm)
library(stringi)

predictbasic4 <-function(input,badwords,unigram_DF, bigramDF, trigramDF, maxResults = 3) {
     sw <- stopwords(kind = "english")
     input <- removePunctuation(input)
     input <- removeNumbers(input)
     input <- rev(unlist(strsplit(input," ")))
     input <- setdiff(input,sw)
     input <- input[grepl('[[:alpha:]]',input)]
     input <- paste(input[2],input[1],sep = ' ')
     input <- tolower(input) 
     if(input == ''|input == "na na") return('No text to predict yet')
     
     seektri<-grepl(paste0("^",input,"$"),trigramDF$bigram)
     subtri<-trigramDF[seektri,]
     input2 <- unlist(strsplit(input," "))[2]
     seekbi <- grepl(paste0("^",input2,"$"),bigramDF$unigram)
     subbi <- bigramDF[seekbi,]
     unigram_DF$s <- unigram_DF$freq/nrow(unigram_DF)*0.16
     useuni <- unigram_DF[order(unigram_DF$s,decreasing = T),]
     useunia <- useuni[1:maxResults,]
     
     if (sum(seektri) == 0) {
          if(sum(seekbi)==0){
               # return(head(unigram_DF[order(unigram_DF$freq,decreasing = T),1],
               #             maxResults))
               cat("Using unigram\n")
               
               #predictWord <- head(unigram_DF, maxResults)
               predictWord <- data.frame(head(unigram_DF, maxResults))
               predictWord$freq <- NULL
              
               cat("here")
               results <- unigram_DF[ 1, unigram]
               cat("here2")
               scores <- unigram_DF[1, s]
               for (i in 2:maxResults) {
                    results <- paste0(results, " ", unigram_DF[ i, unigram] )
               }
               
               #return(results)
               return(head(predictWord, maxResults))
               #return(predictWord)
          }
          cat("Using bigram\n")
          subbi$s <- 0.4*subbi$freq/sum(seekbi)
          names <- c(subbi$name,useunia$unigram)
          score <- c(subbi$s,useunia$s)
          predictWord <- data.frame(next_word=names,score=score,stringsAsFactors = F)
          predictWord <- predictWord[order(predictWord$score,decreasing = T),]
          
          # in case replicated
          final <- unique(predictWord$next_word)
          final <- setdiff(final,badwords)
          final <- final[grepl('[[:alpha:]]',final)]
          final <- final[1:maxResults] 
          
          #return(final)
          return(head(predictWord, maxResults))
     } 
     cat("Using trigram\n")
     
     subbi$s <- 0.4*subbi$freq/sum(seekbi)
     subtri$s <- subtri$freq/sum(subtri$freq)
     names <- c(subtri$name,subbi$name,useunia$unigram)
     score <- c(subtri$s,subbi$s,useunia$s)
     predictWord <- data.frame(next_word=names,score=score,stringsAsFactors = F)
     predictWord <- predictWord[order(predictWord$score,decreasing = T),]
     
     # in case replicated
     final <- unique(predictWord$next_word)
     final <- final[1:maxResults]
     final <- setdiff(final,badwords)
     final <- final[grepl('[[:alpha:]]',final)]        
     #return(final)
     return(head(predictWord, maxResults))
}