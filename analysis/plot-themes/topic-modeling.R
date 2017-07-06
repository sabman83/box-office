#based on http://davidmeza1.github.io/2015/07/20/topic-modeling-in-R.html
library("topicmodels")
library(tm)
library(tidytext)
library(SnowballC)
library(dplyr)
library(Rmpfr)

movie_info_corpus <-
  read.csv("~/Projects/box-office/topic-modeling/movie_info.csv")

m <- list(content = "plot", id = "imdb_id")
movie.corpus <-
  tm::Corpus(tm::DataframeSource(movie_info_corpus),
             readerControl = list(reader = tm::readTabular(mapping = m)))
movie.corpus <- tm_map(movie.corpus, removeWords, stop_words$word)
movie.corpus <- tm_map(movie.corpus, removeWords, c(
  "actor", "actress","again"
)) # TODO: remove other common words like these
movie.dtm <-
  tm::DocumentTermMatrix(
    movie.corpus,
    control = list(
      stemming = TRUE,
      stopwords = TRUE,
      minWordLength = 2,
      removeNumbers = TRUE,
      removePunctuation = TRUE
    )
  )
str(movie.dtm)
term_tfidf <-
  tapply(movie.dtm$v / slam::row_sums(movie.dtm)[movie.dtm$i], movie.dtm$j, mean) *
  log2(tm::nDocs(movie.dtm) / slam::col_sums(movie.dtm > 0))
summary(term_tfidf)
movie.reduced.dtm <- movie.dtm[, term_tfidf >= 0.6882] #use median from above result to keep most useful terms

#find optimal value for k using harmonic mean as described here: http://epub.wu.ac.at/3558/1/main.pdf
seqk <- seq(2, 50, 1)
burnin <- 1000
iter <- 1000
keep <- 50
system.time(fitted_many <-
              lapply(seqk, function(k)
                topicmodels::LDA(
                  movie.reduced.dtm[rowTotals > 0,],
                  k = k,
                  method = "Gibbs",
                  control = list(
                    burnin = burnin,
                    iter = iter,
                    keep = keep
                  )
                )))

logLiks_many <-
  lapply(fitted_many, function(L)
    L@logLiks[-c(1:(burnin / keep))])
hm_many <- sapply(logLiks_many, function(h)
  harmonicMean(h))
ldaplot <-
  ggplot(data.frame(seqk, hm_many), aes(x = seqk, y = hm_many)) + geom_path(lwd =
                                                                              1.5) +
  theme(
    text = element_text(family = NULL),
    axis.title.y = element_text(vjust = 1, size = 16),
    axis.title.x = element_text(vjust = -.5, size = 16),
    axis.text = element_text(size = 16),
    plot.title = element_text(size = 20)
  ) +
  xlab('Number of Topics') +
  ylab('Harmonic Mean') +
  annotate(
    "text",
    x = 25,
    y = -80000,
    label = paste("The optimal number of topics is", seqk[which.max(hm_many)])
  ) +
  ggtitle(expression(atop(
    "Latent Dirichlet Allocation Analysis of NEN LLIS",
    atop(italic("How many distinct topics in the abstracts?"), "")
  )))
ldaplot


rowTotals <- apply(movie.reduced.dtm , 1, sum)
movie.model <-
  topicmodels::LDA(
    movie.reduced.dtm[rowTotals > 0,],
    23, #use value as shown in ldaplot above
    method = "Gibbs",
    control = list(iter = 2000, seed = 0622)
  )

#visualize model
library(LDAvis)
topicmodels_json_ldavis <- function(fitted, corpus, doc_term) {
  ## Required packages
  library(topicmodels)
  library(dplyr)
  library(stringi)
  library(tm)
  library(LDAvis)
  ## Find required quantities
  phi <- posterior(fitted)$terms %>% as.matrix
  theta <- posterior(fitted)$topics %>% as.matrix
  vocab <- colnames(phi)
  doc_length <- vector()
  for (i in 1:length(corpus)) {
    temp <- paste(corpus[[i]]$content, collapse = ' ')
    doc_length <- c(doc_length, stri_count(temp, regex = '\\S+'))
  }
  #temp_frequency <- inspect(doc_term)
  #freq_matrix <- data.frame(ST = colnames(temp_frequency),
  #Freq = colSums(temp_frequency))
  #rm(temp_frequency)
  freq_matrix <- data.frame(ST = colnames(doc_term),
                            Freq = slam::col_sums(doc_term))
  ## Convert to json
  json_lda <- LDAvis::createJSON(
    phi = phi,
    theta = theta,
    vocab = vocab,
    doc.length = doc_length,
    term.frequency = freq_matrix$Freq
  )
  return(json_lda)
}

theta <- posterior(movie.model)$topics %>% as.matrix
movie.reduced.corpus <-
  tm::Corpus(
    tm::DataframeSource(movie_info_original[imdb_id %in% row.names(theta)]),
    readerControl = list(reader = tm::readTabular(mapping = m))
  )

movie.json <-
  topicmodels_json_ldavis(movie.model, movie.reduced.corpus, movie.reduced.dtm[rowTotals >
                                                                                 0,])
serVis(movie.json)



#explore model

movie.topics <- topicmodels::topics(movie.model, 1)
movie.terms <-
  as.data.frame(topicmodels::terms(movie.model, 30), stringsAsFactors = FALSE)

movietopics.df <- as.data.frame(movie.topics)
movietopics.df <-
  dplyr::transmute(movietopics.df,
                   imdb_id = rownames(movietopics.df),
                   Topic = movie.topics)
movie_info_corpus <-
  dplyr::inner_join(movie_info_corpus, movietopics.df, by = "imdb_id")

topicTerms <- tidyr::gather(movie.terms, Topic)
topicTerms <- cbind(topicTerms, Rank = rep(1:30))
topTerms <- dplyr::filter(topicTerms, Rank < 4)
topTerms <- dplyr::mutate(topTerms, Topic = stringr::word(Topic, 2))
topTerms$Topic <- as.numeric(topTerms$Topic)
topicLabel <- data.frame()
for (i in 1:22) {
  z <- dplyr::filter(topTerms, Topic == i)
  l <-
    as.data.frame(paste(z[1, 2], z[2, 2], z[3, 2], sep = " "), stringsAsFactors = FALSE)
  topicLabel <- rbind(topicLabel, l)
}
colnames(topicLabel) <- c("Label")
topicLabel
theta <- as.data.frame(topicmodels::posterior(movie.model)$topics)
