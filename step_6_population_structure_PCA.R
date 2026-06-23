library(BITEV2)
library(tidyverse)
library(ggplot2)
library(ggrepel)
options(scipen = 999)

# Principle Component Analysis - Population Structure

current_dir <- getwd() # DIR must be ".../data_analysis" as current.

pca_path <- file.path(current_dir,"pca")
dir.create(pca_path)
output_pca_file <- file.path(pca_path,"pca")
plink_data <- "target_dataset_capre"

num_of_individuals <- nrow(read.table(paste0(plink_data,".fam"), header = F, sep = " ", stringsAsFactors = F))

sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --pca %s --out %s", shQuote(plink_data), shQuote(num_of_individuals), shQuote(output_pca_file))
system(sys_cmd)

# Variance Computation, and Plot generation:

pc1 <- 1
pc2 <- 2

eigenval_file <- file.path(paste0(output_pca_file,".eigenval"))
eigenvec_file <- file.path(paste0(output_pca_file,".eigenvec"))

pc_val <- read.table(eigenval_file, header = FALSE, stringsAsFactors = FALSE)
pc_vec <- read.table(eigenvec_file, header = FALSE, stringsAsFactors = FALSE)


total_var <- sum(pc_val$V1) # Explained variance
var_percent <- pc_val$V1 / total_var * 100
