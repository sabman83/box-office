parkway <-
  read.csv("/home/sabman/Projects/box-office/data/parkway-shows-by-performance.csv")
movie_info <-
  read.csv("/home/sabman/Projects/box-office/data/movie_info.csv")
require(data.table)
parkway <- data.table(parkway)
movie_info <- data.table(movie_info)
parkway$imdb_id  <- as.factor(parkway$imdb_id)
require(dplyr)
parkway$num_of_attendees <- parkway$gross / parkway$ticket_price
parkway$num_of_attendees <- round(parkway$num_of_attendees)
parkway$date <- as.Date(parkway$date)
parkway$day  <- weekdays(parkway$date)
parkway$day <- as.factor(parkway$day)
parkway <-
  parkway %>% mutate(avg_attendence = round(num_of_attendees / num_of_shows))

parkway_summarized_by_movie <-
  parkway %>% group_by(imdb_id) %>% mutate(total_attendees = (sum(num_of_attendees)),
                                           total_shows = sum(num_of_shows)) %>% select(imdb_id, total_attendees, total_shows)
parkway_summarized_by_movie <-
  merge(parkway_summarized_by_movie, movie_info, by = "imdb_id")
parkway_summarized_by_movie <-
  parkway %>% group_by(imdb_id) %>% mutate(total_attendees = (sum(num_of_attendees)),
                                           total_shows = sum(num_of_shows)) %>% select(imdb_id, total_attendees, total_shows)
parkway_summarized_by_movie <-
  merge(parkway_summarized_by_movie,
        movie_info,
        by.x = "imdb_id",
        by.y = "imdb_id")
parkway_summarized_by_movie <- unique(parkway_summarized_by_movie)
parkway_for_random_forest <-
  parkway %>% select(imdb_id, day, num_of_shows, num_of_attendees)


library(tidyr)
install.packages("splitstackshape")
library(splitstackshape)
concat.split.expanded(parkway_summarized_by_movie,
                      "genres",
                      ",",
                      type = "character",
                      fill = "0")
