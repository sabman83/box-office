require(data.table)
library(tidyr)
library(splitstackshape)
require(dplyr)
library(stringr)
library(foreach)
require(xgboost)

num_of_awards <- function(str, type) {
  if (type == 'wins') {
    pattern <- "Won (\\d+)|won (\\d+)|(\\d+) win|(\\d+) Win"
  } else if (type == 'nominations') {
    pattern <-
      "Nominated for (\\d+)|nominated for (\\d+)|(\\d+) Nominations|(\\d+) nominations"
  } else {
    stop('invalid award type')
  }
  str <- toString(str)
  awards <- 0
  if (nchar(str) == 0) {
    return(awards)
  }
  matches <- str_match_all(str, pattern)
  mtrx <- matches[[1]]
  if ((nrow(mtrx) == 0) | (ncol(mtrx) == 0)) {
    return(awards)
  }
  for (i in 1:nrow(mtrx)) {
    for (j in 2:ncol(mtrx)) {
      if (!is.na(mtrx[i, j]) & nchar(mtrx[i, j]) > 0) {
        print(mtrx[i, j])
        awards <- awards + as.numeric(mtrx[i, j])
      }
    }
  }
  return (awards)
}

parkway_test <-
  read.csv("/home/sabman/Projects/box-office/data/parkway_test_data_2016.csv")
parkway_test <- data.table(parkway_test)
parkway_test$imdb_id  <- as.factor(parkway_test$imdb_id)
parkway_test$num_of_attendees <- parkway_test$gross / parkway_test$ticket_price
parkway_test$num_of_attendees <- round(parkway_test$num_of_attendees)
parkway_test$date <- as.Date(parkway_test$date)
parkway_test$day  <- weekdays(parkway_test$date)
parkway_test$day <- as.factor(parkway_test$day)

#data correction: some movies show more than 150 in attendence. 
#This is not possible and only happends when both theaters showed the same movie at the same time.
parkway_test[parkway_test$num_of_attendees>150,]$num_of_shows <- 2

parkway_test <-
  parkway_test %>% mutate(avg_attendence = round(num_of_attendees / num_of_shows))

parkway_test_for_random_forest <-
  parkway_test %>% select(imdb_id, day, num_of_shows, num_of_attendees)
parkway_test_for_random_forest <-
  parkway_test_for_random_forest %>% mutate(avg_attendence = round(num_of_attendees /
                                                                num_of_shows)) %>% select(imdb_id, day, avg_attendence)


movie_info_test <-
  read.csv("/home/sabman/Projects/box-office/data/movie_info_test_data_2016.csv")
movie_info_test <- data.table(movie_info_test)


wins_col <-
  sapply(as.character(movie_info_test$awards), num_of_awards, type = "wins")
nmns_col <-
  sapply(as.character(movie_info_test$awards), num_of_awards, type = "nominations")
movie_info_test$award_wins <- wins_col
movie_info_test$award_nominations <- nmns_col


movie_info_test$metascore <-
  (as.numeric(as.character(movie_info_test$metascore)))
movie_info_test$tomato_critic_rating <-
  (as.numeric(as.character(movie_info_test$tomato_critic_rating)))
movie_info_test$tomato_user_rating <-
  (as.numeric(as.character(movie_info_test$tomato_user_rating)))
movie_info_test$tomato_user_votes <-
  (as.numeric(as.character(movie_info_test$tomato_user_votes)))
movie_info_test$tomato_critic_votes <-
  (as.numeric(as.character(movie_info_test$tomato_critic_votes)))
movie_info_test$tomato_fresh_reviews <-
  (as.numeric(as.character(movie_info_test$tomato_fresh_reviews)))
movie_info_test$tomato_rotten_reviews <-
  (as.numeric(as.character(movie_info_test$tomato_rotten_reviews)))
movie_info_test$tomato_user_meter <-
  (as.numeric(as.character(movie_info_test$tomato_user_meter)))
movie_info_test$tomato_critic_meter <-
  (as.numeric(as.character(movie_info_test$tomato_critic_meter)))
movie_info_test$imdb_rating <-
  (as.numeric(as.character(movie_info_test$imdb_rating)))
movie_info_test$imdb_votes <-
  (as.numeric(as.character(movie_info_test$imdb_votes)))
movie_info_test$foreign <- ifelse(grepl('USA', movie_info_test$country), 0, 1)
movie_info_test$foreign <- as.factor(movie_info_test$foreign)

movie_info_test_for_random_forest <-
  movie_info_test %>% select(
    imdb_id,
    tmdb_popularity,
    runtime,
    tmdb_rating,
    tmdb_votes,
    metascore,
    award_nominations,
    award_wins,
    foreign,
    genres,
    keywords,
    tomato_critic_votes,
    tomato_user_votes,
    tomato_user_rating,
    tomato_critic_rating,
    imdb_rating
  )
movie_info_test_for_random_forest <-
  concat.split.expanded(
    movie_info_test_for_random_forest,
    "genres",
    sep = ",",
    type = "character",
    fill = 0
  )
movie_info_test_for_random_forest <-
  concat.split.expanded(
    movie_info_test_for_random_forest,
    "keywords",
    sep = ",",
    type = "character",
    fill = 0
  )


data_test_for_xgboost <- merge(parkway_test_for_random_forest, movie_info_test_for_random_forest, by = "imdb_id")
data_test_for_xgboost <- unique(data_test_for_xgboost)

#remove genres, keywords
data_test_for_xgboost <- data_test_for_xgboost[,-c(12,13)]

#convert columns to numeric for xgboost
data_test_for_xgboost[['foreign']] <- as.numeric(levels(data_test_for_xgboost[['foreign']]))[data_test_for_xgboost[['foreign']]]