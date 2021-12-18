#Data
revenue <- c(14574.49, 7606.46, 8611.41, 9175.41, 8058.65, 8105.44, 11496.28, 9766.09, 10305.32, 14379.96, 10713.97, 15433.50)
expenses <- c(12051.82, 5695.07, 12319.20, 12089.72, 8658.57, 840.20, 3285.73, 5821.12, 6976.93, 16618.61, 10054.37, 3803.96)

#Solution
length(expenses)
length(revenue)
round(profit <- revenue - expenses, 2)
round(profitaftertax <- revenue - (0.3*profit) - expenses,2) 
signif((profitmargin <- (profitaftertax / revenue)), 1) 
avr_profit <- mean(profitaftertax)
#using an ifelse which was tedius! 
goodmonths <- ifelse(profitaftertax > avr_profit, "TRUE", "FALSE")
badmonths <- ifelse(profitaftertax < avr_profit, "TRUE", "FALSE")
#actually you can just use vectors! And then if it's true it shows a "true" automatically
goodmonths <- profitaftertax > avr_profit
badmonths <- profitaftertax < avr_profit
#again you can use vectors for this too! this means "take the opposite" of the vector
badmonths <- !goodmonths
round(max(profitaftertax))
profitmax <- profitaftertax == max(profitaftertax) #compares our vector, to a vector of size 12 containing all the maximum values
profitmin <- profitaftertax == min(profitaftertax)

#matrices!!!






