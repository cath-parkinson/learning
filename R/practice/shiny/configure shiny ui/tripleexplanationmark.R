library(rlang)

mylist <- list(x = 1:5, na.rm = F)
mylist <- exprs(x = 1:5, na.rm = F)
mean(!!!mylist)

eval(call2(mean, !!!mylist))
