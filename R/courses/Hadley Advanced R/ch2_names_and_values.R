library(lobstr)

# binding ####

# it's easy to read this as "create an object called x, containing values 1,2,3"
# but that's a simplification
# in reality we're creating an object with values 1,2,3
# and we are BINDING it to a name "x"
x <- c(1, 2, 3)
y <- x
# this means the object doesn't have a name ...
# ... actually the NAME has a value

# above it looks like we've made two objects called x and y 
# but actually we've made one object with values 1,2,3
# and binded them to the names x and y
# we can see what the objects' memory address is below

# these are the same!!!
lobstr::obj_addr(x)
lobstr::obj_addr(y)

# so are all these methods of accessing the mean function
lobstr::obj_addr(mean)
lobstr::obj_addr(base::mean)
lobstr::obj_addr(get("mean"))
lobstr::obj_addr(evalq(mean))
lobstr::obj_addr(match.fun("mean"))

# copy-on modify ####
x <- c(1,2,3)
y <- x
lobstr::obj_addr(x)
lobstr::obj_addr(y)

y[[3]] <- 4
lobstr::obj_addr(x)
lobstr::obj_addr(y)

# you can see when an object has been copied by using base::tracemem()
# here we create object c(1,2,3) and bind it to the name x
# we then mark the object - so that a message will be printed whenever the internal code copies the object
# we could use this to diagnose when "copy-on-modify" is using a lot of memory

x <- c(1, 2, 3)
cat(tracemem(x), "\n")

y <- x
y[[3]] <- 4L # at this point we get a message to say it's been moved!

# the very same applys to function calls!!

f <- function(a) {
  a
}

x <- c(1, 2, 3)
cat(tracemem(x), "\n")

z <- f(x)
# there's no copy here!

untracemem(x)

# lists ####

l1 <- list(1, 2, 3)
l2 <- l1
l2[[3]] <- 4

# you can print a full list of the object 
lobstr::ref(l1,l2)

# object size ####

y <- rep(list(runif(1e4)), 100)

# use this function to tell us how much memory this object uses
# because the list is simply references to an object
# actually the object is the same - the reference is repeated
obj_size(y)
#> 80,896 B

# note this alternative function cannot tell if elements of the list are repeated
# therefore it assumes they are different
# note!! this matches the estimate given in rstudio
object.size(y)
#> 8005648 bytes

x <- c(1, FALSE)
typeof(x)