library('plyr')
library(data.table)
library(tidyr)
library(plyr)
setwd('~/Projects/box-office/data/')

parkway <- read.csv('parkway-shows-by-performance.csv')
parkway <- data.table(parkway)
parkway$date <- as.Date(parkway$date)
keep_columns = c('imdb_id','gross','date','num_of_shows','ticket_price')
parkway <- subset(parkway,select = keep_columns)
parkway$day <- weekdays(parkway$date)
parkway$day <- as.factor(parkway$day)
parkway$attendees_per_show <- parkway[parkway$gross/parkway$num_of_shows/parkway$ticket_price]
summary(parkway)

summarized_parkway <- ddply(parkway, c('imdb_id'), summarise, avg_num_of_attendees = mean(num_of_attendees), num_of_shows=sum(num_of_shows))
View(summarized_parkway)

movie_info <- read.csv('movie_info.csv')
movie_info$tmdb_id <- NULL
movie_info$imdb_id.1 <- NULL
movie_info$release_date <- as.Date(movie_info$release_date)
movie_info$tomato_critic_rating <- as.numeric(as.character(movie_info$tomato_critic_rating))
movie_info$tomato_user_rating <- as.numeric(as.character(movie_info$tomato_user_rating))
movie_info$tomato_user_votes <- as.numeric(as.character(movie_info$tomato_user_votes))
movie_info$tomato_critic_votes <- as.numeric(as.character(movie_info$tomato_critic_votes))
movie_info$tomato_fresh_reviews <- as.numeric(as.character(movie_info$tomato_fresh_reviews))
movie_info$tomato_rotten_reviews <- as.numeric(as.character(movie_info$tomato_rotten_reviews))
movie_info$tomato_user_meter <- as.numeric(as.character(movie_info$tomato_user_meter))
movie_info$tomato_critic_meter <- as.numeric(as.character(movie_info$tomato_critic_meter))
movie_info$imdb_rating <- as.numeric(as.character(movie_info$imdb_rating))
movie_info$metascore <- as.numeric(as.character(movie_info$metascore))
movie_info  <- data.table(movie_info)
wins_col <- sapply(as.character(movie_info$awards), num_of_awards, type="wins")
nmns_col <- sapply(as.character(movie_info$awards), num_of_awards, type="nominations")
movie_info$award_wins <- wins_col
movie_info$award_nominations <- nmns_col
summary(movie_info)

summarized_parkway_with_info <- join(summarized_parkway,movie_info, by="imdb_id")
View(summarized_parkway_with_info)

parkway_in_2013 = parkway[parkway$date <= as.Date("2013-12-31")]
parkway_in_2014 = parkway[(parkway$date >= as.Date("2014-01-01") & parkway$date <= as.Date("2014-12-31"))]
parkway_in_2015 = parkway[(parkway$date >= as.Date("2015-01-01"))]
parkway_by_the_years <- data.table(c('year','num_of_shows', 'num_of_attendees'))
parkway_by_the_years[1,1] <- 2013
parkway_by_the_years[1,2] <- sum(parkway_in_2013$num_of_shows)
parkway_by_the_years[1,3] <- sum(parkway_in_2013$num_of_attendees)
parkway_by_the_years[2,2] <- sum(parkway_in_2014$num_of_shows)
parkway_by_the_years[2,3] <- sum(parkway_in_2014$num_of_attendees)
parkway_by_the_years[2,1] <- 2014
parkway_by_the_years[3,1] <- 2015
parkway_by_the_years[3,3] <- sum(parkway_in_2015$num_of_attendees)
parkway_by_the_years[3,2] <- sum(parkway_in_2015$num_of_shows)
parkway_by_the_years[,avg_num_of_attendees := num_of_attendees/num_of_shows]
View(parkway_by_the_years)

opening_dates = parkway[,.(opening_date = min(date)), by='imdb_id']
parkway <- join(parkway, opening_dates, by="imdb_id")
parkway <- transform(parkway, nth_day = date-opening_date)
parkway_with_movie_info <- join(parkway, movie_info, by='imdb_id')
parkway_with_movie_info <- transform(parkway_with_movie_info, day_since_release = opening_date-release_date)
parkway_with_movie_info <- mutate(parkway_with_movie_info, actor = strsplit(as.character(actors), ","))
parkway_with_movie_info <- unnest(parkway_with_movie_info, actor)
parkway_with_movie_info <- mutate(parkway_with_movie_info, keyword = strsplit(as.character(keywords), ","))
parkway_with_movie_info <- unnest(parkway_with_movie_info, keyword)

