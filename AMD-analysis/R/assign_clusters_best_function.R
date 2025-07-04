

assign_clusters_best <- function(data, opt_cluster, nreps) {
  require(e1071)
  
  best_Mpm <- -Inf
  best_Clst <- NULL
  
  for (i in 1:nreps) {
    cl <- cmeans(data, opt_cluster, 20, verbose = FALSE, method = "cmeans", m = 2)
    Prob <- cl$membership
    Maxprob <- apply(Prob, 1, max)
    Mpm <- mean(Maxprob) - 1 / opt_cluster
    
    if (Mpm > best_Mpm) {
      best_Mpm <- Mpm
      best_Clst <- as.numeric(cl$cluster)
      cat("Repetición:", i, "Mpm =", round(Mpm, 4), "\n")
    }
    
  }
  
  return(best_Clst)
}
