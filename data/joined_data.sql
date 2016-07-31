select *, (t.gross/num_of_shows/ticket_price) as num_of_attendees from (select movies.id, shows.imdb_id, shows.name, gross.gross, gross.date,  shows.theater, shows.time, count(shows.date) as num_of_shows, avg(shows.price) as ticket_price  from parkway_daily_performance as gross 
				join parkway_movies as movies on gross.movie_id = movies.id
				join parkway_daily_shows  as shows on movies.imdb_id = shows.imdb_id and gross.date = shows.date and shows.price > 3 and gross.gross > 0 group by shows.imdb_id, shows.date 
				order by ticket_price desc) t
				where ticket_price < 13
						