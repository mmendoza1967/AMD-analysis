

create_synthetic_samples <- function(n_samples, n_clusters, std_dev, n_dim) {
  require(stats)
  
  cube_size <- 100  # lado del hipercubo
  
  # Generar centroides dentro del hipercubo
  centers <- matrix(runif(n_clusters * n_dim, 0.2 * cube_size, 0.8 * cube_size), nrow = n_clusters)
  
  # Muestras por grupo (aprox. equitativo)
  samples_per_cluster <- floor(n_samples / n_clusters)
  
  # Generar muestras para cada cluster
  data <- do.call(rbind, lapply(1:n_clusters, function(i) {
    cov_factors <- runif(n_dim, 0.5, 1.5)  # variabilidad por dimensión
    matrix(rnorm(samples_per_cluster * n_dim,
                 mean = rep(centers[i, ], each = samples_per_cluster),
                 sd   = rep(std_dev * cov_factors, each = samples_per_cluster)),
           ncol = n_dim)
  }))
  
  # Añadir muestras extra si hace falta
  remaining <- n_samples - nrow(data)
  if (remaining > 0) {
    assignments <- sample(1:n_clusters, size = remaining, replace = TRUE)
    extras <- do.call(rbind, lapply(assignments, function(i) {
      cov_factors <- runif(n_dim, 0.5, 1.5)
      matrix(rnorm(n_dim, mean = centers[i, ], sd = std_dev * cov_factors), nrow = 1)
    }))
    data <- rbind(data, extras)
  }
  
  # Asignar nombres
  colnames(data) <- paste0("Dim", 1:n_dim)
  
  # Asignar globalmente
  assign("data", as.data.frame(data), envir = .GlobalEnv)
  
  cat(n_samples, "samples were generated in", n_clusters,
      "groups with random deviation per dimension (mean =", std_dev, ")\n")
}
