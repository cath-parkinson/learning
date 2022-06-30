#https://stackoverflow.com/questions/37344153/applying-a-list-of-functions-to-a-list-of-arguments/37344335#37344335
fncs <- list("mean", "median", "sd")
args <- list(1:5, 11:13, c(1,1,1,2))
Map(function(f, x) do.call(f, list(x)), fncs, args)


myfunc <- function(f,x){
  
  # the second argument must be passed as a list!
  
  do.call(what = f, args = list(x))
  
}

# so Map says
# in loop 1 take first element of fncs and first element of args
# pass them to myfunc
Map(myfunc, fncs, args)

# exciting! the first argument can be either a function or a character string naming the function
y <- 1:5
do.call("mean", list(y), quote =T)
do.call(mean, list(1:5))

list(args[[1]])
list(1:5)
