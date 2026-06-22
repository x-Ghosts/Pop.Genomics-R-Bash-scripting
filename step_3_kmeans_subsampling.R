library(BITEV2)

setwd("/home/adam/Desktop/Alessio_Marco/datasets_v2/data_analysis/")


current_dir <- getwd()
output_directory <- "subsamples"
all_subset_directory <- file.path(current_dir,output_directory,"all_subsets")
dir.create(all_subset_directory, recursive = T)

ids_above_50 <- read.table("above_50.txt", stringsAsFactors = F)[[1]]



for (id in ids_above_50) {
  
  cat("Current ID processing: ", id,"\n" )
  cat("\n\n")
  
  id_directory <- file.path(current_dir, output_directory,id)
  setwd(id_directory)
  
  bed_file <- file.path(current_dir,output_directory,id,paste0(id,".bed"))
  cat("Current bed DIR:", bed_file, "\n")
  flush.console()
    
  gds.in <- bite.open(in.file = bed_file, out.dir = id_directory) 
  gds.path <- gds.in$filename
  
  subset.gds <- bite.kmeans.sampling(gds.path, out.dir = id_directory, n.iter = 100, n.subsample = 50)
  gds_samples <- bite.getdata("bite_km_subsample.gds", "sample.id")
  write.table(gds_samples, paste0(all_subset_directory,"/",id,".txt"),
              quote = FALSE,
              row.names = FALSE,
              col.names = FALSE
              )
  rm(gds_samples, gds.in, gds.path, subset.gds)
  gc()
  cat("Data saved !\n\n")
  }


