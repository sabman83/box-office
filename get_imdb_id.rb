require 'net/http'
require 'pry'
require 'sqlite3'
require 'json'


base_search_uri = 'https://api.themoviedb.org/3/search/movie'
search_uri = URI(base_search_uri)

$api_key = '424b564a6178750b94a5c1158a4fff0d'
$db = SQLite3::Database.new "box-office"

#get list of movie names
movies = $db.execute('SELECT name from parkway_movies where imdb_id is null')
movies = movies.flatten

def store_id( movie, id)
  begin
    $db.query("UPDATE parkway_movies SET imdb_id = '" + id + "' WHERE name = ?",  movie )
  rescue
    binding.pry
  end
end

def get_and_store_movie(movie, id)
  params = {api_key: $api_key}
  base_movie_uri = 'https://api.themoviedb.org/3/movie/'
  movie_uri = URI(base_movie_uri + id)
  movie_uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(movie_uri)
  results = JSON.parse(res.body)
  return if results['imdb_id'].nil?
  store_id(movie,results['imdb_id'])
end

movies.each do |movie|

  # search movie
  params = {query: movie, api_key: $api_key}
  search_uri.query = URI.encode_www_form(params)

  res = Net::HTTP.get_response(search_uri)
  results = JSON.parse(res.body)['results']

  puts ''
  if results.size == 0
    print 'NO DATA FOUND FOR ', movie
    next
  end
  if results.nil? || results.size > 1
    print 'MORE THAN ONE ENTRY FOUND FOR ', movie
    #puts 'Following matches found: '
    #results.each_with_index do |result, index|
      #puts index.to_s + ' : ' + result['title'] + ' ' + result['release_date']
    #end
    #puts '99: to ignore'
    #idx = gets.chomp
    #idx = idx.to_i
    #next if idx == 99
    get_and_store_movie(movie, results[0]['id'].to_s)
    next
  end

  get_and_store_movie(movie, results[0]['id'].to_s)

  # get tmdb id

  # get imdb id

  #store imdb id
end

$db.close
