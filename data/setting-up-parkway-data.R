my_vector <- c(1:20)
my_vector <- 1:20
my_vector
dim(my_vector)
length(my_vector)
dim(my_vector) <- c(4, 5)
length(my_vector)
dim(my_vector)
attributes(my_vector)
my_vector
class(my_vector)
my_matrix <- my_vector
?matrix
matrix(1:20,4,5)
my_matrix2 <- matrix(1:20,4,5)
identical(my_matrix,my_matrix2)
patients<- c('Bill', 'Gina', 'Kelly')
patients<- c('Bill', 'Gina', 'Kelly','Sean')
cbind(patients,my_matrix)
my_data <- data.frame(patients,my_matrix)
my_data
class(my_data)
cnames <- ("patient", "age", "weight", "bp",
"rating", "test")
cnames <- ("patient", "age", "weight", "bp",rating", "test")
cnames <- ("patient", "age", "weight", "bp","rating", "test")
cnames <- c("patient", "age", "weight", "bp","rating", "test")
colnames(my_data)
colnames(my_data) <- cnames
my_data
skip()
skip()
skip()
skip()
skip()
skip()
skip()
main()
main()
Sys.Date()
mean
mean(c(2,4,5))
submit()
boring_function("My first function!")
boring_function
submit()
my_mean(c(2,4,5))
my_mean(c(4,5,10))
submit()
submit()
remainder(5)
remainder(11,5)
remainder(divisor = 11, num = 5)
remainder(4, div = 2)
skip()
submit()
evaluate(stddev, c(1.4, 3.6, 7.9,8.8))
evaluate(, c(1.4, 3.6, 7.9,8.8))
evaluate(sd, c(1.4, 3.6, 7.9,8.8))
evaluate(function(x){x+1}, 6)
evaluate(function(v){v[1]}, c(8,4,0))
evaluate(function(v){v[-1]}, c(8,4,0))
?paste
paste("Programming", "is", "fun!")
submit()
skip()
submit()
submit()
play()
?list
next()
nxt()
mad_libs('asd','123','asdad')
submit()
skip()
main()
head(flags)
dim(flags)
class(flags)
cls_list <- lapply(flags,class)
cls_list
class(cls_list)
length(cls_list)
as.character(cls_list)
?sapply
?sapply
skip()
class(cls_list)
class(cls_vect)
sum(flags$orange)
flag_colors <- flags[, 11:17]
flag_colors
head(flag_colors)
lapply(flag_colors, sum)
sapply(flag_colors, sum)
sapply(flag_colors, mean)
flag_shapes <- flags [19"23"]
flag_shapes <- flags [19:23]
flag_shapes <- flags[19:23]
flag_shapes <- flags[,19:23]
lapply(flag_shapes,range)
shape_mat <- sapply(flag_shapes,range)
shape_mat
skip()
skip()
unique_vals <- sapply(flag_shapes,unique)
unique_vals <- lapply(flag_shapes,unique)
unique_vals <- lapply(flags,unique)
unique_vals
lapply(unique_vals,length)
sapply(unique_vals,length)
sapply(flags,unique)
lapply(unique_vals, function(elem) elem[2])
main()
sapply(flags,unique)
vapply(flags,unique,numeric(1))
?numeric
ok()
sapply(flags, class)
vapply(flags, class,character(1))
?tapply
table(flags$landmass)
table(flags$animate)
tappl(flags$animate, mean)
tapply(flags$animate, mean)
tapply(flags$animate, flags$landmass, mean)
tapply(flags$population, flags$red, summary)
tapply(flags$population, flags$landmass, summary)
ls()
class(plants)
dim(plants)
skip()
skip()
object.size(plants)
names(plants)
names(plants)
head(plants)
main()
exit()
quit()
parkway <- read.csv("parkway-movie-data-for-analysis.csv")
parkway <- read.csv("/home/sabman/Projects/box-office/data/parkway-movie-data-for-analysis.csv")
head(parkway)
num_of_attendees <- parkway$gross/parkway$ticket_price
num_of_attendees
parkway$num_of_attendees <- num_of_attendees
head(parkway)
parkway$num_of_attendees
summary(parkway)
parkway$num_of_attendees <- round(parkway$num_of_attendees,2)
head(parkway)
parkway$num_of_attendees
parkway[parkway$ticket_price < 13]
parkway[parkway$ticket_price < 13,]
corrected_parkway <- parkway[parkway$ticket_price < 13,]
head(corrected_parkway)
tail(corrected_parkway)
summary(corrected_parkway)
sd(parkway$num_of_attendees)
dim(corrected_parkway)
corrected_parkway$num_of_attendees <- corrected_parkway$num_of_attendees/corrected_parkway$num_of_shows
summary(corrected_parkway)
sd(parkway$num_of_attendees)
questionable_data <- corrected_parkway[corrected_parkway$num_of_attendees > 120,]
dim(questionable_data)
questionable_data
questionable_data <- corrected_parkway[corrected_parkway$num_of_attendees > 150,]
dim(questionable_data)
questionable_data$name
questionable_data$name, questionable_data$date
questionable_data$date
parkway <- read.csv("/home/sabman/Projects/box-office/data/parkway-data-for-analysis.csv")
parkway <- read.csv("/home/sabman/Projects/box-office/data/parkway-movie-data-for-analysis.csv")
dim(parkway)
head(parkway)
summary(parkway)
parkway$day <- (weekdays(as.Date(parkway$date)))
summary(parkway)
class(parkway$imdb_id)
class(parkway$name)
parkway$imdb_id <- as.character(parkway$imdb_id)
parkway$name <- as.character(parkway$name)
summary(parkway)
parkway$day
parkway$day <- as.factor(parkway$day)
summary(parkway)
attach(parkway)
plot(date,gorss)
plot(date,gross)
sd(num_of_attendees)
boxplot(num_of_attendees)
?subset
subset(parkway,num_of_attendees>49)
summary(parkway)
sd(num_of_attendees)
26 * 2
52 + 37
best_performers <- subset(parkway,num_of_attendees>89)
summary(best_performers)
parkway$date <- as.Date(parkway$date)
summary(parkway)
best_performers <- subset(parkway,num_of_attendees>89)
attach(parkway)
View(parkway)
attach(parkway)
parkway_in_2013 <- subset(parkway,parkway$date < '2014-01-01')
summary(parkway_in_2013)
parkway_in_2014 <- subset(parkway,parkway$date > '2013-12-31' & parkway$date < '2015-01-01' )
summary(parkway_in_2014)
parkway_in_2015 <- subset(parkway,parkway$date > '2014-12-31')
summary(parkway_in_2015)
save.image("~/Projects/box-office/analysis/r-session.RData")
get_best_perfomers <- function(df) {}
get_best_perfomers <- function(df) {
return subset(df, df$num_of_attendees >= (2 * sd(df$num_of_attendeers) + mean(df$num_of_attendeers)))
get_best_perfomers <- function(df) {
return subset(df, df$num_of_attendees >= (2 * sd(df$num_of_attendeers) + mean(df$num_of_attendeers)))}
get_best_perfomers <- function(df) {
return subset(df, df$num_of_attendees >= (2 * sd(df$num_of_attendeers) + mean(df$num_of_attendeers)));}
get_best_perfomers <- function(df) {
m <- mean(df$num_of_attendees);
s <- sd(df$num_of_attendeers);
return(df, df$num_of_atten)
}
get_best_perfomers <- function(df) {
return(df, df$num_of_atten)
}
parkway[names('num_of_attendeers')]
parkway[names('num_of_attendees')]
names(parkway)
parkway[,'num_of_attendees']
class(parkway[,'num_of_attendees'])
sd(parkway[,'num_of_attendees'])
mean(parkway[,'num_of_attendees'])
get_best_perfomers <- function(df) {
col <- 'num_of_attendees';
s <- sd(df[,col]);
m <- mean(df[,col]);
return(subset(df,df[,col] >= 2*s + m));
}
best_performers <- get_best_perfomers(parkway)
summary(best_performers)
best_performers <- get_best_perfomers(parkway_in_2013)
best_performers <- get_best_perfomers(parkway)
best_performers_in_2013 <- get_best_perfomers(parkway_in_2013)
best_performers_in_2014 <- get_best_perfomers(parkway_in_2014)
best_performers_in_2015 <- get_best_perfomers(parkway_in_2015)
summary(best_performers_in_2013)
summary(best_performers_in_2014)
summary(best_performers_in_2015)
pwd
wd
setwd("/home/sabman/Projects/box-office/")
movie_info <- read.csv('data/movie_info.csv')
summary(movie_info)
class(movie_info$actors)
class(movie_info$actors) <- as.character(movie_info$actors)
movie_info$actors <- as.character(movie_info$actors)
movie_info$imdb_id <- as.character(movie_info$imdb_id)
movie_info$tmdb_id <- as.character(movie_info$tmdb_id)
movie_info$release_date <- as.Date(movie_info$release_date)
class(movie_info$revenue)
summary(movie_info)
class(movie_info$metascore)
movie_info$metascore <- as.numeric(movie_info$metascore)
summary(movie_info)
movie_info$imdb_rating <- as.numeric(movie_info$imdb_rating)
movie_info$imdb_votes <- as.numeric(movie_info$imdb_votes)
movie_info$tomato_critic_rating <- as.numeric(movie_info$tomato_critic_rating)
movie_info$tomato_user_rating <- as.numeric(movie_info$tomato_user_rating)
movie_info$tomato_user_votes <- as.numeric(movie_info$tomato_user_votes)
movie_info$tomato_critic_votes <- as.numeric(movie_info$tomato_critic_votes)
movie_info$tomato_fresh_reviews <- as.numeric(movie_info$tomato_fresh_reviews)
movie_info$tomato_rotten_reviews <- as.numeric(movie_info$tomato_rotten_reviews)
movie_info$tomato_user_meter <- as.numeric(movie_info$tomato_user_meter)
movie_info$tomato_critic_meter <- as.numeric(movie_info$tomato_critic_meter)
summary(movie_info)
save.image("~/Projects/box-office/analysis/r-session.RData")
require(plyr)
?merge
merge(parkway, movie_info)
parkway_with_movie_info <- merge(parkway, movie_info)
summary(parkway_with_movie_info)
parkway_in_2013_with_movie_info <- merge(parkway_in_2013, movie_info, all.x = FALSE)
dim(parkway_in_2013_with_movie_info)
dim(parkway_in_2013)
parkway_in_2014_with_movie_info <- merge(parkway_in_2014, movie_info, all.x = FALSE)
parkway_in_2015_with_movie_info <- merge(parkway_in_2015, movie_info, all.x = FALSE)
best_performers_with_movie_info <- merge(best_performers, movie_info, all.x = FALSE)
best_performers_in_2013_with_movie_info <- merge(best_performers_in_2013, movie_info, all.x = FALSE)
best_performers_in_2014_with_movie_info <- merge(best_performers_in_2014, movie_info, all.x = FALSE)
best_performers_in_2015_with_movie_info <- merge(best_performers_in_2015, movie_info, all.x = FALSE)
save.image("~/Projects/box-office/analysis/r-session.RData")
summary(best_performers_with_movie_info)
summary(movie_info)
movie_info <- read.csv('data/movie_info.csv')
summary(movie_info)
as.numeric(movie_info$imdb_rating)
head(movie_info$imdb_rating)
as.numeric(as.character(movie_info$imdb_rating)
)
summary(movie_info)
movie_info$actors <- as.character(movie_info$actors)
movie_info$imdb_id <- as.character(movie_info$imdb_id)
movie_info$tmdb_id <- as.character(movie_info$tmdb_id)
movie_info$release_date <- as.Date(movie_info$release_date)
movie_info$tomato_critic_rating <- as.numeric(as.character(movie_info$tomato_critic_rating))
movie_info$tomato_user_rating <- as.numeric(as.character(movie_info$tomato_user_rating))
movie_info$tomato_user_votes <- as.numeric(as.character(movie_info$tomato_user_votes))
movie_info$tomato_critic_votes <- as.numeric(as.character(movie_info$tomato_critic_votes))
movie_info$tomato_fresh_reviews <- as.numeric(as.character(movie_info$tomato_fresh_reviews))
movie_info$tomato_rotten_reviews <- as.numeric(as.character(movie_info$tomato_rotten_reviews))
movie_info$tomato_user_meter <- as.numeric(as.character(movie_info$tomato_user_meter))
movie_info$tomato_critic_meter <- as.numeric(as.character(movie_info$tomato_critic_meter))
summary(movie_info)
raw_movie_info <- read.csv('data/movie_info.csv')
movie_info$imdb_rating <- as.numeric(as.character(raw_movie_info$imdb_rating))
movie_info$imdb_votes <- as.numeric(as.character(raw_movie_info$imdb_votes))
summary(movie_info)
parkway_with_movie_info <- merge(parkway, movie_info)
summary(parkway_with_movie_info)
parkway_with_movie_info <- merge(parkway, movie_info, all.x = FALSE)
summary(parkway_with_movie_info)
parkway_in_2013_with_movie_info <- merge(parkway_in_2013, movie_info, all.x = FALSE)
parkway_in_2014_with_movie_info <- merge(parkway_in_2014, movie_info, all.x = FALSE)
parkway_in_2015_with_movie_info <- merge(parkway_in_2015, movie_info, all.x = FALSE)
best_performers_with_movie_info <- merge(best_performers, movie_info, all.x = FALSE)
best_performers_in_2013_with_movie_info <- merge(best_performers_in_2013, movie_info, all.x = FALSE)
best_performers_in_2014_with_movie_info <- merge(best_performers_in_2014, movie_info, all.x = FALSE)
best_performers_in_2015_with_movie_info <- merge(best_performers_in_2015, movie_info, all.x = FALSE)
savehistory("~/Projects/box-office/analysis/r-session.RData")
summary(best_performers_with_movie_info)
movie_info$metascore <- as.numeric(as.character(raw_movie_info$metascore))
parkway_with_movie_info <- merge(parkway, movie_info, all.x = FALSE)
parkway_in_2013_with_movie_info <- merge(parkway_in_2013, movie_info, all.x = FALSE)
parkway_in_2014_with_movie_info <- merge(parkway_in_2014, movie_info, all.x = FALSE)
parkway_in_2015_with_movie_info <- merge(parkway_in_2015, movie_info, all.x = FALSE)
best_performers_with_movie_info <- merge(best_performers, movie_info, all.x = FALSE)
best_performers_in_2013_with_movie_info <- merge(best_performers_in_2013, movie_info, all.x = FALSE)
best_performers_in_2014_with_movie_info <- merge(best_performers_in_2014, movie_info, all.x = FALSE)
best_performers_in_2015_with_movie_info <- merge(best_performers_in_2015, movie_info, all.x = FALSE)
summary(best_performers_with_movie_info)
save.image("~/Projects/box-office/analysis/r-session.RData")
savehistory("~/Projects/box-office/analysis/r-history.RData")
View(get_best_perfomers)
View(get_best_perfomers)
View(get_best_perfomers)
View(get_best_perfomers)
View(get_best_perfomers)
get_poor_performers <- function(df) {
col <- 'num_of_attendees';
s <- sd(df[,col]);
m <- mean(df[,col]);
return(subset(df, df[,col] <= (m - s), ));
}
poor_performers <- get_poor_perfomers(parkway)
poor_performers <- get_poor_performers(parkway)
summary(poor_performers)
poor_performers_in_2013 <- get_poor_perfomers(parkway_in_2013)
poor_performers_in_2013 <- get_poor_performers(parkway_in_2013)
dim(poor_performers)
poor_performers_in_2014 <- get_poor_performers(parkway_in_2014)
poor_performers_in_2015 <- get_poor_performers(parkway_in_2015)
poor_performers_with_movie_info <- merge(poor_performers, movie_info, all.x = FALSE)
poor_performers_in_2013_with_movie_info <- merge(poor_performers_in_2013, movie_info, all.x = FALSE)
poor_performers_in_2014_with_movie_info <- merge(poor_performers_in_2014, movie_info, all.x = FALSE)
poor_performers_in_2015_with_movie_info <- merge(poor_performers_in_2015, movie_info, all.x = FALSE)
summary(poor_performers_with_movie_info)
unique(best_performers$imdb_id)
unique(poor_performers$imdb_id)
intersect(unique(best_performers$imdb_id), unique(poor_performers$imdb_id))
savehistory("~/Projects/box-office/analysis/r-history.RData")
save.image("~/Projects/box-office/analysis/r-session.RData")
best_performers[best_performers$imdb_id %in% intersect(unique(best_performers$imdb_id), unique(poor_performers$imdb_id))]
intersection_of_best_and_poor = intersect(unique(best_performers$imdb_id), unique(poor_performers$imdb_id))
best_performers[best_performers$imdb_id %in% intersection_of_best_and_poor]
best_performers[best_performers$imdb_id %in% intersection_of_best_and_poor,]
poor_performers[poor_performers$imdb_id %in% intersection_of_best_and_poor,]
best_performers$name
unique(best_performers$name)
View(get_poor_performers)
summary(best_performers)
summary(best_performers[best_performers$imdb_id %in% intersection_of_best_and_poor])
summary(best_performers[best_performers$imdb_id %in% intersection_of_best_and_poor,])
summary(poor_performers[poor_performers$imdb_id %in% intersection_of_best_and_poor,])
View(get_best_perfomers)
View(get_best_perfomers)
View(parkway)
?aggregate
aggregate(num_of_attendees ~ day, parkway, sum)
agg_by_day = aggregate(num_of_attendees ~ day, parkway, sum)
class(agg_by_day)
agg_by_day[order(num_of_attendees)]
agg_by_day[order(agg_by_day$num_of_attendees)]
order(agg_by_day$num_of_attendees)
agg_by_day[order(agg_by_day$num_of_attendees)]
order(agg_by_day$num_of_attendees)
agg_by_day[order(agg_by_day$num_of_attendees),]
agg_by_day_in_2013 = aggregate(num_of_attendees ~ day, parkway_in_2013, sum)
agg_by_day_in_2014 = aggregate(num_of_attendees ~ day, parkway_in_2014, sum)
agg_by_day_in_2015 = aggregate(num_of_attendees ~ day, parkway_in_2015, sum)
agg_by_day[order(agg_by_day_in_2013$num_of_attendees),]
agg_by_day_in_2013[order(agg_by_day_in_2013$num_of_attendees),]
agg_by_day_in_2014[order(agg_by_day_in_2014$num_of_attendees),]
agg_by_day_in_2015[order(agg_by_day_in_2015$num_of_attendees),]
?merge
?combn
?merge
merge(agg_by_day, agg_by_day_in_2013, by.x = 'day')
merge(agg_by_day, agg_by_day_in_2013)
merge(agg_by_day, agg_by_day_in_2013, by.y = 'day')
merge(agg_by_day, agg_by_day_in_2013, by.y = 1)
merge(agg_by_day, agg_by_day_in_2013, by.x = 1)
agg_by_day
agg_by_day_in_2013
merge(agg_by_day, agg_by_day_in_2013)
merge(agg_by_day, agg_by_day_in_2013, by= 'day')
merge(agg_by_day, agg_by_day_in_2013, by= 'day', suffixes = c('overall', '2013'))
merge(agg_by_day, agg_by_day_in_2013, by= 'day', suffixes = c('_overall', '_2013'))
merge(agg_by_day, agg_by_day_in_2013, agg_by_day_in_2014, by= 'day', suffixes = c('_overall', '_2013', '_2014'))
?Reduce
agg_by_day
agg_by_day_across_the_years = list(agg_by_day,agg_by_day_in_2013,agg_by_day_in_2014,agg_by_day_in_2015)
Reduce(function(...){merge(..., by = 'all'), agg_by_day_across_the_years})
Reduce(function(...){merge(..., by = 'all')}, agg_by_day_across_the_years})
Reduce(function(...)merge(..., by = 'all'), agg_by_day_across_the_years})
Reduce(function(...)merge(..., by = 'all'), agg_by_day_across_the_years)
Reduce(function(...)merge(..., by = 'all'), agg_by_day_across_the_years})
Reduce(function(...)merge(..., by = 'all'), agg_by_day_across_the_years)
Reduce(function(...)merge(..., by = 'all'), agg_by_day_across_the_years)
Reduce(function(...)merge(..., by = 'day'), agg_by_day_across_the_years)
Reduce(function(...){merge(..., by = 'day')}, agg_by_day_across_the_years)
Reduce(function(...){
merge(..., by = 'day')}, agg_by_day_across_the_years)
name(agg_by_day_in_2013)
?deparse
substitute(agg_by_day_in_2013)
deparse(substitute(agg_by_day_in_2013))
?substr
substr("agg_by_day_in_2013")
substr("agg_by_day_in_2013",9,4)
substr("agg_by_day_in_2013",9,10)
substr("agg_by_day_in_2013",-1,10)
substr("agg_by_day_in_2013",-4,)
substr("agg_by_day_in_2013",-4)
substr("agg_by_day_in_2013",-4,0)
substr("agg_by_day_in_2013",-4,-1)
substr("agg_by_day_in_2013",-4,-2)
substrRight <- function(x, n){
substr(x, nchar(x)-n+1, nchar(x))
}
substrRight("agg_by_day_in_2013",-4,-2)
substrRight("agg_by_day_in_2013",4)
merge(agg_by_day, agg_by_day_in_2013, agg_by_day_in_2014, by= 'day', suffixes = c(,, '_2014'))
merge(agg_by_day, agg_by_day_in_2013, agg_by_day_in_2014, by= 'day', suffixes = c('_overall', '_2013', '_2014'))
merge(agg_by_day, agg_by_day_in_2013, agg_by_day_in_2014, by='day', suffixes = c('_overall', '_2013', '_2014'))
merge(agg_by_day, agg_by_day_in_2013, by= 'day')
merge(agg_by_day, agg_by_day_in_2013, by= 'day', suffixes = c('_overall', '_2013'))
merge(agg_by_day, agg_by_day_in_2013, by= 'day', suffixes = c(, '_2013'))
Reduce(function(...){
merge(..., by = 'day')}, agg_by_day_across_the_years)
attendees_by_day = Reduce(function(...){
merge(..., by = 'day')}, agg_by_day_across_the_years)
colnames(attendees_by_day) <- c("day", 'overall','2013','2014','2015')
attendees_by_day
View(attendees_by_day)
write.csv(attendees_by_day)
agg_by_day
View(parkway)
parkway <- read.csv("parkway-movie-data-for-analysis.csv")
wd
setwd('~/Projects/box-office/data/')
parkway <- read.csv("parkway-movie-data-for-analysis.csv")
head(parkway)
summary(parkway)
parkway$num_of_attendees <- round(parkway$num_of_attendees,2)
dim(parkway)
parkway$day <- (weekdays(as.Date(parkway$date)))
parkway$imdb_id <- as.character(parkway$imdb_id)
parkway$name <- as.character(parkway$name)
parkway$day <- as.factor(parkway$day)
parkway$date <- as.Date(parkway$date)
parkway_in_2013 <- subset(parkway,parkway$date < '2014-01-01')
parkway_in_2014 <- subset(parkway,parkway$date > '2013-12-31' & parkway$date < '2015-01-01' )
parkway_in_2015 <- subset(parkway,parkway$date > '2014-12-31')
View(get_best_perfomers)
get_best_perfomers <- function(df) {
col <- 'num_of_attendees';
s <- sd(df[,col]);
m <- mean(df[,col]);
return(subset(df,df[,col] >= 2*s + m));
}
best_performers_in_2013 <- get_best_perfomers(parkway_in_2013)
best_performers_in_2014 <- get_best_perfomers(parkway_in_2014)
best_performers_in_2015 <- get_best_perfomers(parkway_in_2015)
get_poor_performers <- function(df) {
col <- 'num_of_attendees';
s <- sd(df[,col]);
m <- mean(df[,col]);
return(subset(df, df[,col] <= (m - s), ));
}
poor_performers <- get_poor_performers(parkway)
poor_performers_in_2013 <- get_poor_performers(parkway_in_2013)
poor_performers_in_2014 <- get_poor_performers(parkway_in_2014)
poor_performers_in_2015 <- get_poor_performers(parkway_in_2015)
savehistory("~/Projects/box-office/data/setting-up-parseway-data.R")
savehistory("~/Projects/box-office/data/setting-up-parkway-data.R")
