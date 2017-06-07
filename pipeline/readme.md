# Overview

Parkway sends me the files in excel sheets to my gmail account. I filter these messages as read and mark them with label 'box-office'.
Recently they have been sending me pdf files but I should still be able to get it in excel sheets.

#Steps
1) The extract-parkway.js file will read the xls files and for each sheet, it will remove the dollar sign and commas from the numbers and save the files as text files.
Each sheet contains weekly data of the gross for each movie played during the week for each day. It has a total made during the week for each movie and the overall total.
2) the parse-parkway.rb file will then go through these text files and extract the movie name and gross and date and stored in parkway_daily_performance. The movies are stored in parkway_movies.
The parkway_movies table has a local id and the imdb_id which is generated from next step.
The totals are not stored in the database but are used to verify that the data has been parsed correctly. The text files are expected to be in a certain directory and after  they
have been parsed, they are moved to corrected_parkway_directory.
_Known Errors_: The date format might be messed up, like yyyy-mm-dd to yyyy-mm-dd where '-' is expected instead of 'to'. The total is not correct in original data. I had to manually correct it.
3) We then parse data from the google calendar using parse_parkway_calenda.rb. This has information on which movie was screened at what time, date, theater number and ticket price. Best of all it
has the imdb id. The data parsed from here is stored in parkway_daily_shows.
4)  get_imdb_id_from_shows_to_movies.rb is used to update all movies in the parkway_movies that dont have imdb_id. We first do a match on name on the parkway_daily_shows and if a single movie is found,
we update it with the imdb_id found in that row. Else we ignore and then we have to update it manually.
