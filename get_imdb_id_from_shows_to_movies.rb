#!/usr/bin/env ruby
require 'sqlite3'
require 'pp'
require 'pry'

$db = SQLite3::Database.new "box-office"

def store_id_for_movie(rows, imdb_id)
  rows.each do |movie|
    $db.execute("UPDATE parkway_daily_shows SET imdb_id=? where name=?", imdb_id, movie[1])
  end
end

def revert_imdb_id(id, imdb_id)
    $db.execute("UPDATE parkway_movies SET imdb_id=? where id=?", imdb_id, id)
end
#get list of movies with no imdb ids
movies = $db.execute('SELECT id,name,imdb_id from parkway_movies where imdb_id not in (select distinct imdb_id from parkway_daily_shows where imdb_id like "tt%")')
binding.pry

#for each movie , get matching row,
movies.each do |movie|
  begin
    results = $db.execute("SELECT imdb_id,name from parkway_daily_shows where name like \"%"+ movie[1] +"%\"")
    if results.size == 0
      pp '**************** NO DATA FOUND FOR ' +  movie[1] + ' *****************'
      next
    end
    if !results.nil?
      print 'MORE THAN ONE ENTRY FOUND FOR ', movie
      pp 'Following matches found: *****************************************'
      results.each_with_index do |result, index|
        pp index.to_s + ' : ' + result[0] + ' ' + result[1]
      end
      pp 'Y to update all or N to ignore or R to revert'
      idx = gets.chomp
      idx = idx.to_s
      next if idx == 'n' || idx == 'N'
      if idx == 'Y' || idx == 'y'
        store_id_for_movie(results, movie[2])
      else
        revert_imdb_id(movie[0],results[idx.to_i][0])
      end
      next
    end
  rescue => e
    pp e
    binding.pry
  end
end

$db.close
