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

tmdb_find_uri = 'https://api.themoviedb.org/3/find/'
tmdb_movie_uri = 'https://api.themoviedb.org/3/movie/'
$tmdb_api_key = '424b564a6178750b94a5c1158a4fff0d'
$db = SQLite3::Database.new "box-office"

def get_uri_response (uri, params)
  uri = URI(uri)
  uri.query = URI.encode_www_form(params)
  res = Net::HTTP.get_response(uri)
  JSON.parse(res.body)
end

def get_tmdb_id (imdb_id)
  params = {api_key: $tmdb_api_key, external_source: 'imdb_id'}
  uri = "https://api.themoviedb.org/3/find/" + imdb_id
  results = get_uri_response(uri, params)
  results['movie_results'][0]['id']
end

def get_basic_info (tmdb_id)
  tmdb_id = tmdb_id.to_s
  params = {api_key: $tmdb_api_key}
  uri = "https://api.themoviedb.org/3/movie/" + tmdb_id
  response = get_uri_response(uri, params)
  info = {}
  info[:budget] = response['budget']
  genres = []
  response['genres'].each {|obj| genres.push(obj['name'])}
  info[:genres] = genres.join(',')
  info[:tmdb_popularity] = response['popularity']
  info[:release_date] = response['release_date']
  info[:revenue] = response['revenue']
  info[:runtime] = response['runtime']
  languages = []
  response['spoken_languages'].each{|obj| languages.push(obj['name'])}
  info[:languages] = languages.join(',')
  info[:tmdb_rating] = response['vote_average']
  info[:tmdb_votes] = response['vote_count']
  info
end

def get_credits tmdb_id
  tmdb_id = tmdb_id.to_s
  params = {api_key: $tmdb_api_key}
  uri = "https://api.themoviedb.org/3/movie/" + tmdb_id + "/credits"
  response = get_uri_response(uri, params)
  actors = []
  directors = []
  writers = []
  response['cast'].each do |credit|
    actors.push(credit['name'])
  end
  response['crew'].each do |credit|
    directors.push(credit['name']) if(credit['job'] == 'Director')
    writers.push(credit['name']) if(credit['job'] == 'Writer')
  end
  info = {}
  info[:actors] = actors.join(',')
  info[:directors] = directors.join(',')
  info[:writers] = writers.join(',')
  info
end

def get_keywords tmdb_id
  tmdb_id = tmdb_id.to_s
  params = {api_key: $tmdb_api_key}
  uri = "https://api.themoviedb.org/3/movie/" + tmdb_id + "/keywords"
  response = get_uri_response(uri, params)
  response = response['keywords']
  keywords = []
  response.each{|k| keywords.push(k['name'])}
  info = {}
  info['keywords'] = keywords.join(',')
  info
end

def get_ratings imdb_id
  imdb_id = imdb_id.to_s
  params = {i: imdb_id, tomatoes: true}
  uri = 'http://www.omdbapi.com/'
  response =  get_uri_response(uri, params)
  info = {}
  info['awards'] = response['Awards']
  info['metascore'] = response['Metascore']
  info['imdb_rating'] = response['imdbRating']
  info['imdb_votes'] = response['imdbVotes']
  info['tomato_critic_rating'] = response['tomatoRating']
  info['tomato_critic_votes'] = response['tomatoReviews']
  info['tomato_critic_meter'] = response['tomatoMeter']
  info['tomato_user_rating'] = response['tomatoUserRating']
  info['tomato_user_votes'] = response['tomatoUserReviews']
  info['tomato_user_meter'] = response['tomatoUserMeter']
  info['tomato_fresh_reviews'] = response['tomatoFresh']
  info['tomato_rotten_reviews'] = response['tomatoRotten']
  info
end

#get list of imdb ids
#movies = $db.execute('SELECT DISTINCT imdb_id from parkway_movies')
movies = $db.execute('select distinct s.imdb_id from parkway_daily_shows as s where s.imdb_id not in (select distinct imdb_id from movie_info) and s.imdb_id like "tt_______" order by s.imdb_id')
movies = movies.flatten

result = {}
params = Array.new(27){|k| '?'}
params = params.join(',')
movies.each do |imdb_id|
  next if imdb_id == nil || imdb_id == ''
  begin
    tmdb_id = get_tmdb_id(imdb_id)
    basic_info = get_basic_info(tmdb_id)
    credits = get_credits(tmdb_id)
    keywords = get_keywords(tmdb_id)
    ratings = get_ratings(imdb_id)
    result = basic_info.merge(credits).merge(keywords).merge(ratings)
    keys = ['imdb_id', 'tmdb_id'].concat(result.keys).join(',')
    values = [imdb_id, tmdb_id].concat(result.values)
    $db.execute("INSERT OR REPLACE INTO movie_info (" + keys + ") VALUES (" + params + ")", values)
  rescue
    pp "Error processing" + imdb_id.to_s
    next
  end
end

$db.close
