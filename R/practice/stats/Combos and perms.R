#combinations and permutations

perm <- function(n,k){
  factorial(n) / factorial (n-k)
}

#order matters - so you get more possibilities 
#i.e. there is a difference between (1,0), and (0,1)
perm(6,4)

comb <- function(n,k){
  factorial(n) / (factorial(n-k)*factorial(k))
}

#order does not matter
#these do the same thing!
#the choose function is already base r
comb(6,4)
choose(6,4)
