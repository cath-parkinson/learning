v <- c("EN9 1PH", "IG10 4LT", "L32 6QJ")


short_postcode <- function(x){
  
  ifelse(grepl("[0-9]+",substr(x, 1,2)),substr(x, 1, 1),
         substr(x, 1, 2))
}

short_postcode(v)

