## 
## Function makeCacheMatrix() creates a special CacheMatrix object which can store the inverse
## of a matrix so the inverse only needs to be calculated once 
##  
## Arguments: a Matrix
## 
## Returns: a list of functions defined on the given CacheMatrix
## 

makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    
    # set input matrix
    set <- function(y) {
      x <<- y
      m <<- NULL
    }
    
    # get the input matrix
    get <- function() x
    
    # set the inverse matrix
    setinverse <- function(solve) m <<- solve
    
    # get the inverse matrix
    getinverse <- function() m
    
    # return a list of functions
    list(set = set,
         get = get,
         setinverse = setinverse,
         getinverse = getinverse
        )
}


## 
## Function cacheSolve() computes the inverse of the special "matrix" returned by makeCacheMatrix(),
## if it has not already been computed; otherwise, it retrieves the inverse from the cache
## 
## Parameters: a Matrix (invertable)
##
## Returns: a matrix which is the inverse of the input one
## 

cacheSolve <- function(x, ...) {
	
    # get the inverse of 'x' from cache
    m <- x$getinverse()
    
    # return the inverse of 'x' if the inverse has already been calculated and cached
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    
    # calculate the inverse of 'x' if the cached data doesn't exist
    data <- x$get()
    m <- solve(data, ...)
    x$setinverse(m)
    
    # return the computed inverse of 'x'
    m
}