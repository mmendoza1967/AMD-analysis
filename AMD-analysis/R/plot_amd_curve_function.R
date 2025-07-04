plot_amd_curve <- function(x_vals, y_vals, title = "AMD index", opt_cluster = NULL) {
  max_value <- max(y_vals)
  windows(); plot(x_vals, y_vals, type = "b", pch = 16, col = "black",
                  xlab = "Number of user-defined clusters", 
                  ylab = title,
                  xaxt = "n", xlim = range(x_vals))
  axis(1, at = x_vals)
  if (!is.null(opt_cluster)) {
    abline(v = opt_cluster, col = "blue", lty = 3)
    text(opt_cluster, max_value, labels = round(max_value, 3), pos = 4, col = "blue")
  }
}
