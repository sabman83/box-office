#!/usr/bin/env ruby
require 'pp'
require 'sqlite3'
require 'pry'
require 'date'
require 'fileutils'

db = SQLite3::Database.new "box-office"

movies = db.execute('SELECT id, name from parkway_movies')

movies.each do |movie|
  db.execute('UPDATE parkway_daily_performance SET name = "' + movie[1].to_s + '" where movie_id = ' + movie[0].to_s)
end
db.close



