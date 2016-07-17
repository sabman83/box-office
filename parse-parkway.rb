#!/usr/bin/env ruby
require 'pp'
require 'sqlite3'
require 'pry'
require 'date'
require 'fileutils'

db = SQLite3::Database.new "box-office"

files = Dir["./data/parkway-*.txt"]
DATE_RANGE_REGEX = /\d{1,2}\/\d{1,2}\/\d{2,4}[-\s]+\d{1,2}\/\d{1,2}\/\d{2,4}|\d{1,2}\/\d{1,2}[-\s]+\d{1,2}\/\d{1,2}\/\d{2,4}/
#expects content to be of form: MM/DD/YY-MM/DD/YY or MM/DD/YYYY-MM/DD/YYYY
#returns a Date object
def get_start_date content
  start_date_text = content.split('-')[0].strip
  parse_date= start_date_text.split('/')
  if parse_date.length < 3
    end_date_text = content.split('-')[1].strip
    parse_end_date = end_date_text.split('/')
    year = 2000 + parse_end_date[2].to_i
    binding.pry
  else
    if parse_date[2].size == 2
      add_year = 2000
    elsif parse_date[2].size == 4
      add_year = 0
    else
      raise 'Error parsing date'
    end
    year = add_year + parse_date[2].to_i
  end
  month = parse_date[0].to_i
  day = parse_date[1].to_i
  Date.new(year, month, day)
end

#creates an entry for the movie if it doesn't exit
#returns the id
define_method :create_and_fetch_id do |value|
  result = db.execute('select * from parkway_movies where name = "' + value +'"')
  result = db.execute('insert into parkway_movies (name) values (?)',value) if result.size == 0
  result = db.execute('select id from parkway_movies where name = "' + value +'"').flatten.first
end

files.each do |file_name|
  puts 'processing ', file_name
  lines = File.readlines(file_name)
  lines_num = -1

  #loop till you hit date range, parse date and point to next line
  while lines_num < lines.length do
    lines_num += 1
    next unless lines[lines_num].match(DATE_RANGE_REGEX)
    dates = lines[lines_num].match(DATE_RANGE_REGEX)[0]
    start_date = get_start_date dates
    break
  end

  #To test weekly total against parsed data
  grand_total = 0
  while lines_num < lines.length do
    lines_num +=1
    data = lines[lines_num].split(',')
    break if data[0].length == 0
    movie_name = data[0].strip
    movie_id = create_and_fetch_id(movie_name)
    binding.pry if data.length > (7+1+1) #7 days of the week, movie name, total
    raise 'Error in row' if data.length > (7+1+1) #7 days of the week, movie name, total
    movie_total =  0
    for index in 1..7 do
      db.execute('INSERT OR REPLACE INTO parkway_daily_performance(movie_id, date, gross) VALUES (?,?,?)', movie_id, (start_date + index -1).to_s, data[index].to_i )
      movie_total += data[index].to_i
    end
    binding.pry if data[8].to_i != movie_total
    raise 'Row Parsing error' if data[8].to_i != movie_total
    grand_total += movie_total
  end

  while lines[lines_num]['WEEKLY TOTAL'].nil?
    lines_num += 1
    break if lines_num >= lines.length
  end
  if lines_num >= lines.length
    FileUtils.mv(file_name, './data/corrected_parkway_data/'+file_name.split('/')[-1])
    next
  end
  grand_total_from_data = lines[lines_num].chomp.split(',')[-1]
  binding.pry if grand_total_from_data.to_i != grand_total
  raise 'Parse Error on grand total' if grand_total_from_data.to_i != grand_total
  FileUtils.mv(file_name, './data/corrected_parkway_data/'+file_name.split('/')[-1])
end
db.close


