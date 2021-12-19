library(dplyr)

# operations on vectors #####

# note the behavior of the relational operators
# they will operate on character vectors by comparing the first letter of the alphabet!

"one" < "two"
# TRUE
"one" < "zero"
# TRUE
"six" < "seven"
# FALSE

# setting and getting attributes #####

a <- 1:3
attributes(a)
attr(a, "x") <- "abcdef"
attr(a, "x")
#> [1] "abcdef"

attr(a, "y") <- 4:6
str(attributes(a))
#> List of 2
#>  $ x: chr "abcdef"
#>  $ y: int [1:3] 4 5 6

# Or equivalently
a <- structure(
  1:3, 
  x = "abcdef",
  y = 4:6
)
str(attributes(a))
#> List of 2
#>  $ x: chr "abcdef"
#>  $ y: int [1:3] 4 5 6

# arrays and matrices

# first element is data to be contained in the array
# then we specify the number of rows, columns and slices
y <- array(1:12, c(2, 3, 2))

# view these objects
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))

x1
x2
x3

# set all attributes with structure
structure(1:6, dim = 2:3)
structure(1:5, names = "my atrribute")
structure(1:5, names = rep("my atrribute",5))

w <- structure(1:5, comment = "my atrribute")
attributes(w)
w

# note that S3 atomic vectors are build on top of base r atomic vectors
grade <- ordered(c("b", "b", "a", "c"), levels = c("c", "b", "a"))
grade

typeof(grade)
# integer
attributes(grade)

today <- Sys.Date()

typeof(today)
#> [1] "double"
attributes(today)
#> $class
#> [1] "Date"

# Be careful with factor variables!
# the levels overlays a key on the data, so really you are saying "a" is equal to "z"
# therefore if you reverse the levels, you reverse the data you will see when you print the object
f1 <- factor(letters)
f1
levels(f1)
rev(levels(f1))

levels(f1) <- rev(levels(f1))
f1
# and remember a factor is build off a integer type, the levels ar order 1 upwards

# lists ####

l4 <- list(list(1, 2), c(3, 4))
l5 <- c(list(1, 2), c(3, 4))
str(l4)
#> List of 2
#>  $ :List of 2
#>   ..$ : num 1
#>   ..$ : num 2
#>  $ : num [1:2] 3 4
str(l5)
#> List of 4
#>  $ : num 1
#>  $ : num 2
#>  $ : num 3
#>  $ : num 4

# tibbles and data.frames ####

df <- dplyr::starwars
attributes(df)
ex1 <- df[ , "height"]
ex1
attributes(ex1)

df3 <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"))
df3

# this creates a dataframe with 0 columns and zero rows
df1 <- data.frame(x = NULL, y = NULL)
df2 <- data.frame(a = NULL, b = NULL)
df1
df2


df3 <- data.frame(
  age = c(35, 27, 18),
  hair = c("blond", "brown", "black"))
attributes(df3)

# creates a dataframe with 0 rows, and 2 columns
df4 <- subset(df3, age < 18)
df5 <- df3[1:3, , drop = FALSE]

# creates a dataframe with 3 rows and 0 columns
df6 <- data.frame(a=1:200)
df6$a <- NULL




