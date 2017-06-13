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
  parkway %>% select(imdb_id, day, num_of_shows, num_of_attendees)
parkway_test_for_random_forest <-
  parkway_for_random_forest %>% mutate(avg_attendence = round(num_of_attendees /
                                                                num_of_shows)) %>% select(imdb_id, day, avg_attendence)


movie_info_test <-
  read.csv("/home/sabman/Projects/box-office/data/movie_info.csv")
movie_info_test <- data.table(movie_info_test)
movie_info_test[imdb_id == 'tt2440910']$genres = "Documentary,Adventure"
movie_info_test[imdb_id == 'tt3385334']$genres = "Adventure,Comedy,Drama,Romance"
movie_info_test[imdb_id == 'tt3385334']$genres = "Documentary,Crime"
movie_info_test[imdb_id == 'tt0255549']$genres = "Documentary"
movie_info_test[imdb_id == 'tt0412886']$genres = "Documentary"
movie_info_test[imdb_id == 'tt1152399']$genres = "Documentary"
movie_info_test[imdb_id == 'tt1363482']$genres = "Documentary"
movie_info_test[imdb_id == 'tt1753666']$genres = "Drama,Family"
movie_info_test[imdb_id == 'tt2085759']$genres = "Documentary,Biography,Crime,News"
movie_info_test[imdb_id == 'tt2088883']$genres = "Documentary,Sport"
movie_info_test[imdb_id == 'tt2111474']$genres = "Documentary"
movie_info_test[imdb_id == 'tt2181804']$genres = "Documentary"
movie_info_test[imdb_id == 'tt2273433']$genres = "Documentary,Biography,History,Sport"
movie_info_test[imdb_id == 'tt2408586']$genres = "Documentary,Adventure"
movie_info_test[imdb_id == 'tt2663896']$genres = "Documentary"
movie_info_test[imdb_id == 'tt2689924']$genres = "Documentary,News"
movie_info_test[imdb_id == 'tt2796836']$genres = "Documentary,Biography,Comedy"
movie_info_test[imdb_id == 'tt3238136']$genres = "Documentary,Drama"
movie_info_test[imdb_id == 'tt3246410']$genres = "Documentary,Biography,History"
movie_info_test[imdb_id == 'tt3301806']$genres = "Documentary"
movie_info_test[imdb_id == 'tt3378038']$genres = "Documentary,Drama"
movie_info_test[imdb_id == 'tt3410666']$genres = "Documentary,News,Comedy"
movie_info_test[imdb_id == 'tt4154170']$genres = "Documentary,Biography,History,Music"
movie_info_test[imdb_id == 'tt4282926']$genres = "Documentary,Family"
movie_info_test[imdb_id == 'tt2170509']$genres = "Comedy,Romance"
movie_info_test[imdb_id == 'tt2186685']$genres = "Documentary,Biography,History"
movie_info_test[imdb_id == 'tt2458698']$genres = "Documentary,Drama"
movie_info_test[imdb_id == 'tt3242930']$genres = "Documentary,Drama"
movie_info_test[imdb_id == 'tt3244466']$genres = "Documentary"
movie_info_test[imdb_id == 'tt0352014']$genres = "Comedy,Horror"
movie_info_test[imdb_id == 'tt2180016']$genres = "Documentary,Biography"
movie_info_test[imdb_id == 'tt2182187']$genres = "Documentary"
movie_info_test[imdb_id == 'tt2339379']$genres = "Comedy,Drama"
movie_info_test[imdb_id == 'tt1499958']$genres = "Documentary,Biography,History"
movie_info_test[imdb_id == 'tt0491587']$genres = "Short,Drama,Music,Musical"
movie_info_test[imdb_id == 'tt0108448']$genres = "TV Movie,Crime,Drama,Mystery"
movie_info_test[imdb_id == 'tt1787067']$genres = "Documentary,History"
movie_info_test[imdb_id == 'tt2073516']$genres = "Drama,Romance"
movie_info_test[imdb_id == 'tt2079512']$genres = "Documentary,Crime"
movie_info_test[imdb_id == 'tt2357398']$genres = "Documentary,Biography,Comedy,Music"
movie_info_test[imdb_id == 'tt4007320']$genres = "Documentary,Action,Adventure,Sport"
movie_info_test[imdb_id == 'tt4370926']$genres = "Documentary"
movie_info_test[imdb_id == 'tt4448706']$genres = "Documentary"
movie_info_test[imdb_id == 'tt4569688']$genres = "Documentary,Crime,Drama"
movie_info_test[imdb_id == 'tt5140574']$genres = "Documentary"

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


data_for_xgboost <- merge(parkway_for_random_forest, movie_info_for_random_forest, by = "imdb_id")
data_for_xgboost <- unique(data_for_xgboost)

#remove genres, keywords
data_for_xgboost <- data_for_xgboost[,-c(12,13)]

#convert columns to numeric for xgboost
data_for_xgboost[['foreign']] <- as.numeric(levels(data_for_xgboost[['foreign']]))[data_for_xgboost[['foreign']]]

#columns highly correlated columns
correlation_matrix <- cor(data_for_xgboost[,-c(1,2)])
zdf <-  as.data.table(as.table(correlation_matrix))
View(zdf[N>0.8 & N<1])


# require(rpart)
# fit <-
#   rpart(avg_attendence ~ ., method = "anova", data = parkway_for_xgboost[,-1])
# require(rpart.plot)
# rpart.plot(fit)
# fit <-
#   rpart(avg_attendence ~ ., method = "anova", data = parkway_for_xgboost[,-c(1, 2)])
# rpart.plot(fit)



#xgboost
train_indices  <- sample(seq_len(nrow(data_for_xgboost)), size = floor(0.75 * nrow(data_for_xgboost)))
train <- data_for_xgboost[train_indices,]
test <- data_for_xgboost[-train_indices,]
dtrain <- xgb.DMatrix(data.matrix(train[,-c(1,3)]), label=train[,3])
dtest <- data.matrix(test[,-c(1,3)])
xgboost_model  <- xgboost(data = dtrain, nrounds = 25, booster="gbtree", max.depth = 5, eta=0.1, objective="reg:linear")
xgb.plot.importance(xgb.importance(colnames(dtrain),model = xgboost_model))

pred <- predict(xgboost_model, dtest)
mean(abs(pred - test$avg_attendence))
sqrt(mean((pred - test$avg_attendence)^2))

cv_data <- xgb.DMatrix(data.matrix(data_for_xgboost[,-c(1,3)]), label=data_for_xgboost[,3])
params = list(nrounds = 40, booster="gbtree", max.depth = 5, eta=0.3, objective="reg:linear")
cv_result  <- xgb.cv(params, cv_data, nrounds = 40,nfold = 5, verbose = TRUE, prediction = TRUE)

#making valid column names
setnames(data_mlr,names(data_mlr),make.names(names(data_mlr), unique = FALSE, allow_ = TRUE))
setnames(data_mlr,"keywords.fiancé","keywords.fiance")
setnames(data_mlr,"keywords.fiancé.fiancée.relationship","keywords.fiance.fiancee.relationship")
setnames(data_mlr,"keywords.mentor.protégé.relationship","keywords.mentor.protege.relationship")
setnames(data_mlr,"keywords.pokémon","keywords.pokemon")
setnames(data_mlr,"keywords.straßenkids","keywords.strabenkids")

