# change the order of a list

x <- c("some content", 3)
y <- c("some content", 2)
z <- c("some content", 1)
a <- c("some content", 4)

mylist <- list(x,y,z,a)

order_org <- c("ord3", "ord2" , "ord1", "ord4")
order_new <- c("ord1", "ord2" , "ord3", "ord4")

# order list based on a names vector in a different order
names(mylist) <- order_org
mylist[order_new]

# then remove names
mylist <- unname(mylist)

names(mylist)





