
names <- ls("package:datasets")
data <- lapply(names, get, "package:datasets")

# this gets you list of variable names
names(data[[4]])[vapply(data[[4]], is.numeric, logical(1))]

find_filter()

find_filter <- function(data) {
  # stopifnot(is.data.frame(data))
  # stopifnot(is.function(filter))
  names(data)[vapply(data, filter, logical(1))]
}


df <- data[[4]]
data

vapply(data, is.data.frame, logical(1))

str(df)
