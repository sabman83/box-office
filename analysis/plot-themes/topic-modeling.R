library("topicmodels")
library(tm)
library(tidytext)
library(SnowballC)
movie_info_corpus <- read.csv("~/Projects/box-office/topic-modeling/movie_info.csv")
doc.vec<-VectorSource(as.character(movie_info_corpus[,1]))
doc.corpus<-Corpus(doc.vec)
doc.corpus <- tm_map(doc.corpus, tolower)
doc.corpus <- tm_map(doc.corpus, removePunctuation)
doc.corpus <- tm_map(doc.corpus, removeNumbers)
doc.corpus <- tm_map(doc.corpus, removeWords, stopwords("english"))
doc.corpus <- tm_map(doc.corpus, stripWhitespace)
DTM <- DocumentTermMatrix(doc.corpus)
doc.lda<- LDA(DTM[rowTotals>0,], k = 20, control = list(seed = 1234))
doc.topics <- tidy(doc.lda, matrix = "beta")
doc.top_terms <- doc.topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)
doc.top_terms <- doc.topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)
doc.top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()