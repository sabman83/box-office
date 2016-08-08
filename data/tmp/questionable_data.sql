select *  from parkway_daily_performance as gross
	where (length(gross.imdb_id)  > 0) 
			and 
			 (
				(gross.date in (select distinct date from parkway_daily_shows where imdb_id = gross.imdb_id) and gross.gross = 0)
				or 
				(gross.date not in (select distinct date from parkway_daily_shows where imdb_id = gross.imdb_id) and gross.gross >0)
			)
	order by imdb_id asc
			