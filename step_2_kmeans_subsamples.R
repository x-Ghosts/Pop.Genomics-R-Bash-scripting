######################################################################################################################
# GPT was utilized for code debug.

library(BITEV2)

ids_above_30 <- read.table("above_30.txt", stringsAsFactors = F)[[1]]
dir_out <- "subsamples"
dir.create("subsamples", showWarnings = FALSE)

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  dir.create(id_path, recursive = T)
  
  keep_fam_file <- file.path(id_path, paste0(id, ".txt"))
  writeLines(id, keep_fam_file)
  
  output_plink_id <- file.path(id_path, id)
  sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile target_dataset_capre --keep-fam %s --make-bed --out %s", shQuote(keep_fam_file), shQuote(output_plink_id))
  cat("Current ID processing: ", id,"\n" )
  system(sys_cmd)
  cat("\n\n")
}

# Statistics on Missingness

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  bfile_plink <- file.path(id_path, id)
  
  # Statistics
  output_stats_folder <- file.path(id_path, "callrate")
  dir.create(output_stats_folder, recursive = T)
  output_missingness_file <- file.path(output_stats_folder,"missingness")
  
  
  sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --missing --out %s", shQuote(bfile_plink), shQuote(output_missingness_file))
  cat("Current ID processing: ", id,"\n" )
  system(sys_cmd)
  cat("\n\n")
}

# Plotting Missingness

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  bfile_plink <- file.path(id_path, id)
  output_stats_folder <- file.path(id_path, "callrate")
  output_missingness_file <- file.path(output_stats_folder,"missingness")
  
  locus_file <- file.path(paste0(output_missingness_file,".lmiss"))
  individual_file <- file.path(paste0(output_missingness_file,".imiss"))
  
  lmiss <-read.table(locus_file, header = TRUE, stringsAsFactors = FALSE)
  imiss <-read.table(individual_file, header = TRUE, stringsAsFactors = FALSE)
  
  plot_output_folder <- file.path(id_path, "plots")
  dir.create(plot_output_folder, recursive = T)
  plot_file <- file.path(plot_output_folder, "geno_mind.png")
  
  png(plot_file,
      width = 2400,
      height = 1200,
      res = 300)
  
  par(
    mfrow = c(1,2),
    cex.main = 1.2,
    cex.lab = 1.0,
    cex.axis = 0.9,
    mar = c(5,5,3,1)
  )
  
  hist(lmiss$F_MISS*100, col = "cyan", main = "Locus Missingness Histogram", breaks = 100, xlab = "% of Locus Missingness",xlim = c(0,100))
  abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)
  hist(imiss$F_MISS*100, col = "cyan", main = "Individuals Missingness Histogram", breaks = 100, xlab = "% of Individuals Missingness",xlim = c(0,100))
  abline(v = c(2, 5, 10), col = "red", lwd = 2, lty = 3)
  
  dev.off()
  
  cat("Plot processed for Fam ID: ", id,"\n" )
  cat("\n\n")
}


# Geno / Mind - 0.05

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  bfile_plink <- file.path(id_path, id)
  
  geno <- 0.05
  mind <- 0.05
  
  sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --geno %s --mind %s --make-bed --out %s", shQuote(bfile_plink), shQuote(geno), shQuote(mind), shQuote(bfile_plink))
  cat("Current ID processing: ", id,"\n" )
  system(sys_cmd)
  cat("\n\n")
}

# Statistics on Frequency - MAC / MAF

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  bfile_plink <- file.path(id_path, id)
  
  # Statistics
  output_stats_folder <- file.path(id_path, "frequency")
  dir.create(output_stats_folder, recursive = T)
  output_missingness_file <- file.path(output_stats_folder,"frequency")
  
  
  sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --freq --out %s", shQuote(bfile_plink), shQuote(output_missingness_file))
  cat("Current ID processing: ", id,"\n" )
  system(sys_cmd)
  cat("\n\n")
}

# Plotting Minor Allele Frequencies

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  bfile_plink <- file.path(id_path, id)
  output_stats_folder <- file.path(id_path, "frequency")
  output_missingness_file <- file.path(output_stats_folder,"frequency")
  
  freq_file <- file.path(paste0(output_missingness_file,".frq"))
  
  frq <-read.table(freq_file, header = TRUE, stringsAsFactors = FALSE)
  
  plot_output_folder <- file.path(id_path, "plots")
  dir.create(plot_output_folder, recursive = T)
  plot_file <- file.path(plot_output_folder, "maf.png")
  
  png(plot_file,
      width = 2400,
      height = 1200,
      res = 300)
  
  par(
    mfrow = c(1,1),
    cex.main = 1.2,
    cex.lab = 1.0,
    cex.axis = 0.9,
    mar = c(5,5,3,1)
  )
  
  hist(frq$MAF, main = "Histogram of Minor Allele Frequency - 0.05", xlab = "Frequency of the Minor Allele observed", xlim = c(0,0.5), col = "green", breaks = 50)
  abline(v=c(0,0.01,0.02,0.05), col="blue", lwd=2, lty=3)
  
  dev.off()
  
  cat("Plot processed for Fam ID: ", id,"\n" )
  cat("\n\n")
}

# MAF - 0.001

for (id in ids_above_30) {
  
  id_path <- file.path(dir_out, id)
  bfile_plink <- file.path(id_path, id)
  
  maf <- 0.001
  
  sys_cmd <- sprintf("plink --cow --allow-no-sex --nonfounders --allow-extra-chr --bfile %s --maf %s --make-bed --out %s", shQuote(bfile_plink), shQuote(maf), shQuote(bfile_plink))
  cat("Current ID processing: ", id,"\n" )
  system(sys_cmd)
  cat("\n\n")
}

# Kmeans Subsampling:

# [1] "/home/adam/Desktop/Alessio_Marco/datasets_v2/data_analysis"

library(BITEV2)

for (id in ids_above_30) {
 
  current_dir <- getwd()
  output_directory <- paste0(current_dir,"/",id)
  setwd(output_directory)
  
  if (dir.exists("../all_subsets") == FALSE){
    dir.create("../all_subsets")
  }
  
  gds.in <- bite.open(in.file = paste0(id,".bed"), out.dir = output_directory) 
  gds.path <- gds.in$filename
  
  subset.gds <- bite.kmeans.sampling(gds.path, out.dir = output_directory, n.iter = 100, n.subsample = 30)
  gds_samples <- bite.getdata("bite_km_subsample.gds", "sample.id")
  write.table(gds_samples, paste0("../all_subsets/sub_",id,".txt"),
              quote = FALSE,
              row.names = FALSE,
              col.names = FALSE
              )
  }




# Open the GDS file - 


gds.path <- gds.in$filename
gds.path

# Kmean Subsampling Method

subset.gds <- bite.kmeans.sampling(gds.path, out.dir = output_directory, n.iter = 100, n.subsample = 30)
gds_samples <- bite.getdata("bite_km_subsample.gds", "sample.id")
length(gds_samples)
write.table(gds_samples,
            "../all_subsets/sub_ALG.txt",
            quote = FALSE,
            row.names = FALSE,
            col.names = FALSE)
