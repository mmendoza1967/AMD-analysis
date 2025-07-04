

compute_amd_curve <- function(data, its, nin, nsp) {
  require(e1071)
  
  Maxpms <- c()
  
  for (k in 1:its) {
    Maxpm <- c()
    
    for (i in nin:nsp) {
      cl <- cmeans(data, i, 20, verbose = FALSE, method = "cmeans", m = 2)
      Prob <- cl$membership
      Maxprob <- apply(Prob, 1, max)
      Mpm <- mean(Maxprob) - 1 / i
      Maxpm <- c(Maxpm, Mpm)
    }
    
    Maxpms <- rbind(Maxpms, Maxpm)
    cat("Iteration:", k, "\n")
  }
  
  # Calcular el valor máximo de AMD para cada número de clusters
  amd_values <- apply(Maxpms, 2, max)
  names(amd_values) <- nin:nsp
  
  return(amd_values)
}
