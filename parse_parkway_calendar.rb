require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'date'
require 'pry'
require 'fileutils'

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
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# Fetch the next 10 events for the user
parkway_1_calendar_id = 'thenewparkway.com_25uhqvcd5conik66ephgqe7j28@group.calendar.google.com'
parkway_2_calendar_id = 'thenewparkway.com_ighfjtidsap0o4oaubh7nfnqq0@group.calendar.google.com'
starting_date  = Time.new(2012,12,22).to_datetime
IMDB_PRICE_REGEX = /(tt\d+)[\s\S]*Admission Price:.*\$(\d+)/
response_1 = service.list_events(parkway_1_calendar_id,
                               max_results: 100,
                               single_events: true,
                               order_by: 'startTime',
                               time_max: (starting_date + 1).rfc3339,
                               time_min: (starting_date).rfc3339)

response_2 = service.list_events(parkway_2_calendar_id,
                               max_results: 100,
                               single_events: true,
                               order_by: 'startTime',
                               time_max: (starting_date + 1).rfc3339,
                               time_min: (starting_date).rfc3339)


puts "Upcoming events:"
puts "No upcoming events found in theater 1" if response_1.items.empty?
puts "No upcoming events found in theater 2" if response_2.items.empty?

movies = {}
//TODO: refactror and user imdb_id instead of name to build hash
response_1.items.each do |event|
    start = event.start.date || event.start.date_time
    puts "SUMMARY: #{event.summary} - DESCRIPTION: #{event.description} (#{start})"
    movie_info = event.description.match(IMDB_PRICE_REGEX)
    movies[event.summary.strip] ||= {}
    movies[event.summary.strip]['imdb_id'] = movie_info[1]
    movies[event.summary.strip]['shows'] = movies[event.summary.strip]['shows'].nil? ? 1
                                                                                     : movies[event.summary.strip]['shows'] + 1
end
response_2.items.each do |event|
    start = event.start.date || event.start.date_time
    puts "SUMMARY: #{event.summary} - DESCRIPTION: #{event.description} (#{start})"
    movie_info = event.description.match(IMDB_PRICE_REGEX)
    movies[event.summary.strip] ||= {}
    movies[event.summary.strip]['imdb_id'] = movie_info[1]
    movies[event.summary.strip]['shows'] = movies[event.summary.strip]['shows'].nil? ? 1
                                                                                     : movies[event.summary.strip]['shows'] + 1
end
puts movies
