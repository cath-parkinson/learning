# Testing the algorithms available in nloptr ------------------
library(dplyr)


# Curves I'm using https://www.desmos.com/calculator/mhwevi0tqk

# Set up an example
df <- dplyr::tibble(au = c("au1", "au2", "au3"),
                    b = c(4,3,6),
                    # Allocation units
                    a = c(2,2,3),
                    g = c(NA, NA, 3),
                    equation = c("neg_exp", "neg_exp", "scurve"))

# Helper functions

dimrets <- function(x, a, b){
  b * ( 1 - exp( -x / a ) )
}

# dimrets_gradient <- function(x, a, b){
#   (b/a) * exp(-(x/a))
# }

scurve <- function(x, a, b, g){
  (b * x^a) / (x^a + g^a)
}

# scurve_gradient <- function(x, a, b, g){
#   (b*a*(g^a)*(x^(a-1)))/((x^a + g^a)^2)
# }

# Objective function without gradient!
eval_f <- function(x, df, budget) {
  
  return <- c()
  # gradient <- c()
  
  for (i in 1:nrow(df)){
    
    a <- df %>% dplyr::pull(a) %>% dplyr::nth(i)
    b <- df %>% dplyr::pull(b) %>% dplyr::nth(i)
    g <- df %>% dplyr::pull(g) %>% dplyr::nth(i)
    equation <- df %>% dplyr::pull(equation) %>% dplyr::nth(i)
    
    # Update to accommodate if one of the xs is an scurve
    if(equation == "neg_exp"){
      
      return[i] <- dimrets(x[i], a, b)
      # gradient[i] <- dimrets_gradient(x[i], a, b)
      
    } else {
      
      return[i] <- scurve(x[i], a, b, g)
      # gradient[i] <- scurve_gradient(x[i], a, b, g)
      
    }
  }
  
  # we just sum up return for spend on each channel
  return = return %>% sum()
  
  return(-return)
  
  # return(list("objective" = -return, # negative as nloptr tries to minimise, whilst we're trying to maximise!
  #             "gradient" = -gradient))
}

# Equality constraint
eval_g_eq <- function(x, df, budget){
  
  # Function i.e. rearrange equation so it's equal 0
  sum(x) - budget
  
}

# eval_jac_g_eq <- function(x, df, budget){
#   
#   # Gradient
#   rep(1, length(x))
#   
# }

# Inequality constraints - we have multiple!
# So now we have
# x[1] >= 0 which becomes -x[1] <= 0
# x[2] >= 0 which becomes -x[2] <= 0
# x[3] >= 0 which becomes -x[3] <= 0


eval_g_ineq <- function(x, df, budget){
  
  # We can combine the inequality constraints into a vector
  c(-x[1], #inequality constraint 1 - function
    -x[2], #inequality constraint 2 - function
    -x[3]) #inequality constraint 3 - function
  
}

# eval_jac_g_ineq <- function(x, df, budget){
#   
#   # This is the jacobian (which is just a matrix where each row is the gradient of each of the above inequality constraints
#   # Number of rows = number of inequality constraints
#   # Number of dimensions in each row = number of x values e.g allocation units x1, x2, x3
#   rbind(
#     c(-1,0,0), # inequality constraint 1 - gradient (differentiate w.r.t x1, x2, x3)
#     c(0,-1,0),  # inequality constraint 2 - gradient (differentiate w.r.t x1, x2, x3)
#     c(0,0,-1)  # inequality constraint 3 - gradient (differentiate w.r.t x1, x2, x3)
#   )
#   
# }

  options <- list(
    # "algorithm"   = "NLOPT_LD_SLSQP",
    "algorithm"   = "NLOPT_GN_ISRES",
    "xtol_rel"    = 1e-3,
    # "xtol_rel"    = 1e-10,
    "ftol_rel"    = 1e-3,
    # "ftol_rel"    = 1e-10,
    "maxeval"     = 200000,
    "maxtime"     = 60,
    "print_level" = 1, # print to screen
    "randseed"    = 0
  )
  
  sol <- nloptr::nloptr(
    
    x0 = c(0,0,0),
    eval_f = eval_f,
    eval_g_eq = eval_g_eq,
    # eval_jac_g_eq = eval_jac_g_eq,
    # eval_g_ineq = NULL,
    eval_g_ineq = eval_g_ineq,
    # eval_jac_g_ineq = NULL,
    opts = options,
    lb = c(0,0,0),
    ub = c(100,100,100),
    # Additional parameters I'm passing, because they are needed by nloptr
    df = df,
    budget = 6
    
  )
  
  
  # The algorithm manages to get near the global minimum! But it doesn't quite obey the constraints
  # Now we can pass our x values into the starting values within our usual NLOPT_LD_SLSQP
  # Which works! And tidies up the x values so they both meet the constraint, and give us the best answer
  
  x <- sol$solution
  x
  eval_f(x, df, budget)*-1
  sum(x)
  
  # Now run it through the local optimiser
  
  dimrets_gradient <- function(x, a, b){
    (b/a) * exp(-(x/a))
  }
  
  scurve_gradient <- function(x, a, b, g){
    (b*a*(g^a)*(x^(a-1)))/((x^a + g^a)^2)
  }
  
  # Objective function with gradient
  eval_f <- function(x, df, budget) {
    
    return <- c()
    gradient <- c()
    
    for (i in 1:nrow(df)){
      
      a <- df %>% dplyr::pull(a) %>% dplyr::nth(i)
      b <- df %>% dplyr::pull(b) %>% dplyr::nth(i)
      g <- df %>% dplyr::pull(g) %>% dplyr::nth(i)
      equation <- df %>% dplyr::pull(equation) %>% dplyr::nth(i)
      
      # Update to accommodate if one of the xs is an scurve
      if(equation == "neg_exp"){
        
        return[i] <- dimrets(x[i], a, b)
        gradient[i] <- dimrets_gradient(x[i], a, b)
        
      } else {
        
        return[i] <- scurve(x[i], a, b, g)
        gradient[i] <- scurve_gradient(x[i], a, b, g)
        
      }
    }
    
    # we just sum up return for spend on each channel
    return = return %>% sum()
    
    return(list("objective" = -return, # negative as nloptr tries to minimise, whilst we're trying to maximise!
                "gradient" = -gradient))
  }
  
  
  eval_jac_g_eq <- function(x, df, budget){
    
    # Gradient
    rep(1, length(x))
    
  }
  
  options <- list(
    "algorithm"   = "NLOPT_LD_SLSQP",
    # "algorithm"   = "NLOPT_GN_ISRES",
    "xtol_rel"    = 1e-5,
    # "xtol_rel"    = 1e-10,
    "ftol_rel"    = 1e-4,
    # "ftol_rel"    = 1e-10,
    "maxeval"     = 2000,
    "maxtime"     = 60,
    "print_level" = 3, # print to screen
    "randseed"    = 0
  )
  
  sol <- nloptr::nloptr(
    
    x0 = x, # We want to use the starting values of the global optimiser
    eval_f = eval_f,
    eval_g_eq = eval_g_eq,
    eval_jac_g_eq = eval_jac_g_eq,
    eval_g_ineq = NULL,
    eval_jac_g_ineq = NULL,
    opts = options,
    lb = c(0,0,0),
    # Additional parameters I'm passing, because they are needed by nloptr
    df = df,
    budget = 6
    
  )
  
  # This only takes 5 iterations to find the answer!
  
  x <- sol$solution
  x # The optimum x is x <- c(1.3589702, 0.7806318, 3.8603980)
  eval_f(x, df, budget)$objective*-1 # The best answer is 7.025487
  sum(x)
  

