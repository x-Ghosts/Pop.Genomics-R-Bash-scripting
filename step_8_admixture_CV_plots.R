library(BITEV2)
library(tidyverse)
library(dplyr)
library(RCircos)

current_dir <- getwd(); current_dir
admixture_folder_name <- file.path(current_dir,"admixture_analysis")
dataset_name <- "target_dataset_capre"
min_k <- 2
max_k <- 20

var_shape <-paste0("vec_", min_k, "_", max_k)
assign(var_shape, seq(min_k, max_k,1))
variable_k_assigned <- get(var_shape)

dirs <- list.dirs(".", full.names = F, recursive = F)
if (dir.exists(admixture_folder_name)) {
  setwd(admixture_folder_name)
  paste0("new DIR: ",getwd())
} else {
  stop("Folder not found: ", admixture_folder_name)
}


# If population files is expected to be loaded in the package for a clear Circos Stratification

pop_file_name <- "target_mediterra_region.txt"
pop_file_path <- file.path(admixture_folder_name,pop_file_name)
pop_file_txt <- read.table(pop_file_path, header = F, sep = " ", stringsAsFactors = F)

# Cross-Validation
membercoeff.cv(in.file = "log", out.file=paste0("Plot_",min_k,"_", max_k), software="Admixture", 
               minK=min_k, maxK=max_k, plot.format="pdf", plot.width=50, plot.height=40)

# Admixture plot (Horizontal Plot) with population order:
fam_dataset <- read.table(paste0(dataset_name,".fam"), header = F, sep = " ", stringsAsFactors = F)
uniq_fam_fid <- unique(fam_dataset$V1)
false_ids <- base::setdiff(pop_file_txt$V1, unique(fam_dataset$V1)) # ID not matching between the datasets:

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
}


if (length(false_ids) > 0) {
  
  cat("The following populations are not present in the FAM file:\n\n")
  cat(paste0(" - ", false_ids), sep = "\n")
  
  answer <- readline("**************\n\nDelete them from the TXT list? (y/n): \n"
  )
  
  if (tolower(answer) %in% c("y", "yes")) {
    
    pop_file_txt <- pop_file_txt[!(pop_file_txt %in% false_ids)]
    cat("**************\nPopulation list updated.\n")
    write.table(pop_file_txt$V1,file = pop_file_path, quote = F, row.names = F, col.names = F)
    cat("**************\nPopulation list file is now overwritten !\n")
    
  } else {
    
    cat("**************\nKeeping the original population list unchanged.\n")
    
  }
}

fam_not_in_dataset <- subset(fam_dataset, !(V1 %in% pop_file_txt))

membercoeff.plot(in.file = dataset_name, out.file = "Plot_", software = "Admixture",
                 maxK = 10, plot.main = "Admixture Plot", plot.format = "pdf", pop.order.file = pop_file_name)

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
