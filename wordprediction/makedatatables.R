library(quanteda)
library(ggplot2)
library(stringi)
library(dplyr)
library(data.table)

#samplesize <- .01
samplesize <- .01
set.seed(1556)

news_data <- readLines("data/final/en_US/en_US.news.txt", skipNul=TRUE,encoding="UTF-8")
news_data_length <- length(news_data)
news_data_train <- sample(news_data, size = news_data_length * samplesize, replace = FALSE)

twitter_data <- readLines("data/final/en_US/en_US.twitter.txt", skipNul=TRUE,encoding="UTF-8")
twitter_data_length <- length(twitter_data)
twitter_data_train <- sample(twitter_data, size = twitter_data_length * samplesize, replace = FALSE)
# 
blogs_data <- readLines("data/final/en_US/en_US.blogs.txt", skipNul=TRUE,encoding="UTF-8")
blogs_data_length <- length(blogs_data)
blogs_data_train <- sample(blogs_data, size = blogs_data_length * samplesize, replace = FALSE)

train <-  c(news_data_train, blogs_data_train, twitter_data_train)
corpus <- corpus(train)

## create 3-gram datatable
dfm <- dfm(corpus,
           removeNumbers=TRUE,  removePunct=TRUE,  removeSeparators=TRUE,
           removeTwitter=TRUE,  ngrams = 3, concatenator = " ")

# calculate n-gram frequency and sort n-grams according to frequency
trigram_datatable <- data.table(trigram=colnames(dfm), freq=colSums(dfm)) %>% arrange(desc(freq))

temp <- trigram_datatable$trigram
name <- ""
bigram <- ""
for (i in 1:length(temp)) {
     name[i] <- unlist(strsplit(temp[i], " "))[3]
     bigram[i] <- paste0(unlist(strsplit(temp[i], " "))[1], " ", unlist(strsplit(temp[i], " "))[2])
}
trigram_datatable$name <- name
trigram_datatable$bigram <- bigram


## create 2-gram datatable
dfm <- dfm(corpus,
           removeNumbers=TRUE,  removePunct=TRUE,  removeSeparators=TRUE,
           removeTwitter=TRUE,  ngrams = 2, concatenator = " ")

# calculate n-gram frequency and sort n-grams according to frequency
bigram_datatable <- data.table(bigram=colnames(dfm), freq=colSums(dfm)) %>% arrange(desc(freq))
temp <- bigram_datatable$bigram
name <- ""
unigram <- ""
for (i in 1:length(temp)) {
     name[i] <- unlist(strsplit(temp[i], " "))[2]
     unigram[i] <- unlist(strsplit(temp[i], " "))[1]
}
bigram_datatable$name <- name
bigram_datatable$unigram <- unigram

## create 1-gram datatable
dfm <- dfm(corpus,
           removeNumbers=TRUE,  removePunct=TRUE,  removeSeparators=TRUE,
           removeTwitter=TRUE,  ngrams = 1, concatenator = " ")

# calculate n-gram frequency and sort n-grams according to frequency
unigram_datatable <- data.table(unigram=colnames(dfm), freq=colSums(dfm)) %>% arrange(desc(freq))


## create 4-gram datatable
dfm <- dfm(corpus,
           removeNumbers=TRUE,  removePunct=TRUE,  removeSeparators=TRUE,
           removeTwitter=TRUE,  ngrams = 4, concatenator = " ")

# calculate n-gram frequency and sort n-grams according to frequency
quadgram_datatable <- data.table(quadgram=colnames(dfm), freq=colSums(dfm)) %>% arrange(desc(freq))
temp <- quadgram_datatable$quadgram
name <- ""
trigram <- ""
for (i in 1:length(temp)) {
     name[i] <- unlist(strsplit(temp[i], " "))[4]
     trigram[i] <- paste0(unlist(strsplit(temp[i], " "))[1], " ", unlist(strsplit(temp[i], " "))[2], " ", unlist(strsplit(temp[i], " "))[3])
}
quadgram_datatable$name <- name
quadgram_datatable$trigram <- trigram



save(unigram_datatable,bigram_datatable,trigram_datatable,file='data/ngrams.RData')
save(corpus, file='data/corpus.RData')

