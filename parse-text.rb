#!/usr/bin/env ruby
require 'pp'
def proceed_till_next_continue
end

def convert_value_to_num value
  return 0 if value.nil?
  value = value.flatten.first if value.class.to_s == 'Array'
  return 0 if value == '-'
  value.delete(',').to_i
end

THEATERS = []
THEATERS_REGEX = /[A-Z0-9]{2,5} - .*? - .*?, [A-Z]{2}/
#get total count of occurances of Total
#This can be used to verify number of theater names scanned
file = File.open('report.txt')
content = file.read
num_of_totals = content.scan(/Total/).size #This will cause problems if there is a movie name containing total
file.close

#scan for theater names and add it to THEATERS array
File.open('report.txt') do |f|
  f.each_line do |line|
    # if the data for a theater is continued to a new page,
    # it has (continued) appended in the end
    # we are only looking for unique theater names
    if line[THEATERS_REGEX] && !line[/\(continued\)/]
      THEATERS.push line
    end
  end
end

puts 'ERROR IN THEATER NAMES' if THEATERS.size != num_of_totals

COLUMNS = [
:cumalative_gross,
:last_week_gross,
:this_week_total,
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

lines = File.readlines('report.txt')

lines_num = -1
theater_num = 0
while lines_num < lines.length && theater_num < THEATERS.length do
 lines_num +=1

 #continue till you hit a theater name
 next unless lines[lines_num][THEATERS[theater_num]]

 puts '----------',lines[lines_num], '----------------'
 begin #loop through each line of theater's data
   lines_num += 1
   reverse_index = -1

   #if next line is an end of line, it is liklely that data is continued to a new page
   #so continue incrementing the line number till you hit the theater name again or
   #you hit total
   if lines[lines_num] == "\n"
     begin
       lines_num += 1
     end until lines[lines_num][THEATERS[theater_num]] || lines[lines_num].include?('   Total   ')
   end

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
   print COLUMNS[0], ' ' , convert_value_to_num(parsed_data_line_last_column), ' | '
   data_line[COLUMNS[0]] = convert_value_to_num(parsed_data_line_last_column)
   for index in 0..11 do
     print COLUMNS[index+1], ' ', convert_value_to_num(parsed_data_line_with_all_but_last_column[reverse_index - index]), ' | '
     data_line[COLUMNS[index+1]] = convert_value_to_num(parsed_data_line_with_all_but_last_column[reverse_index - index])
   end
   print COLUMNS[14] , ' ', convert_value_to_num(parsed_data_line_with_all_but_last_column[0]), ' | '
   print COLUMNS[13] , ' ',parsed_data_line_with_all_but_last_column[1..-13].flatten.join(' '), ' | '
   puts data_line

   #verify data
   puts 'ERROR in weekend data' if 10 < data_line[:this_weekend_gross] - (data_line[:sun_gross] + data_line[:sat_gross] + data_line[:fri_gross])
   puts 'ERROR in weekly data' if 10 < data_line[:this_week_total] - (data_line[:mon_gross] + data_line[:tue_gross] + data_line[:wed_gross] + data_line[:thu_gross] + data_line[:sun_gross] + data_line[:sat_gross] + data_line[:fri_gross])
   change_in_gross = ((data_line[:this_weekend_gross] - data_line[:last_weekend_gross]) * 100) / data_line[:last_weekend_gross] if  data_line[:last_weekend_gross] > 0
   puts 'ERROR in %change', change_in_gross if (2 < data_line[:percentage_change] - change_in_gross) && data_line[:last_weekend_gross] > 0
 end while (!lines[lines_num+1].include?('   Total   '))
 puts '**********************************'
 puts ''
 theater_num += 1
end

#Read line till you reach one of the theaters (first is usually AMC Metreon)
#
#parse each line to a columns of data
# watch out for continuation of next page, you will know because it will say continued and have same theater name
#halt till you reach Total, parse total, confirm parsed correctly by checking against total
#go to start of loop

