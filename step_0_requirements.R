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
    cat(sprintf(
      "sudo apt install %s\n",
      prg
    ))
  }
  stop("\nInstall the missing softwares and rerun the pipeline.")
} else {
  cat("Softwares installed in your system are compatible with future scripts.")
  cat("\nTest the R packages dependencies !")
}
