# derive the IO table from the MRSUT tables and store results as clean rds files

# specifiy years to derive MRIO for
years = c(2014, 2020)
#year = 2020

indices <- readRDS(str_c(path$storeMRIOModel,"indices.rds"))

for(year in years){
  
  print( str_c("Computing MRIO for ",year," at ",Sys.time() ) )
  
  path_year <- paste0(path$storeMRIOModel,year,"/")
  
  if (!dir.exists(path_year)) {dir.create(path_year)} 

  # Read processing date of files of specific year
  date_T <- substr( list.files(path$rawMRIO), 1, 8)[grepl(paste0("_",year,"_"), list.files(path$rawMRIO))]
  date_Y <- substr( list.files(path$rawFD), 1, 8)[grepl(paste0("_",year,"_"), list.files(path$rawFD))]
  date_V <- substr( list.files(path$rawV), 1, 8)[grepl(paste0("_",year,"_"), list.files(path$rawV))]
  date_Q <- substr( list.files(path$rawExtension), 1, 8)[grepl(paste0("_",year,"_"), list.files(path$rawExtension))][1]
  
  
  # Read transaction matrix
  T <- fread( str_c(path$rawMRIO, "/", date_T, 
                    filename$pre, "T", filename$mid, year, filename$post) )
  
  # Read final demand matrix
  Y_raw <- fread( str_c(path$rawFD, "/", date_Y,
                        filename$pre, "Y", filename$mid, year, filename$post) )
  
  V_raw <- fread( str_c(path$rawV, "/", date_V,
                    filename$pre, "V", filename$mid, year, filename$post) )
  

  TQ <- fread( str_c(path$rawExtension, "/", date_Q,
                    filename$pre, "TQ", filename$mid, year, filename$post) )
  
  
  YQ <- fread( str_c(path$rawExtension, "/", date_Q,
                     filename$pre, "YQ", filename$mid, year, filename$post) )
  
  
  # Transform to matrix format
  T <- as.matrix(T) # as(T, "Matrix") # 
  Y_raw <- as.matrix(Y_raw) # as(Y_raw, "Matrix") 
  V_raw <- as.matrix(V_raw) 
  TQ <- as.matrix(TQ)
  YQ <- as.matrix(YQ)
  
  # Subset matrices to get variables
  S <- T[indices$ind,indices$pro]
  U <- T[indices$pro,indices$ind]
  Y <- Y_raw[indices$pro,]
  V <- V_raw[,indices$ind]
  ZQ <- TQ[,indices$ind]
  
  rm(T, Y_raw, TQ)
  
  # Set negatives due to stock changes to zero
  #Y[Y < 0] <- 0
  
  # Gross production of all industries (x) and products (q)
  q <- rowSums(U) + rowSums(Y)
  if(min(q) < 0) stop("negatives in q")
  q[q == 0] <- 10^-7
  
  D <- t( t(S) / colSums(S) ) # Commodity proportions i.e. market share matrix (ixp)
  D[is.na(D)] <- 0            # Set NaN (due to zero gross output) to zero
  
  x <- colSums( t(D) * q )  # If x is calculated directly from S, this results in negative values in L
  # TODO: why does this differ from colSums(S)?
  x[x == 0] <- 10^-7
  
  # since all sectors produce only one product, q should be equal to x
  all.equal(q, x)
  
  # Commodity by industry coefficient matrix
  B <- t(t(U)/x)
  # TODO:why are there values and column sums >1 here? This causes values >1 in A and then negatives in L!
  
  # Set NaN (due to zero gross output) to zero
  B[is.na(B)] <- 0                
  B[B == Inf] <- 0
  
  # Calculate pro-by-pro technology matrix
  A <- B %*% D
  
  # Set negative and very small values to zero to allow inversion 
  if(min(A) < 0) stop("negatives in q")
  # A[A < 0] <- 0
  
  # generate Z
  q[q == 10^-7] <- 0
  Z <- t(t(A)*q)
  
  #Z1 <- t(t(D %*% B)*x)
  
  #fwrite( A, str_c(path_year,year,"_A.csv") )
  #fwrite( S, str_c(path_year,year,"_S.csv") )
  #fwrite( U, str_c(path_year,year,"_U.csv") )
  #fwrite( Y, str_c(path_year,year,"_Y.csv") )
  #fwrite( Z, str_c(path_year,year,"_Z.csv") )
  #fwrite( data.table(q = q), str_c(path_year,year,"_q.csv") )
  
  saveRDS( A, str_c(path_year,year,"_A.rds") )
  #saveRDS( S, str_c(path_year,year,"_S.rds") )
  #saveRDS( U, str_c(path_year,year,"_U.rds") )
  saveRDS( Y, str_c(path_year,year,"_Y.rds") )
  saveRDS( V, str_c(path_year,year,"_V.rds") )
  saveRDS( Z, str_c(path_year,year,"_Z.rds") )
  saveRDS( q, str_c(path_year,year,"_x.rds") ) # saving q under the name of x for clarity
  saveRDS( ZQ, str_c(path_year,year,"_ZQ.rds") )
  saveRDS( YQ, str_c(path_year,year,"_YQ.rds") )
  
  
  
  
  # Create identity matrix
  I <- diag( rep( 1,nrow(A) ) )
  
  # Set diagonal values that are zero to small number 
  diag(A)[diag(A) == 0] <- 10^-7
  
  # Create inverse
  L <- solve(I - A)
  #fwrite( L, str_c(path_year,year,"_L.csv") )
  saveRDS(L, str_c(path_year,year,"_L.rds"))

  print("Minimum value in L")
  print(min(L))
  print("Sum of L")
  print(sum(L))
  print("Sum of orginal production")
  print( sum(q) )
  print("Sum of production when using L")
  print( sum(t(L) * rowSums(Y) ) )
  
  print("Rowsums of Z + Y == q?")
  print( all.equal(rowSums(Z)+rowSums(Y), q, tolerance = 0.01 ) )
  
}
  