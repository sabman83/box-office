#!/usr/bin/env ruby
require 'pp'
require 'sqlite3'
require 'pry'
require 'date'
require 'fileutils'

db = SQLite3::Database.new "box-office"

movies = db.execute('SELECT id,imdb_id from parkway_movies where imdb_id like "tt_______"')

movies.each do |movie|
  sql = 'UPDATE parkway_daily_performance SET imdb_id ="' +movie[1].to_s+ '"  where movie_id = ' + movie[0].to_s
  db.execute(sql)

end
db.close



