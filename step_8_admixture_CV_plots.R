library(BITEV2)
library(tidyverse)
library(dplyr)
library(RCircos)

current_dir <- getwd(); current_dir
admixture_folder_name <- file.path(current_dir,"admixture_analysis")
dataset_name <- "target_dataset_capre"
min_k <- 2
max_k <- 20

# Plot to K (For Circular Admixture - I want to plot from 2 to 6 as an example)
k_init <- 2
k_last <- 16
sequence_k <- 1 # can be set to 2 or more
var_shape <-paste0("vec_", k_init, "_", k_last)
assign(var_shape, seq(k_init, k_last,sequence_k))
variable_k_assigned <- get(var_shape)

dirs <- list.dirs(".", full.names = F, recursive = F)
if (dir.exists(admixture_folder_name)) {
  setwd(admixture_folder_name)
  paste0("new DIR: ",getwd())
} else {
  stop("Folder not found: ", admixture_folder_name)
}


# If population files is expected to be loaded in the package for a clear Circos Stratification


pop_file_txt <- read.table(pop_file_path, header = F, sep = " ", stringsAsFactors = F)

# Cross-Validation
membercoeff.cv(in.file = "log", out.file=paste0("Plot_",min_k,"_", max_k), software="Admixture", 
               minK=min_k, maxK=max_k, plot.format="pdf", plot.width=50, plot.height=40)

# Admixture plot (Horizontal Plot) with population order:
pop_file_name <- "target_mediterra_region.txt"
pop_file_path <- file.path(admixture_folder_name,pop_file_name)

fam_dataset <- read.table(paste0(dataset_name,".fam"), header = F, sep = " ", stringsAsFactors = F)
uniq_fam_fid <- unique(fam_dataset$V1)
pop_file_txt <- read.table(pop_file_path, header = FALSE, stringsAsFactors = FALSE)[[1]]
pop_file_txt <- trimws(pop_file_txt)

false_ids <- base::setdiff(pop_file_txt, unique(fam_dataset$V1))

if (length(false_ids) > 0) {
  
  cat("The following populations are not present in the FAM file:\n\n")
  cat(paste0(" - ", false_ids), sep = "\n")
  
  answer <- readline("**************\n\nDelete them from the TXT list? (y/n): \n")
  
  if (tolower(trimws(answer)) %in% c("y", "yes")) {
    
    pop_file_txt <- pop_file_txt[!(pop_file_txt %in% false_ids)]
    
    write.table(
      pop_file_txt,
      file = pop_file_path,
      quote = FALSE,
      row.names = FALSE,
      col.names = FALSE
    )
    
    cat("**************\nPopulation list updated & overwritten !\n")
    
  } else {
    cat("**************\nKeeping the original population list. You must correct the non-present FID in your population file.\n")
  }
} else {
  cat("**************\nPrior check on the population order file. All ID match with FID in your PLINK dataset.\n")
}


membercoeff.plot(in.file = dataset_name, out.file = "Plot_", software = "Admixture", add.to.single.pdf = TRUE,
                 maxK = max_k, plot.main = "Admixture Plot", plot.format = "pdf", pop.order.file = pop_file_name)

# Admixture Circos plot: Full Circle
membercoeff.circos(in.file = dataset_name, out.file = "Plot_Admixture_", software = "Admixture",
                   maxK = max_k, K.to.plot = variable_k_assigned, halfmoon = FALSE,
                   plot.main = "Admixture analysis", pop.order.file = pop_file_name,
                   plot.format = "pdf", plot.width = 100, plot.height = 100)


# # Admixture Circos plot: Halfmoon (BUG IDENTIFIED - May work if the number of FID's are small.)
# membercoeff.circos(in.file = dataset_name, out.file = "Plot_Admixture_", software = "Admixture",
#                    maxK = max_k, K.to.plot = variable_k_assigned, halfmoon = TRUE,
#                    plot.main = "Admixture analysis", pop.order.file = pop_file_name,
#                    plot.format = "pdf", plot.width = 100, plot.height = 100)
