#!/usr/bin/env ruby
require 'sqlite3'
require 'pp'
require 'pry'

$db = SQLite3::Database.new "box-office"

def update_imdb_id_in_parkway_movies(id, imdb_id)
    $db.execute("UPDATE parkway_movies SET imdb_id=? where id=?", imdb_id, id)
end


#get list of movies with no imdb ids
movies = $db.execute('select * from parkway_movies where imdb_id is null or imdb_id = ""')

#for each movie , get matching row,
movies.each do |movie|
  begin
    results = $db.execute("select imdb_id,name from parkway_daily_shows where name like '%#{movie[1]}%' group by imdb_id")

    if results.size == 0
      pp '**************** NO DATA FOUND FOR ' +  movie[1] + ' *****************'
      next
    end
    if !results.nil?
      if results.size == 1
        update_imdb_id_in_parkway_movies(movie[0],results[0][0])
      else
        next # if more than one entry found correct it manually
        print 'MORE THAN ONE ENTRY FOUND FOR ', movie
        pp 'Following matches found: *****************************************'
        results.each_with_index do |result, index|
          pp index.to_s + ' : ' + result[0] + ' ' + result[1]
        end
        pp 'Enter Number or Enter Y to update all or N to ignore'
        idx = gets.chomp
        idx = idx.to_s
        next if idx == 'n' || idx == 'N'
        if idx == 'Y' || idx == 'y'
          results.each do |result|
            update_imdb_id_in_parkway_movies(movie[0],result[0])
          end
        end
      end
    end
  rescue => e
    pp e
    next
  end
end

$db.close
