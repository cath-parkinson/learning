

x <- c(1,2,3)

test_function <- function(input, x){
  
  if(input == 1){
    
    print(input)
    print("stop function")
    
    } else 
    { 
      
      input <- input + 1
      print(input)
      print("function has continued")
  
    
    }
  
  
}

test_function(input = 3, x)
