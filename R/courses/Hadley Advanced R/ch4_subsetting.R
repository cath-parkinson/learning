# subsetting #####
x <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"))

x[] <- 0
x

x <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"))
x <- 0
x

# if the vector is named you can subset based on the name
x <- c(2.1, 4.2, 3.3, 5.4)
y <- setNames(x, letters[1:4])
y
y[c("d", "c", "a")]

# Like integer indices, you can repeat indices
y[c("a", "a", "a")]

# When subsetting with [, names are always matched exactly
z <- c(abc = 1, def = 2)
z[c("a", "d")]
z[c("abc", "def")]

# examples - these all work
mtcars <- mtcars
mtcars[mtcars$cyl == 4, ]
mtcars[-c(1:4), ]
mtcars[mtcars$cyl <= 5,]
mtcars[mtcars$cyl == 4 | mtcars$cyl ==6, ]

# understanding the behaviours
x <- 1:5
x
x[9] #NA as there is no 9th element
x[TRUE] #all five elements, as it recycles the logical
x[c(TRUE,TRUE, FALSE,FALSE, FALSE)] # the first 2 elements
x[c(TRUE,FALSE)] # every other element
x[FALSE] # this gets an empty vector
x[c(FALSE, FALSE, FALSE, FALSE, FALSE)] # also an empty vector
x[NA] # when we set the index to NA we always get NA, and here it is recyled
x[c(NA,TRUE,FALSE)] # NA gives NA, FALSE gives nothing, then it recycles 

x[NA_real_] #


