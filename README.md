# AMD Analysis

This repository provides R code and documentation for performing the **AMD analysis** (Average Membership Degree), a method designed to identify whether samples in a high-dimensional space form well-defined, discrete clusters, and to estimate their optimal number.

---

## 🧠 What is AMD analysis?

The AMD analysis is a two-step method to:

1. **Test whether samples in a multidimensional space form well-defined clusters** rather than being randomly or continuously distributed.
2. **Estimate the number of discrete groups** by identifying the value of *k* (number of clusters) that maximizes the average membership degree (AMD) in fuzzy clustering.
3. **Evaluate cluster compactness** by comparing real data to synthetic datasets with controlled dispersion.

The core idea is that **the AMD reaches a maximum when the number of user-defined clusters matches the actual structure of the data**.

---

## 📁 Repository structure

```
AMD-analysis/
├── R/                         # R functions to run the AMD analysis
│   ├── compute_amd_curve_function.R
│   ├── assign_clusters_best_function.R
│   ├── create_synthetic_samples_function.R
│   └── plot_amd_curve_function.R
├── example/                   # Example script using real or synthetic data
│   └── AMD_TG.R
├── data/                      # Example dataset (e.g., community trophic profiles)
│   └── dataAP.csv
├── docs/                      # Supporting documentation
│   ├── AMD_analysis.pdf
│   └── AMD_method_paper.pdf
├── README.md                  # This file
├── LICENSE                    # License for reuse (MIT by default)
└── .gitignore                 # Files to be ignored by Git
```

---

## 🚀 How to run the analysis

Make sure you have R installed and the following packages:
```r
install.packages(c("e1071", "ggplot2", "maps"))
```

Then source the functions and run the analysis:
```r
# Load functions
source("R/compute_amd_curve_function.R")
source("R/assign_clusters_best_function.R")
source("R/create_synthetic_samples_function.R")
source("R/plot_amd_curve_function.R")

# Load data
dataAP <- read.csv("data/dataAP.csv", row.names = 1)
data <- dataAP[, c("IFd", "GIn", "HIn", "IFr", "Crn", "Pln", "Frg", "Nct", "Grn")]

# Run AMD curve
amd_curve <- compute_amd_curve(data, its = 50, nin = 2, nsp = 17)

# Detect optimal number of clusters
opt_k <- which.max(amd_curve) + 1  # because nin = 2

# Assign best clusters
clusters <- assign_clusters_best(data, opt_k, nreps = 100)
dataAP$Clst <- as.factor(clusters)
```

Full working example: see [`example/AMD_TG.R`](example/AMD_TG.R)

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 📚 Citation

If you use this method in your research, please cite the following paper:

> [Biogeography of bird and mammal trophic structures — Supporting information: Multidimensional space exploration with ‘AMD analysis’. DOI: 10.5061/dryad.nk98sf7st](https://doi.org/10.5061/dryad.nk98sf7st)

---

## 🔽 Download

To download the entire AMD analysis package, click the green **Code** button on this page and select **Download ZIP**.

---

## 💬 Questions?

For questions or suggestions, feel free to open an [Issue](https://github.com/mmendoza1967/AMD-analysis/issues) or contact the author.
