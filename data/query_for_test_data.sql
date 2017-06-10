select t1.imdb_id, t1.date, num_of_shows,ticket_price, t2.gross 
from (select imdb_id, date, count(*) as num_of_shows, avg(price) as ticket_price 
	from parkway_daily_shows 
	where date > '2016-03-27'
	group by imdb_id, date ) as t1
inner join parkway_daily_performance as t2 
	on t1.imdb_id = t2.imdb_id
	and t1.date = t2.date
where t2.gross >0
order by t1.date desc

select distinct(pm.imdb_id) from parkway_daily_performance as pdp join parkway_movies as pm where pdp.movie_id = pm.id
and pdp.date > '2016-03-27'


