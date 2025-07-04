# AMD Analysis: Detecting discrete patterns in multidimensional spaces

# Step 1: Detect whether well-defined clusters exist in the trophic structure
#         of a set of bird and mammal communities overlapping protected areas.

# Step 2: Classify samples into clusters and visualize them.

# Step 3: Generate a synthetic reference framework to evaluate the compactness
#         of the identified clusters. The side of the hypercube is 100, so
#         standard deviations represent percentages of that range.

library(e1071)
library(ggplot2)
library(maps)

rm(list = ls(all = TRUE))
set.seed(2)

setwd("D:/Science/AMD GitHup/AMD-analysis/data")  # Adjust to your local path

# Load data
dataAP <- read.csv("dataAP.csv", row.names = 1)

# Select variables defining the n-dimensional space
data <- dataAP[, c("IFd", "GIn", "HIn", "IFr", "Crn", "Pln", "Frg", "Nct", "Grn")]

# ----- Step 1: AMD curve to detect clusters -----

setwd("D:/Science/AMD GitHup/AMD-analysis/R")  # Adjust to your local path

source("compute_amd_curve_function.R")  # Load AMD curve function

# Configuration parameters
its <- 50      # Number of repetitions per cluster count
nin <- 2       # Minimum number of clusters to test
nsp <- 17      # Maximum number of clusters to test

# Compute AMD curve
amd_curve <- compute_amd_curve(data, its, nin, nsp)
print(amd_curve)

# Determine optimal number of clusters (k with highest AMD)
x_vals <- as.numeric(names(amd_curve))
y_vals <- amd_curve
opt_cluster <- x_vals[which.max(y_vals)]
max_value <- max(y_vals)

# Plot the AMD curve
source("plot_amd_curve_function.R")
plot_amd_curve(x_vals, y_vals, "AMD index", opt_cluster)

# Interpretation:
# The peak in the AMD curve suggests that 'opt_cluster' is the number of well-defined groups
# in the multidimensional space. The higher the AMD value, the more internally consistent 
# the clusters.

message("AMD peak detected at k = ", opt_cluster,
        ". This likely reflects the true number of discrete groups in the data.")

# To evaluate the compactness of the detected clusters, proceed to Step 3.

# ----- Step 2: Cluster assignment and visualization -----

source("assign_clusters_best_function.R")  # Load best clustering assignment

# Run fuzzy clustering and select the best repetition
Clst <- assign_clusters_best(data, opt_cluster, nreps = 100)
dataAP$Clst <- as.factor(Clst)

# Save classification results
write.csv(dataAP, "dataAPClst.csv", row.names = FALSE)

# Load world map
world <- map_data("world")

# Color palette for clusters
palette <- c("grey45", "navy", "skyblue", "gold", "green3", 
             "darkgreen", "saddlebrown")[1:opt_cluster]

# Plot clusters on world map
windows(); ggplot() + 
  theme(panel.background = element_blank(), panel.grid = element_blank(),
        axis.text = element_blank(), axis.ticks = element_blank()) +
  xlab("") + ylab("") +
  geom_point(data = dataAP, aes(x = lon, y = lat, color = Clst), size = 1) +
  scale_color_manual(values = palette) +
  geom_path(data = world, aes(x = long, y = lat, group = group)) +
  guides(colour = guide_legend(override.aes = list(size = 5))) +
  annotate("text", x = -160, y = 80, label = paste("n clusters =", opt_cluster),
           hjust = 0, vjust = 1, size = 4, color = "black")

# ----- Step 3: Generate synthetic reference to evaluate compactness -----

# Try different values of std_dev (e.g., 5, 10, 15) to create AMD curves
# with varying compactness and compare them with the curve from real data.

source("create_synthetic_samples_function.R")

nsamples <- nrow(data)
n_clusters <- opt_cluster
n_dim <- ncol(data)
std_dev <- 10  # Standard deviation as percentage of cube side (100)

# Generate synthetic samples
create_synthetic_samples(nsamples, n_clusters, std_dev, n_dim)

# Recompute AMD curve on synthetic data
amd_curve <- compute_amd_curve(data, its, nin, nsp)

x_vals <- as.numeric(names(amd_curve))
y_vals <- amd_curve
opt_cluster <- x_vals[which.max(y_vals)]
max_value <- max(y_vals)

# Plot AMD curve for synthetic data
plot_amd_curve(x_vals, y_vals, "AMD index (synthetic data)", opt_cluster)

