# An analysis of the New Parkway Theater

## Introduction
 The *New Parkway Theater* (**INSERT LINK**) is a second run movie theater based in *Oakland, CA*. It started in December 2012 and has been quite popular with the local community.

Being a second-run theater means that they cannot play movies that are currently running in its neighborhood theaters which includes the Grand Lake Theater,
Piedmont theater and the Regal theater in Oakland. The Parkway theater manages its programming by including a mix of new and old films inclduing documentaries.

Given Oakland's diverse population, the kind of films that do well in the theater is quite unique and makes for an interesting analysis. By including analysis of
the movies that has played in the Parkway and comparing it with other theaters in California, this study hopes to gain insight into the kind of movies that does
well in and come up with a recommendation on what movies it should play and when.

## Data
contains data set from 2012 to current

## Files
`data/parkway-shows-by-performance.csv` :
  - columns: *imdb_id, name, gross, date, theater, time, num_of_shows, ticket_price*
  - notes:
    - *name* : Extracted from Google Calendar where each screening was listed as an event. During the analysis we remove the column because it contains movie summary and links to buy tickets.
    - *gross* : Total box collections for the day. Does not indicate how much it made in each show if there was more than one show in a day.
    - *theater*, *time* : These columns are ignored. The data generated in the file have been grouped by date and these columns should have been removed when making the sqwl query. No information
      is available about how much money was made during which show. **TODO** add all theater and time info in a single value.

`data/movie_info.csv`
  - columns:  *imdb_id, name, imdb_id.1, tmdb_id, budget, genres, tmdb_popularity, release_date, revenue, runtime, languages,
                tmdb_rating, tmdb_votes, directors, writers, keywords, awards, metascore, imdb_rating, imdb_votes, tomato_critic_rating,
                tomato_user_rating, tomato_user_votes, tomato_critic_votes, tomato_fresh_reviews, tomato_rotten_reviews, tomato_user_meter, tomato_critic_meter, actors*
  - notes: Information about movies using data from TMDB, OMDB, Rotten Tomatoes, IMDB, Metacritic

## Environment Variables
`parkway` : imported from parkway-shows-by-performance.csv and cleaned up,  containing informationabout movies played at the Parkway theater by date.
            Contains a calculated columns day and num_of_attendees(average number of people per show, calculated using gross/num_of_shows/ticket_price). The num_of_attendees is not
            completely accurate since few people might have used coupons like Groupons.

`movie_info` : imported from movie_info.csv and cleaned up

`summarized_parkway_with_movie_info` : a join of the 2 data tables above but with the num_of_attendees averaged across all the shows.

`parkway_in_` : parkway data broken down by 2012-13, 2014, 2015-16. Since we have only few rows of data for 2012 and 2016, they are merged with 2013 and 2015 respectively

`parkway_by_the_years` : parkway data summarized by 2012-13, 2014, 2015-2016
.
