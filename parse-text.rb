#!/usr/bin/env ruby
require 'pp'
require 'sqlite3'
require 'pry'
require 'date'

db = SQLite3::Database.new "box-office"

def proceed_till_next_continue
end

def convert_value_to_num value
  return 0 if value.nil?
  value = value.flatten.first if value.class.to_s == 'Array'
  return 0 if value == '-'
  return 0 if value.nil?
  value.delete(',').to_i
end

#removes * from movie name
def clean_up_movie_name(value)
  value[0] = '' if value[0] == '*'
  value[-1] = '' if value[-1] == '#'
  value.strip
end

def parse_date content
  date_matches= content.scan(DATE_REGEX).first
  #date is in MM DD YYYY format
  #Date needs it to be in YYYY, MM, DD
  date = Date.new(date_matches[2].to_i, date_matches[0].to_i, date_matches[1].to_i)
  raise 'ERROR PARSING DATE' if !date.friday?
  date
end

#TODO: make it effecient
define_method :create_and_fetch_id do |table,value|
  result = db.execute('select * from ' + table +' where name = "' + value +'"')
  result = db.execute('insert into '+ table +'(name) values (?)',value) if result.size == 0
  result = db.execute('select id from ' + table +' where name = "' + value +'"').flatten.first
end

#no or insignificant data for these theaters
def ignore_theater name
  list = ['INDRP - El Campanil Theatre - Antioch, CA',
   'PE - El Rey Theatre - Chico, CA',
   'Castro',
   'INDLF',
   'EXSV - Highland Park 3 - Highland Park, CA',
   'CFMY - Cinefamily@The Silent Movie Theatre - Los Angeles, CA',
   'REL - Reel Cinema - Wofford Heights, CA',
   'AR - Auditorium Rental, AS - Auditorium Screening, CW - Closed Weekdays, DP - Damaged Print, EF - Equipment Failure',
   'FF - Film Festival, MC - Movie Canceled, NA - No Authorization, NB - No Bookings, ND - Called, No Data Available',
   'NE - No Engagement, NP - No Patrons, PR - Pending Revenue, SS - Special Screening, TC - Temporarily Closed',
   'INDRP - Downtown Independent - Los Angeles, CA',
   '21CC - Victory Theatre - Safford, AZ',
   'EGYP - Egyptian - Hollywood, CA'
  ]
  list.each do |v|
    return true if name.include?(v)
  end
  return false
end

THEATERS = []
THEATERS_REGEX = /[A-Z0-9]{2,5} - .*? - .*?, [A-Z]{2}/
DATE_REGEX = /(\d{1,2})\/(\d{1,2})\/(\d{4}) -/

COLUMNS = [
:cumalative_gross,
:last_week_gross,
:this_week_gross,
:thu_gross,
:wed_gross,
:tue_gross,
:mon_gross,
:percentage_change,
:last_weekend_gross,
:this_weekend_gross,
:sun_gross,
:sat_gross,
:fri_gross,
:name,
:nth_week]


