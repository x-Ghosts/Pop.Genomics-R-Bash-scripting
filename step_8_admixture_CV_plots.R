library(BITEV2)
library(tidyverse)
library(RCircos)

admixture_folder_name <- "admixture_analysis"
dataset_name <- "target_dataset_capre"
min_k <- 2
max_k <- 20

var_shape <-paste0("vec_", min_k, "_", max_k)
assign(var_shape, seq(min_k, max_k,1))
variable_k_assigned <- get(var_shape)

dirs <- list.dirs(".", full.names = F, recursive = F)
if (admixture_folder_name %in% dirs) {
  setwd(admixture_folder_name)
} else {
  stop("Folder not found: ", admixture_folder_name)
}


# If population files is expected to be loaded in the package for a clear Circos Stratification:
pop_file_txt <- read.table(paste0(admixture_folder_name,"/","target_mediterra_region.txt"), header = F, sep = " ", stringsAsFactors = F)

# Cross-Validation
membercoeff.cv(in.file = "log", out.file=paste0("Plot_",min_k,"_", max_k), software="Admixture", 
               minK=min_k, maxK=max_k, plot.format="pdf", plot.width=50, plot.height=40)

# Admixture plot
membercoeff.plot(in.file = dataset_name, out.file = "plot_", software = "Admixture",
                 maxK = 10, plot.main = "Admixture Plot", plot.format = "pdf", pop.order.file = "ordered_sorted.txt")

# Admixture Circos plot
membercoeff.circos(in.file = "merged_wild_domestic", out.file = "plot_circular_2_20_sorted", software = "Admixture",
                   maxK = 20, K.to.plot = vec_2_20, halfmoon = FALSE,
                   plot.main = "Admixture analysis", pop.order.file = "ordered_sorted.txt",
                   plot.format = "pdf", plot.width = 100, plot.height = 100)

# Admixture Circos plot
membercoeff.circos(in.file = "merged_wild_domestic", out.file = "plot_circular_2_20", software = "Admixture",
                   maxK = 20, K.to.plot = vec_2_20, halfmoon = FALSE,
                   plot.main = "Admixture analysis",
                   plot.format = "pdf", plot.width = 100, plot.height = 100)
