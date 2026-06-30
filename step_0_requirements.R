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
      cat("  1- sudo apt-get install libgsl-dev\ and sudo apt install libboost-all-devn\n")
      cat("  2- cd PATH_OF_EXTRACTED_TREEMIX\n")
      cat("  3- sudo ./configure\n")
      cat("  4- sudo make\n")
      cat("  5- sudo make install\n\n")
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
