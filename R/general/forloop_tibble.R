# for loop over each row of a tibble
library(tidyverse)

tibble <- tibble(x = c(11,22,33), y = c(44,55,66), z = c(77,88,99))

for (i in 1:nrow(tibble)){
  
  x_i <- tibble %>% pull(x) %>% nth(i)
  y_i <- tibble %>% pull(y) %>% nth(i)
  z_i <- tibble %>% pull(z) %>% nth(i)
  
  print(paste("x val of row", i, "is", x_i))
  print(paste("y val of row", i, "is", y_i))
  print(paste("z val of row", i, "is", z_i))
  
}
