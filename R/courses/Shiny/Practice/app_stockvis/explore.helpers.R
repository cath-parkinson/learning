

symbols <- getSymbols("SRG", auto.assign = FALSE)

inflation <- if (!exists(".inflation")) {
  .inflation <- getSymbols('CPIAUCNS', src = 'FRED', 
                           auto.assign = FALSE)
  }  

inflation <- getSymbols('CPIAUCNS', src = 'FRED', 
           auto.assign = FALSE)

months <- split(symbols)

symbols.adfter <- adjust(symbols)