files = Dir["./data/corrected_box_office_reports/*.txt"]
#files= ['./data/corrected_box_office_reports/branch_area_20160304_LA.pdf.txt']
files.each do |file|
  FILE_NAME = file

  #get total count of occurances of Total
  #This can be used to verify number of theater names scanned
  file = File.open(FILE_NAME)
  content = file.read
  week_start_date = parse_date content
  num_of_totals = content.scan(/Total/).size #This will cause problems if there is a movie name containing total
  file.close

  #scan for theater names and add it to THEATERS array
  File.open(FILE_NAME) do |f|
    f.each_line do |line|
      # if the data for a theater is continued to a new page,
      # it has (continued) appended in the end
      # we are only looking for unique theater names
      if line[THEATERS_REGEX] && !line[/\(continued\)/]
        THEATERS.push line.strip
      end
    end
  end
  puts 'ERROR IN THEATER NAMES' if THEATERS.size != num_of_totals

  THEATERS.each do |t|
    result = db.execute('SELECT * FROM THEATERS WHERE name = ?', t)
    db.execute('INSERT INTO theaters(name) VALUES (?)', t) if result.size == 0
  end

  num_of_theaters = db.execute('SELECT count(*) FROM theaters').flatten.first

  lines = File.readlines(FILE_NAME)

  lines_num = -1
  theater_num = 0
  while lines_num < lines.length && theater_num < THEATERS.length do
   lines_num +=1
   break if lines.size  <= lines_num

   #continue till you hit a theater name
   next unless lines[lines_num][THEATERS[theater_num]]
   #puts '----------',lines[lines_num], '----------------'
   begin #loop through each line of theater's data

     theater_id = create_and_fetch_id('theaters', THEATERS[theater_num])
     lines_num += 1
     reverse_index = -1

     #if next line is an end of line, it is liklely that data is continued to a new page
     #so continue incrementing the line number till you hit the theater name again or
     #you hit total
     if lines[lines_num] == "\n"
       begin
         lines_num += 1
         break if lines.size  <= lines_num
       end until lines[lines_num][THEATERS[theater_num]] || lines[lines_num].include?('   Total   ')
     end
     break if lines.size  <= lines_num

     #if current line is theater name, increment and parse data
     if lines[lines_num][THEATERS[theater_num]]
       lines_num += 1
     elsif lines[lines_num].include?('   Total   ')
     #else if current line is total, parse/ignore total
       break
     end

     parsed_data_line_with_all_but_last_column = lines[lines_num].strip.scan(/(.*?)\s+/em) #parses all except last column
     parsed_data_line_last_column = lines[lines_num].strip.scan(/([0-9,-]+)$/em) #parses last column
     parsed_data_line_with_all_but_last_column.insert(-8, '-') if parsed_data_line_with_all_but_last_column[0][0] == '1' #hack to make up for emtpy %change column when movie is in its first week of release

     data_line = {}
     #print parsed data with column name
     #print COLUMNS[0], ' ' , convert_value_to_num(parsed_data_line_last_column), ' | '
     data_line[COLUMNS[0]] = convert_value_to_num(parsed_data_line_last_column)
     for index in 0..11 do
       #print COLUMNS[index+1], ' ', convert_value_to_num(parsed_data_line_with_all_but_last_column[reverse_index - index]), ' | '
       data_line[COLUMNS[index+1]] = convert_value_to_num(parsed_data_line_with_all_but_last_column[reverse_index - index])
     end
     data_line[:nth_week] = convert_value_to_num(parsed_data_line_with_all_but_last_column[0])
     #print COLUMNS[14] , ' ', convert_value_to_num(parsed_data_line_with_all_but_last_column[0]), ' | '
     #print COLUMNS[13] , ' ',parsed_data_line_with_all_but_last_column[1..-13].flatten.join(' '), ' | '
     #puts data_line
     if parsed_data_line_with_all_but_last_column.flatten.reject {|v| v == "-"}.size == 0 # if all if the data in the line is ------ then ignore
       puts ('IGNORING DATA FOR ' + THEATERS[theater_num])
       next
     end
     movie_name = parsed_data_line_with_all_but_last_column[1..-13].flatten.join(' ')
     movie_name = clean_up_movie_name(movie_name)
     binding.pry  if movie_name.size == 0 && !ignore_theater(THEATERS[theater_num])
     raise 'ERROR in NAME' if movie_name.size == 0 && !ignore_theater(THEATERS[theater_num])
     movie_id = create_and_fetch_id('movies', movie_name)

     #verify data
     puts 'ERROR in weekend data' if 10 < data_line[:this_weekend_gross] - (data_line[:sun_gross] + data_line[:sat_gross] + data_line[:fri_gross])
     puts 'ERROR in weekly data' if 10 < data_line[:this_week_gross] - (data_line[:mon_gross] + data_line[:tue_gross] + data_line[:wed_gross] + data_line[:thu_gross] + data_line[:sun_gross] + data_line[:sat_gross] + data_line[:fri_gross])
     change_in_gross = 0
     change_in_gross = ((data_line[:this_weekend_gross] - data_line[:last_weekend_gross]) * 100) / data_line[:last_weekend_gross] if  data_line[:last_weekend_gross] > 0
     puts 'ERROR in %change', change_in_gross if (5 < data_line[:percentage_change] - change_in_gross) && data_line[:last_weekend_gross] > 0

     #insert data
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, week_start_date.to_s, data_line[:fri_gross] )
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, (week_start_date +1).to_s, data_line[:sat_gross] )
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, (week_start_date +2).to_s, data_line[:sun_gross] )
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, (week_start_date -1).to_s, data_line[:thu_gross] )
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, (week_start_date -2).to_s, data_line[:wed_gross] )
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, (week_start_date -3).to_s, data_line[:tue_gross] )
     db.execute('INSERT OR IGNORE INTO daily_performance(movie_id, theater_id, date, gross) VALUES (?,?,?,?)', movie_id, theater_id, (week_start_date -4).to_s, data_line[:mon_gross] )
     db.execute('INSERT OR IGNORE INTO weekly_performance(movie_id, theater_id, weekend_date, weekend_gross, last_weekend_gross, weekly_gross, last_weekly_gross, nth_week) VALUES (?,?,?,?,?,?,?,?)',
                                                movie_id, theater_id, week_start_date.to_s, data_line[:this_weekend_gross], data_line[:last_weekend_gross], data_line[:this_week_gross], data_line[:last_week_gross], data_line[:nth_week])

     db.execute('INSERT OR IGNORE INTO cumalative_performance(movie_id, theater_id, weekend_date, cumalative_gross) VALUES (?,?,?,?)',
                                                movie_id, theater_id, week_start_date.to_s, data_line[:cumalative_gross] )
   end while (!lines[lines_num+1].include?('   Total   '))
   #puts '**********************************'
   #puts ''
   theater_num += 1
  end
  FileUtils.mv(FILE_NAME, './data/corrected_box_office_reports/parsed/'+FILE_NAME.split('/')[-1])
end
db.close

  #Read line till you reach one of the theaters (first is usually AMC Metreon)
  #
  #parse each line to a columns of data
  # watch out for continuation of next page, you will know because it will say continued and have same theater name
  #halt till you reach Total, parse total, confirm parsed correctly by checking against total
  #go to start of loop

