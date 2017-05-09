parkway_on_weekend <- filter(parkway, day %in% c('Saturday', 'Sunday'))

#table to store weather data
parkway_weekend_weather <- data.table('date'=character(), 'temp'=numeric(), 'hum'=numeric(),'rain'=numeric())

weekend_dates <- unique(parkway_on_weekend$date)

#Wunderground gives us hourly breakdown of weather data. This method parses the weather data for conditions between 9:30 am and 10:30 pm.
#It calculates the avg temperature, avg humidity and if it rained or not.
#If it rained anytime during the hours, we set rain as true/1
weather_details <- function(weather_data) {
  d <- as.Date(weather_data$date[1])
  tmp <- weather_data %>% filter(date > as.POSIXct(paste(d," 09:30:00"))) %>% filter(date <  as.POSIXct(paste(d," 22:30:00")))
  result <- list( as.character(d),
                  sum(tmp$temp)/length(tmp),
                  sum(tmp$hum)/length(tmp),
                  ifelse(sum(tmp$rain) > 0, 1,0)
                )
  return(result)
}

for(d in as.list(weekend_dates)) {
d_number <- as.numeric(gsub('-','',as.character(d)))
#call wunderground to get weather data
result <- history(set_location(zip_code = "94612"),date = d_number)
d_weather <- weather_details(result)
parkway_weekend_weather <- rbind(parkway_weekend_weather,d_weather)
Sys.sleep(7) #limit api calls
}

summary(parkway_weekend_weather)
parkway_weekend_weather$date <-  as.Date(parkway_weekend_weather$date)
parkway_weekend_weather$rain <- as.factor(parkway_weekend_weather$rain)
parkway_on_weekend_summarized <- parkway_on_weekend %>% group_by(date)  %>%  mutate(total_attendees = sum(attendees), total_shows = sum(num_of_shows)) %>% select(date,total_attendees, total_shows,day)
parkway_on_weekend_summarized$total_attendees <- round(parkway_on_weekend_summarized$total_attendees)
parkway_on_weekend_summarized_with_weather <- merge(parkway_on_weekend_summarized,parkway_weekend_weather)
parkway_on_weekend_summarized_with_weather <- parkway_on_weekend_summarized_with_weather %>% mutate(avg_attendance = round(total_attendees/total_shows))
require(ggplot2)
parkway_on_weekend_summarized_with_weather<-unique(parkway_on_weekend_summarized_with_weather)
ggplot(parkway_on_weekend_summarized_with_weather, aes(x=date, y=avg_attendence, color=rain)) + geom_point(shape=1)
avg_attendence_on_rain <- parkway_on_weekend_summarized_with_weather %>% filter(rain==1) %>% select(avg_attendence)
avg_attendence_on_no_rain <- parkway_on_weekend_summarized_with_weather %>% filter(rain==0) %>% select(avg_attendence)
hist(avg_attendence_on_rain[,1])
hist(avg_attendence_on_no_rain[,1])
t.test(avg_attendence_on_no_rain[,1],avg_attendence_on_rain[,1])