movie_info[imdb_id == 'tt2440910']$genres = "Documentary,Adventure"
movie_info[imdb_id == 'tt3385334']$genres = "Adventure,Comedy,Drama,Romance"
movie_info[imdb_id == 'tt3385334']$genres = "Documentary,Crime"
movie_info[imdb_id == 'tt0255549']$genres = "Documentary"
movie_info[imdb_id == 'tt0412886']$genres = "Documentary"
movie_info[imdb_id == 'tt1152399']$genres = "Documentary"
movie_info[imdb_id == 'tt1363482']$genres = "Documentary"
movie_info[imdb_id == 'tt1753666']$genres = "Drama,Family"
movie_info[imdb_id == 'tt2085759']$genres = "Documentary,Biography,Crime,News"
movie_info[imdb_id == 'tt2088883']$genres = "Documentary,Sport"
movie_info[imdb_id == 'tt2111474']$genres = "Documentary"
movie_info[imdb_id == 'tt2181804']$genres = "Documentary"
movie_info[imdb_id == 'tt2273433']$genres = "Documentary,Biography,History,Sport"
movie_info[imdb_id == 'tt2408586']$genres = "Documentary,Adventure"
movie_info[imdb_id == 'tt2663896']$genres = "Documentary"
movie_info[imdb_id == 'tt2689924']$genres = "Documentary,News"
movie_info[imdb_id == 'tt2796836']$genres = "Documentary,Biography,Comedy"
movie_info[imdb_id == 'tt3238136']$genres = "Documentary,Drama"
movie_info[imdb_id == 'tt3246410']$genres = "Documentary,Biography,History"
movie_info[imdb_id == 'tt3301806']$genres = "Documentary"
movie_info[imdb_id == 'tt3378038']$genres = "Documentary,Drama"
movie_info[imdb_id == 'tt3410666']$genres = "Documentary,News,Comedy"
movie_info[imdb_id == 'tt4154170']$genres = "Documentary,Biography,History,Music"
movie_info[imdb_id == 'tt4282926']$genres = "Documentary,Family"
movie_info[imdb_id == 'tt2170509']$genres = "Comedy,Romance"
movie_info[imdb_id == 'tt2186685']$genres = "Documentary,Biography,History"
movie_info[imdb_id == 'tt2458698']$genres = "Documentary,Drama"
movie_info[imdb_id == 'tt3242930']$genres = "Documentary,Drama"
movie_info[imdb_id == 'tt3244466']$genres = "Documentary"
movie_info[imdb_id == 'tt0352014']$genres = "Comedy,Horror"
movie_info[imdb_id == 'tt2180016']$genres = "Documentary,Biography"
movie_info[imdb_id == 'tt2182187']$genres = "Documentary"
movie_info[imdb_id == 'tt2339379']$genres = "Comedy,Drama"
movie_info[imdb_id == 'tt1499958']$genres = "Documentary,Biography,History"
movie_info[imdb_id == 'tt0491587']$genres = "Short,Drama,Music,Musical"
movie_info[imdb_id == 'tt0108448']$genres = "TV Movie,Crime,Drama,Mystery"
movie_info[imdb_id == 'tt1787067']$genres = "Documentary,History"
movie_info[imdb_id == 'tt2073516']$genres = "Drama,Romance"
movie_info[imdb_id == 'tt2079512']$genres = "Documentary,Crime"
movie_info[imdb_id == 'tt2357398']$genres = "Documentary,Biography,Comedy,Music"
movie_info[imdb_id == 'tt4007320']$genres = "Documentary,Action,Adventure,Sport"
movie_info[imdb_id == 'tt4370926']$genres = "Documentary"
movie_info[imdb_id == 'tt4448706']$genres = "Documentary"
movie_info[imdb_id == 'tt4569688']$genres = "Documentary,Crime,Drama"
movie_info[imdb_id == 'tt5140574']$genres = "Documentary"

movie_country  <-
  read.csv("~/Projects/box-office/data/movie_country.csv")
movie_country <- data.table(movie_country)
movie_info <- merge(movie_info, movie_country, by = 'imdb_id')
movie_info$foreign <- ifelse(grepl('USA', movie_info$country), 0, 1)
movie_info$foreign <- as.factor(movie_info$foreign)
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
      if (nchar(mtrx[i, j]) > 0) {
        print(mtrx[i, j])
        awards <- awards + as.numeric(mtrx[i, j])
      }
    }
  }
  return (awards)
}
library(stringr)
wins_col <-
  sapply(as.character(movie_info$awards), num_of_awards, type = "wins")
nmns_col <-
  sapply(as.character(movie_info$awards), num_of_awards, type = "nominations")
movie_info$award_wins <- wins_col
movie_info$award_nominations <- nmns_col
concat.split.expanded(movie_info,
                      "genres",
                      sep = ",",
                      type = "character",
                      fill = 0)
movie_info <-
  concat.split.expanded(movie_info,
                        "genres",
                        sep = ",",
                        type = "character",
                        fill = 0)
movie_info$metascore <-
  (as.numeric(as.character(movie_info$metascore)))
mean(movie_info_for_random_forest$tomato_critic_meter[!is.na(movie_info_for_random_forest$tomato_critic_meter)])
movie_info$tomato_critic_rating <-
  (as.numeric(as.character(movie_info$tomato_critic_rating)))
movie_info$tomato_user_rating <-
  (as.numeric(as.character(movie_info$tomato_user_rating)))
movie_info$tomato_user_votes <-
  (as.numeric(as.character(movie_info$tomato_user_votes)))
movie_info$tomato_critic_votes <-
  (as.numeric(as.character(movie_info$tomato_critic_votes)))
movie_info$tomato_fresh_reviews <-
  (as.numeric(as.character(movie_info$tomato_fresh_reviews)))
movie_info$tomato_rotten_reviews <-
  (as.numeric(as.character(movie_info$tomato_rotten_reviews)))
