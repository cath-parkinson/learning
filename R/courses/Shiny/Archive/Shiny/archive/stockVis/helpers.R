# the "." in front of inflation creates a hidden object
# you can reveal this object by running ls(all.names = TRUE)
# it's getting the consumer confidence index by year, which is an xts object (looks a bit like a DF with names rows)
# first it checks if this object already exists, if not it gets it

if (!exists(".inflation")) {
  .inflation <- getSymbols('CPIAUCNS', src = 'FRED', 
     auto.assign = FALSE)
}  

#inflation <- .inflation

# adjusts Google finance data with the monthly consumer price index 
# values provided by the Federal Reserve of St. Louis
# historical prices are returned in present values 
adjust <- function(data) {

      latestcpi <- last(.inflation)[[1]]
      inf.latest <- time(last(.inflation))
      months <- split(data)               
      
      adjust_month <- function(month) {               
        date <- substr(min(time(month[1]), inf.latest), 1, 7)
        coredata(month) * latestcpi / .inflation[date][[1]]
      }
      
      adjs <- lapply(months, adjust_month)
      adj <- do.call("rbind", adjs)
      axts <- xts(adj, order.by = time(data))
      axts[ , 5] <- Vo(data)
      axts
}