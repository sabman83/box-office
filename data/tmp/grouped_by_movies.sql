select *, (total_gross/total_num_of_shows/avg_ticket_price) as tota_num_of_attendees from (select imdb_id, name, sum(gross) as total_gross, sum(num_of_shows) as total_num_of_shows, avg(ticket_price)  as avg_ticket_price from (select shows.imdb_id, shows.name, gross.gross, gross.date,  count(shows.date) as num_of_shows, avg(shows.price) as ticket_price  from parkway_daily_performance as gross 
				join parkway_movies as movies on gross.movie_id = movies.id
				join parkway_daily_shows  as shows on movies.imdb_id = shows.imdb_id and gross.date = shows.date and shows.price > 3 and gross.gross > 0 and shows.imdb_id != '' group by shows.imdb_id, shows.date 
				order by ticket_price desc) t
				where ticket_price < 13
				group by imdb_id
				order by total_num_of_shows desc)