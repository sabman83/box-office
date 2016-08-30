# A function used to extract the number of awards and nominations.
#
# TMDB/OMDB returns the awards information with sentences like " Won 1 Oscar. Another 21 wins & 15 nominations." or "Nominated for 2 Oscars. Another 29 wins & 59 nominations."
# This functions returns the total number of awards and nominations.
#
# @param str object text containing the awards information
# @param type string 'wins' or 'nominations'
#
# @return awards numeric
num_of_awards <- function(str, type) {
  if(type == 'wins') {
    pattern <- "Won (\\d+)|won (\\d+)|(\\d+) win|(\\d+) Win"
  } else if( type == 'nominations') {
    pattern <- "Nominated for (\\d+)|nominated for (\\d+)|(\\d+) Nominations|(\\d+) nominations"
  } else {
    stop('invalid award type')
  }
  str <- toString(str)
  awards <- 0
  if (nchar(str) == 0) {
    return(awards)
  }
  matches <- str_match_all(str, pattern)
  mtrx <- matches[[1]]

  if( (nrow(mtrx) == 0) | (ncol(mtrx) == 0) ) {
    return(awards)
  }
  for (i in 1:nrow(mtrx)) {
    for (j in 2:ncol(mtrx)) {
      if( nchar(mtrx[i,j]) > 0) {
        print(mtrx[i,j])
        awards <- awards + as.numeric(mtrx[i,j])
      }
    }
  }

  return (awards)
}