movie_info$tomato_user_meter <-
  (as.numeric(as.character(movie_info$tomato_user_meter)))
movie_info$tomato_critic_meter <-
  (as.numeric(as.character(movie_info$tomato_critic_meter)))
movie_info_for_random_forest <-
  movie_info %>% select(
    imdb_id,
    budget,
    tmdb_popularity,
    revenue,
    runtime,
    tmdb_rating,
    tmdb_votes,
    metascore,
    genres_Western,
    genres_War,
    `genres_TV Movie`,
    genres_Thriller,
    genres_Sport,
    genres_Short,
    `genres_Science Fiction`,
    genres_Romance,
    genres_News,
    genres_Mystery,
    genres_Musical,
    genres_Music,
    genres_Horror,
    genres_History,
    genres_Foreign,
    genres_Fantasy,
    genres_Family,
    genres_Drama,
    genres_Documentary,
    genres_Crime,
    genres_Comedy,
    genres_Biography,
    genres_Animation,
    genres_Adventure,
    genres_Action,
    award_nominations,
    award_wins,
    foreign,
    tomato_critic_meter,
    tomato_user_meter,
    tomato_rotten_reviews,
    tomato_fresh_reviews,
    tomato_critic_votes,
    tomato_user_votes,
    tomato_user_rating,
    tomato_critic_rating,
    imdb_votes,
    imdb_rating
  )
movie_info$imdb_rating <-
  (as.numeric(as.character(movie_info$imdb_rating)))
movie_info$imdb_votes <-
  (as.numeric(as.character(movie_info$imdb_votes)))
movie_info_for_random_forest <-
  movie_info %>% select(
    imdb_id,
    tmdb_popularity,
    runtime,
    tmdb_rating,
    tmdb_votes,
    metascore,
    genres_Western,
    genres_War,
    `genres_TV Movie`,
    genres_Thriller,
    genres_Sport,
    genres_Short,
    `genres_Science Fiction`,
    genres_Romance,
    genres_News,
    genres_Mystery,
    genres_Musical,
    genres_Music,
    genres_Horror,
    genres_History,
    genres_Foreign,
    genres_Fantasy,
    genres_Family,
    genres_Drama,
    genres_Documentary,
    genres_Crime,
    genres_Comedy,
    genres_Biography,
    genres_Animation,
    genres_Adventure,
    genres_Action,
    award_nominations,
    award_wins,
    foreign,
    tomato_critic_votes,
    tomato_user_votes,
    tomato_user_rating,
    tomato_critic_rating,
    imdb_rating
  )
movie_info_for_random_forest$metascore[is.na(movie_info_for_random_forest$metascore)] <-
  mean(movie_info_for_random_forest$metascore[!is.na(movie_info_for_random_forest$metascore)])
movie_info_for_random_forest$tomato_critic_votes[is.na(movie_info_for_random_forest$tomato_critic_votes)] <-
  0
movie_info_for_random_forest$tomato_user_votes[is.na(movie_info_for_random_forest$tomato_user_votes)] <-
  0
movie_info_for_random_forest$tomato_critic_rating[is.na(movie_info_for_random_forest$tomato_critic_rating)] <-
  mean(movie_info_for_random_forest$tomato_critic_rating[!is.na(movie_info_for_random_forest$tomato_critic_rating)])
movie_info_for_random_forest$tomato_user_rating[is.na(movie_info_for_random_forest$tomato_user_rating)] <-
  mean(movie_info_for_random_forest$tomato_user_rating[!is.na(movie_info_for_random_forest$tomato_user_rating)])
movie_info_for_random_forest$imdb_rating[is.na(movie_info_for_random_forest$imdb_rating)] <-
  mean(movie_info_for_random_forest$imdb_rating[!is.na(movie_info_for_random_forest$imdb_rating)])
movie_info_for_random_forest$genres_War <-
  as.factor(movie_info_for_random_forest$genres_War)