best_overall_performers = parkway_with_movie_info[parkway_with_movie_info$attendees_per_show >= (mean(parkway_with_movie_info$attendees_per_show) + (2 * sd(parkway_with_movie_info$attendees_per_show))),]
best_recent_movie_peformers <- best_overall_performers[best_overall_performers$day_since_release < 365]
best_recent_movie_peformers_summarized <- summarise(group_by(best_recent_movie_peformers, imdb_id, date), num_of_shows= mean(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(nth_day))
best_recent_movie_peformers_summarized <- summarise(group_by(best_recent_movie_peformers_summarized, imdb_id), num_of_shows= sum(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(avg_nth_day))
View(best_recent_movie_peformers_summarized)

good_overall_performers = parkway_with_movie_info[(parkway_with_movie_info$attendees_per_show > (mean(parkway_with_movie_info$attendees_per_show) + (1 * sd(parkway_with_movie_info$attendees_per_show)))) & (parkway_with_movie_info$attendees_per_show < (mean(parkway_with_movie_info$attendees_per_show) + (2 * sd(parkway_with_movie_info$attendees_per_show)))),]
good_recent_movie_peformers <- good_overall_performers[good_overall_performers$day_since_release < 365]
good_recent_movie_peformers_summarized <- summarise(group_by(good_recent_movie_peformers, imdb_id, date), num_of_shows= mean(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(nth_day))
good_recent_movie_peformers_summarized <- summarise(group_by(good_recent_movie_peformers_summarized, imdb_id), num_of_shows= sum(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(nth_day))
good_recent_movie_peformers_summarized <- summarise(group_by(good_recent_movie_peformers_summarized, imdb_id), num_of_shows= sum(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(avg_nth_day))
good_recent_movie_peformers_summarized <- join(good_recent_movie_peformers_summarized, movie_info)
average_overall_performers = parkway_with_movie_info[(parkway_with_movie_info$attendees_per_show >= (mean(parkway_with_movie_info$attendees_per_show))) & (parkway_with_movie_info$attendees_per_show < (mean(parkway_with_movie_info$attendees_per_show) + (1 * sd(parkway_with_movie_info$attendees_per_show)))),]
average_recent_movie_peformers <- average_overall_performers[average_overall_performers$day_since_release < 365]
average_recent_movie_peformers_summarized <- summarise(group_by(average_recent_movie_peformers, imdb_id, date), num_of_shows= mean(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(nth_day))
average_recent_movie_peformers_summarized <- summarise(group_by(average_recent_movie_peformers_summarized, imdb_id), num_of_shows= sum(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(nth_day))
average_recent_movie_peformers_summarized <- summarise(group_by(average_recent_movie_peformers_summarized, imdb_id), num_of_shows= sum(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(avg_nth_day))
average_recent_movie_peformers_summarized <- join(average_recent_movie_peformers_summarized, movie_info)
poor_overall_performers = parkway_with_movie_info[(parkway_with_movie_info$attendees_per_show < (mean(parkway_with_movie_info$attendees_per_show))),]
poor_recent_movie_peformers <- poor_overall_performers[poor_overall_performers$day_since_release < 365]
poor_recent_movie_peformers_summarized <- summarise(group_by(poor_recent_movie_peformers, imdb_id, date), num_of_shows= mean(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(nth_day))
poor_recent_movie_peformers_summarized <- summarise(group_by(poor_recent_movie_peformers_summarized, imdb_id), num_of_shows= sum(num_of_shows), attendees_per_show=mean(attendees_per_show), avg_nth_day = mean(avg_nth_day))
poor_recent_movie_peformers_summarized <- join(poor_recent_movie_peformers_summarized, movie_info)



best_overall_performers = parkway[parkway$num_of_attendees >= (mean(parkway$num_of_attendees) + (2 * sd(parkway$num_of_attendees))),]
summarized_best_overall_performers <- ddply(best_overall_performers, c('imdb_id'), summarise, num_of_shows = sum(num_of_shows), avg_num_of_attendees = mean(num_of_attendees))
summarized_best_overall_performers <- join(summarized_best_overall_performers, movie_info, by="imdb_id")
