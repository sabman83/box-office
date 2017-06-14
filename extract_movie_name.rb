require 'net/http'
require 'pry'
require 'sqlite3'
require 'json'

#Didn't work for following ids:
# tt0094517, tt1326956, tt3317022, tt4973120, tt3723828,
# tt3779276, tt2381957, tt3042792, tt1353056, tt1806837,
# tt2408586, tt2191562, tt3243102, tt2782392, tt4372362,
# tt0282948, tt0367279, tt3979094, tt1405357, tt2140655,
# tt1767353, tt1517069, tt4200182

$omdb_uri = 'http://www.omdbapi.com/'
$omdb_api_key = 'a6e2041f'
$db = SQLite3::Database.new "box-office"

def get_uri_response (uri, params)
  uri = URI(uri)
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  JSON.parse(res.body)
end

def get_basic_info (imdb_id)
  imdb_id = imdb_id.to_s
  params = {apikey: $omdb_api_key, i: imdb_id}
  pp params
  response = get_uri_response($omdb_uri, params)
  pp response
end

#get list of imdb ids
movies = $db.execute('select distinct imdb_id from movie_info where name is null')
movies = movies.flatten

result = {}
params = Array.new(27){|k| '?'}
params = params.join(',')
count  = 1
movies.each do |imdb_id|
  next if imdb_id == nil || imdb_id == ''
  count += 1
  sleep 2 if count % 10 == 0
  begin
    puts 'getting infor for ' , imdb_id
    basic_info = get_basic_info(imdb_id)
    keys = ['imdb_id','name'].join(',')
    values = [imdb_id,basic_info['Title']]
    query = "UPDATE movie_info SET name='"+basic_info['Title']+"', Country='"+basic_info['Country']+"' WHERE imdb_id='" +imdb_id+ "'"
    $db.execute(query)

  rescue Exception => e
    pp "Error processing" + imdb_id.to_s + e.to_s
    next
  end
end

$db.close

