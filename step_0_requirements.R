#################################################################################
cat("****** Checking OS Systems dependencies (Currently Linux - deb)\n\n")
warning(
  paste(
    "Update/Install missing system packages by pasting the commands:",
    "sudo apt install libgsl-dev libboost-all-dev",
    "libfontconfig1-dev libharfbuzz-dev",
    "libfribidi-dev libfreetype6-dev",
    "libpng-dev libtiff5-dev",
    "libjpeg-dev libwebp-dev",
    sep = "\n"
  )
)

#################################################################################

cat("****** Checking installed softwares\n\n")

softwares <- c(
  "plink",
  "admixture",
  "treemix",
  "python3"
)

missing_soft <- character()

for (prg in softwares) {
  path <- Sys.which(prg)
  if (path == "") {
    cat("[MISSING] ", prg, "\n", sep = "")
    missing_soft <- c(missing_soft, prg)
  } else {
    cat("[OK] ", prg, " -> ", path, "\n", sep = "")
  }
  
}

if (length(missing_soft) > 0) {
  cat("\nThe following softwares are required:\n\n")
  for (prg in missing_soft) {
    if (prg == "python3") {
      cat("- Install Python >= 3.12:\n")
      cat("  sudo apt install python3\n\n")
    } else if (prg == "plink") {
      cat("- Install PLINK 1.9:\n")
      cat("  Download: https://www.cog-genomics.org/plink/\n")
      cat("  Extract the downloaded archive.\n")
      cat("  Then enter the extracted folder and run:\n")
      cat("  sudo cp plink /usr/local/bin/\n\n")
    } else if (prg == "admixture") {
      cat("- Install ADMIXTURE:\n")
      cat("  Download: https://dalexander.github.io/admixture/binaries/admixture_linux-1.4.0.tar.gz\n")
      cat("  Extract it, then copy the binary:\n")
      cat("  sudo cp admixture /usr/local/bin/\n\n")
    } else if (prg == "treemix") {
      cat("- Install TreeMix:\n")
      cat("  Download: https://bitbucket.org/nygcresearch/treemix/downloads/treemix-1.13.tar.gz\n")
      cat("  Extract it, then follow the steps:\n")
      cat("  1- cd PATH_OF_EXTRACTED_TREEMIX\n")
      cat("  2- sudo ./configure\n")
      cat("  3- sudo make\n")
      cat("  4- sudo make install\n\n")
    } else {
      cat("- Missing:", prg, "\n")
      cat("  Please install it and ensure it is available in your environment PATH.\n\n")
    }
  }
  stop("Install the missing softwares and rerun this script.")
} else {
  cat("Softwares installed in your system are compatible with future scripts.\n")
  cat("Test the R package dependencies next.\n")
}


#################################################################################

cat("****** Checking installed R packages\n\n")

packages <- c(
  "BITEV2",
  "tidyverse",
  "dplyr",
  "RCircos"
)

missing_packages <- packages[
  !sapply(packages, requireNamespace, quietly = TRUE)
]


if(length(missing_packages) > 0){
  cat("\nMissing R packages:\n\n")
  for(pkg in missing_packages){
    if(pkg=="BITEV2"){
      if (!requireNamespace("devtools", quietly = TRUE)) {
        install.packages('pkgdown')
        install.packages('poolfstat')
        install.packages("devtools")
        library(devtools)
      }
      if (!require("BiocManager", quietly = TRUE))
        install.packages("BiocManager")
      BiocManager::install("SNPRelate", force = TRUE)
      library(devtools)
      url <- paste0(
        "https://raw.githubusercontent.com/",
        "marcomilanesi/BITE/master/",
        "BITEV2_2.1.2.tar.gz"
      )
      
      tmp <- tempfile(fileext = ".tar.gz")
      
      download.file(
        url,
        tmp,
        mode = "wb"
      )
      
      devtools::install_local(tmp)
      
      unlink(tmp)
    } else {
      install.packages(pkg)
    }
  }
  
  missing_recheck <- packages[
    !sapply(packages, requireNamespace, quietly = TRUE)
  ]
  
  if (length(missing_recheck) > 0) {
    
    cat("\nThe following packages are still missing:\n")
    cat(paste0(" - ", missing_recheck), sep = "\n")
    
    stop(
      "\nInstall the missing R packages manually and rerun the script."
    )
    
  }
  
} else {
  
  cat("[OK] All required R packages are installed.\n")
  
}
