require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'date'
require 'pry'
require 'fileutils'
require 'sqlite3'

db = SQLite3::Database.new "box-office"
OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Parkway'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                            "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
##
## Ensure valid credentials, either by restoring from the saved credentials
## files or intitiating an OAuth2 authorization. If authorization is required,
## the user's default browser will be launched to approve the request.
##
## @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(
      base_url: OOB_URI)
    puts "Open the following URL in the browser and enter the " +
         "resulting code after authorization"
    puts url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

# Initialize the API
$service = Google::Apis::CalendarV3::CalendarService.new
$service.client_options.application_name = APPLICATION_NAME
$service.authorization = authorize

# Fetch the next 10 events for the user
theater_1_calendar_id = 'thenewparkway.com_25uhqvcd5conik66ephgqe7j28@group.calendar.google.com'
theater_2_calendar_id = 'thenewparkway.com_ighfjtidsap0o4oaubh7nfnqq0@group.calendar.google.com'
IMDB_REGEX = /(tt\d+)/
PRICE_REGEX = /[\s\S]*Admission Price:.*\$(\d+)/

def get_events cal_id, token=nil
  start_date  = Time.new(2012,12,22).to_datetime
  end_date  = Time.new(2016,03,31).to_datetime

  response = $service.list_events(cal_id,
                               max_results: 2500,
                               single_events: true,
                               order_by: 'startTime',
                               time_max: (end_date).rfc3339,
                               time_min: (start_date).rfc3339,
                               page_token: token)
  response
end

def get_all_events cal_id
  page_token = nil
  events = []
  while true do
    response_1 = get_events cal_id, page_token
    events += response_1.items
    break if response_1.next_page_token == nil || response_1.next_page_token.size == 0
    page_token = response_1.next_page_token
  end
  events
end

theater_1_events = get_all_events theater_1_calendar_id
theater_2_events = get_all_events theater_2_calendar_id
events = theater_1_events + theater_2_events
previous_price = 6
puts "TOTAL EVENTS ",  events.size
binding.pry
events.each do |event|
    movies = {}
    start = event.start.date || event.start.date_time
    #puts "SUMMARY: #{event.summary} - DESCRIPTION: #{event.description} (#{start})"
    imdb_id = event.description.match(IMDB_REGEX) unless event.description.nil?
    price = event.description.match(PRICE_REGEX) unless event.description.nil?
    movie_name = event.summary.strip
    if imdb_id.nil?
      puts "No IMDB id found",event.summary
      imdb_id = movie_name
    else
      imdb_id = imdb_id[1]
    end
    if price.nil?
      puts 'No Price found for', event.summary
      price = previous_price
    else
      previous_price = price[1]
      price = price[1]
    end
    imdb_id = imdb_id
    movies[imdb_id] ||= {}
    movies[imdb_id]['name'] = movie_name
    movies[imdb_id]['price'] = price
    if start.class.to_s == 'DateTime'
      movies[imdb_id]['time'] = start.strftime('%H:%M')
      movies[imdb_id]['date'] = start.to_date.to_s
    else
      movies[imdb_id]['time'] = '00:00'
      movies[imdb_id]['date'] = start.to_s
    end
    movies[imdb_id]['theater'] = event.organizer.email == theater_1_calendar_id ? 1 : 2
    begin

      db.execute('INSERT INTO parkway_daily_shows(imdb_id, name, theater, time,  date, price) VALUES (?,?,?,?,?,?)',
                                                              imdb_id, movie_name, movies[imdb_id]['theater'],
                                                              movies[imdb_id]['time'],
                                                              movies[imdb_id]['date'],
                                                               movies[imdb_id]['price'])
    rescue
      binding.pry
    end
    #puts movies
end
db.close