movie_info_for_random_forest$genres_Western <-
  as.factor(movie_info_for_random_forest$genres_Western)
movie_info_for_random_forest$genres_News <-
  as.factor(movie_info_for_random_forest$genres_News)
movie_info_for_random_forest$genres_Sport <-
  as.factor(movie_info_for_random_forest$genres_Sport)
movie_info_for_random_forest$genres_Short <-
  as.factor(movie_info_for_random_forest$genres_Short)
movie_info_for_random_forest$genres_Short <-
  as.factor(movie_info_for_random_forest$`genres_Science Fiction`)
movie_info_for_random_forest$genres_Short <-
  as.factor(movie_info$genres_Short)
movie_info_for_random_forest$`genres_Science Fiction` <-
  as.factor(movie_info_for_random_forest$`genres_Science Fiction`)
movie_info_for_random_forest$genres_Romance <-
  as.factor(movie_info_for_random_forest$genres_Romance)
movie_info_for_random_forest$genres_News <-
  as.factor(movie_info_for_random_forest$genres_News)
movie_info_for_random_forest$genres_Mystery <-
  as.factor(movie_info_for_random_forest$genres_Mystery)
movie_info_for_random_forest$genres_Musical <-
  as.factor(movie_info_for_random_forest$genres_Musical)
movie_info_for_random_forest$genres_Music <-
  as.factor(movie_info_for_random_forest$genres_Music)
movie_info_for_random_forest$genres_Horror <-
  as.factor(movie_info_for_random_forest$genres_Horror)
movie_info_for_random_forest$genres_History <-
  as.factor(movie_info_for_random_forest$genres_History)
movie_info_for_random_forest$genres_Foreign <-
  as.factor(movie_info_for_random_forest$genres_Foreign)
movie_info_for_random_forest$genres_Fantasy <-
  as.factor(movie_info_for_random_forest$genres_Fantasy)
movie_info_for_random_forest$genres_Family <-
  as.factor(movie_info_for_random_forest$genres_Family)
movie_info_for_random_forest$genres_Drama <-
  as.factor(movie_info_for_random_forest$genres_Drama)
movie_info_for_random_forest$genres_Documentary <-
  as.factor(movie_info_for_random_forest$genres_Documentary)
movie_info_for_random_forest$genres_Crime <-
  as.factor(movie_info_for_random_forest$genres_Crime)
movie_info_for_random_forest$genres_Comedy <-
  as.factor(movie_info_for_random_forest$genres_Comedy)
movie_info_for_random_forest$genres_Biography <-
  as.factor(movie_info_for_random_forest$genres_Biography)
movie_info_for_random_forest$genres_Animation <-
  as.factor(movie_info_for_random_forest$genres_Animation)
movie_info_for_random_forest$genres_Adventure <-
  as.factor(movie_info_for_random_forest$genres_Adventure)
movie_info_for_random_forest$genres_Action <-
  as.factor(movie_info_for_random_forest$genres_Action)
summary(movie_info_for_random_forest)
movie_info_for_random_forest$`genres_TV Movie` <-
  as.factor(movie_info_for_random_forest$`genres_TV Movie`)
movie_info_for_random_forest$genres_Thriller <-
  as.factor(movie_info_for_random_forest$genres_Thriller)

parkway_for_random_forest <-
  parkway %>% select(imdb_id, day, avg_attendence)
parkway_for_random_forest <-
  merge(parkway_for_random_forest, movie_info_for_random_forest, by = "imdb_id")
require(rpart)
fit <-
  rpart(avg_attendence ~ ., method = "anova", data = parkway_for_random_forest[, -1])
require(rpart.plot)
rpart.plot(fit)
fit <-
  rpart(avg_attendence ~ ., method = "anova", data = parkway_for_random_forest[, -c(1, 2)])
rpart.plot(fit)
movie_info <-
  concat.split.expanded(movie_info,
                        "keywords",
                        sep = ",",
                        type = "character",
                        fill = 0)
